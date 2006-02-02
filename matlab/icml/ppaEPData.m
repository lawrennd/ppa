function ppaEPData(dataSet, dataSetNum)

% PPAEPDATA Script for running experiments on calibrations on the data.

% PPA

% Load the data
HOME = getenv('HOME');
% for laptop
HOME='d:\work';
% for cluster
HOME = '/home/nk3';
fs = filesep;
%dataSet = 'rand';
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];
X=load([baseDir 'EPtests' filesep dataSet '_train_data_' num2str(dataSetNum) '.asc']);
y=load([baseDir 'EPtests' filesep dataSet '_train_labels_' num2str(dataSetNum) '.asc']);


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

% set now such that sigma2 + beta + sigma_white = 1
% defining betaVal as 1 - 2e-6
betaVal = 1 - 2e-6;
model.kern.comp{2}.variance = 1e-6;
model.B = 1./betaVal;

% Set the noise model to match the paper
model.noise.bias = zeros(1, model.noise.nParams);
model.noise.sigma2 = 1e-6;

options.updateBeta = 0;

model = ppaOptimisePPA(model, options);

% Testing section
fprintf('Final model:\n');
ppaDisplay(model);
fprintf('B: %2.4f\n', model.B);
fprintf('log-like: %2.7f\n', model.logLike);
%fprintf('Positive probaility: %2.7f\n', model.posProb);
Xtest = load([baseDir 'EPtests' filesep dataSet '_test_data_' num2str(dataSetNum) '.asc']);
ytest = load([baseDir 'EPtests' filesep dataSet '_test_labels_' num2str(dataSetNum) '.asc']);

[classError, aveInfoVal, aveM] = ppaClassAverageInformation(ytest, Xtest,model)

ll = model.logLike;


beta = model.B(1, 1);
kernParam = kernExtractParam(model.kern);
noiseParam = noiseExtractParam(model.noise);

numIters = model.numIters;
%invWidthStr = num2str(invWidth);
%dataNumstr = num2str(dataNum);
%ind = find(invWidthStr==48);
%invWidthStr(46) = 'p';
if isdir([HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep 'EPResults'])~=1
    mkdir([HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep],'EPResults');
end
save([HOME filesep 'mlprojects' filesep 'data'  filesep dataSet filesep 'EPResults' filesep 'ppa' dataSet '_' num2str(dataSetNum) '_' kernelType{1}],  'll', ...
     'beta', 'kernParam', 'noiseParam', 'numIters','classError', 'aveInfoVal', 'aveM','betaVal')
     

