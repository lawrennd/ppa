function ppaGunnarData(dataSet, dataNum, kernelType, invWidth)

% PPAGUNNARDATA Script for running experiments on Gunnar data.

% PPA

% Load the data
HOME = getenv('HOME');

fprintf('Dataset: %s, number %d, inverse width %2.4f', dataSet, dataNum, invWidth)

% Set up base directory
fs = filesep;
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];

% Load the training dataset
X=load([baseDir dataSet '_train_data_' num2str(dataNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataNum) '.asc']);

% Define the noise model to be used
noiseModel='probit';

% Load PPA options 
options = ppaOptions;
options.maxOuterIter =19000; % Set max number of iterations
options.scalarB = 1; % make beta a single scalar.

model=ppa(X, y, noiseModel, kernelType);

model.kern.comp{1}.inverseWidth = invWidth; % Set the inital value for the inverse width

% Display initial model
fprintf('Initial model:\n');
ppaDisplay(model);

% Train the model
model=ppaOptimisePPA(model, options);

% Display the model after training
fprintf('Final model:\n');
ppaDisplay(model);
fprintf('B: %2.4f\n', model.B(1, 1));

% Load the test set
Xtest=load([baseDir dataSet '_test_data_' num2str(dataNum) '.asc']);
ytest=load([baseDir dataSet '_test_labels_' num2str(dataNum) '.asc']);

% Calculate the class error
yPred = ppaOut(model, Xtest);
classError = 1- sum(ytest ==yPred)/length(ytest);

% Calculate final log-likelihood
ll = ppaCalculateLogLike(model);

% Display class error and likelihood values
fprintf('Test Error %2.4f\n', classError);
fprintf('Model likelihood %2.4f\n', ll);

% Recover and save all the required information
beta = model.B(1, 1);
kernParam = kernExtractParam(model.kern);
noiseParam = noiseExtractParam(model.noise);
numIters = model.numIters;
invWidthStr = num2str(invWidth);
ind = find(invWidthStr=='.')
invWidthStr(ind) = 'p';
save(['ppa' dataSet num2str(dataNum) kernelType{1} '_' invWidthStr], 'classError', 'll', ...
     'beta', 'kernParam', 'noiseParam', 'numIters')
     