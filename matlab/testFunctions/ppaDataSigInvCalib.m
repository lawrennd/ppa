function ppaDataSigInvCalib(dataSet, dataSetNum, kernelType, sigVal,dataNum)

%function ppaGridData(dataSet, dataSetNum, kernelType, logsqrtvar, logwidth,dataNum)

% PPAGRIDDATACALIB Script for running experiments on calibrations on the data.

% PPA

% Load the data
HOME = getenv('HOME');
% for laptop
HOME='d:\work';
% for cluster
%HOME = '/home/nk3';
fs = filesep;
%dataSet = 'rand';
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];
X=load([baseDir dataSet '_train_data_' num2str(dataSetNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataSetNum) '.asc']);


%% Load the data
%X=load('../../data/rand_data.asc');
%y=load('../../data/rand_labels.asc');

% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','whitefixed'};

options = ppaOptions;

options.display = 1; % display graphically as we go.

model=ppa(X, y, noiseModel, kernelType);

model.kern.comp{2}.variance = sigVal-5e-7;


% Set the noise model to match the paper
model.noise.bias = zeros(1, model.noise.nParams);
model.noise.sigma2 = 1-sigVal-5e-7;

model.B = (1e-6)^-1;
options.updateBeta = 0;
%fprintf('B: %2.4f\n', model.B(1, 1));
model = ppaOptimisePPA(model, options);

% Testing section
fprintf('Final model:\n');
ppaDisplay(model);
fprintf('B: %2.4f\n', model.B(1, 1));
fprintf('log-like: %2.7f\n', model.logLike);
%fprintf('Positive probaility: %2.7f\n', model.posProb);
Xtest = load([baseDir dataSet '_test_data_' num2str(dataSetNum) '.asc']);
ytest = load([baseDir dataSet '_test_labels_' num2str(dataSetNum) '.asc']);

[classError, aveInfoVal, aveM] = ppaClassAverageInformation(ytest, Xtest,model)

ll = model.logLike;

     %betaVal+model.kern.comp{2}.variance+model.noise.sigma2

beta = model.B(1, 1);
kernParam = kernExtractParam(model.kern);
noiseParam = noiseExtractParam(model.noise);
numIters = model.numIters;
dataNumstr = num2str(dataNum);
invWidthStr(46) = 'p';
save([HOME filesep 'mlprojects' filesep 'ppa' filesep 'icmlpaper' filesep dataSet filesep 'calibTests' filesep 'ppa_siginv' dataSet '_' num2str(dataSetNum) '_' kernelType{1} dataNumstr],  'll', ...
     'beta', 'kernParam', 'noiseParam', 'numIters','classError', 'aveInfoVal', 'sigVal')
     

