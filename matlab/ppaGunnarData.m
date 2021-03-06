function ppaGunnarData(dataSet, dataNum, kernelType, invWidth)

% PPAGUNNARDATA Script for running experiments on Gunnar data.

% PPA

% Load the data
HOME = getenv('HOME');
fprintf('Dataset: %s, number %d, inverse width %2.4f', dataSet, dataNum, invWidth)
HOME='h:'
fs = filesep;
baseDir = [HOME filesep 'datasets' filesep 'gunnar' filesep dataSet filesep];
X=load([baseDir dataSet '_train_data_' num2str(dataNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataNum) '.asc']);

% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
options = ppaOptions;
options.maxOuterIter = 300;
options.scalarB = 1; % make beta a single scalar.
model=ppa(X, y, noiseModel, kernelType);
model.kern.comp{1}.inverseWidth = invWidth;
fprintf('Initial model:\n');
ppaDisplay(model);
model=ppaOptimisePPA(model, options);

fprintf('Final model:\n');
ppaDisplay(model);
fprintf('B: %2.4f\n', model.B(1, 1));
Xtest=load([baseDir dataSet '_test_data_' num2str(dataNum) '.asc']);
ytest=load([baseDir dataSet '_test_labels_' num2str(dataNum) '.asc']);

yPred = ppaOut(model, Xtest);
classError = 1- sum(ytest ==yPred)/length(ytest);

ll = ppaCalculateLogLike2(model);
fprintf('Test Error %2.4f\n', classError);
fprintf('Model likelihood %2.4f\n', ll);

beta = model.B(1, 1);
kernParam = kernExtractParam(model.kern);
noiseParam = noiseExtractParam(model.noise);
numIters = model.numIters;
invWidthStr = num2str(invWidth);
ind = find(invWidthStr==48);
invWidthStr(46) = 'p';
save(['ppa' dataSet num2str(dataNum) kernelType{1} invWidthStr], 'classError', 'll', ...
     'beta', 'kernParam', 'noiseParam', 'numIters')
     