function classError = ppaGunnarTest(dataSet, dataNum, kernelType, ...
                                    kernParams, noiseParams, beta)

% PPAGUNNARTEST Script for running tests on Gunnar data.

% PPA

% Load the data
HOME = getenv('HOME');


fprintf('Dataset: %s, number %d\n', dataSet, dataNum)

% Set up base directory
fs = filesep;
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];

% Load the training set
X=load([baseDir dataSet '_train_data_' num2str(dataNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataNum) '.asc']);

% Define the noise model to be used
noiseModel='probit';

% Load the ppa options and the set options 
% see we don't train the M step parameters
options = ppaOptions;
options.maxOuterIter = 50;
options.scalarB = 1; % make beta a single scalar.
options.kernIters=0;
options.display = 0;
options.doMStep = 0;

model=ppa(X, y, noiseModel, kernelType);

% Assign the learnt M set parameter
model.kern = kernExpandParam(model.kern, kernParams);
model.noise = noiseExpandParam(model.noise, noiseParams);
model.B = beta;

% Display initial model
fprintf('Initial model:\n');
ppaDisplay(model);

% Optimise E step parameters
model=ppaOptimisePPA(model, options);

% Display the final model parameters
fprintf('Final model:\n');
ppaDisplay(model);
fprintf('B: %2.4f\n', model.B(1, 1));

% Load the test set
Xtest=load([baseDir dataSet '_test_data_' num2str(dataNum) '.asc']);
ytest=load([baseDir dataSet '_test_labels_' num2str(dataNum) '.asc']);

% Equate the class error
yPred = ppaOut(model, Xtest);
classError = 1- sum(ytest ==yPred)/length(ytest);

% Calcualte the log-likelihood
ll = ppaCalculateLogLike(model);

% Display class error and likelihood
fprintf('Test Error %2.4f\n', classError);
fprintf('Model likelihood %2.4f\n', ll);

% Save results
beta = model.B;
numIters = model.numIters;
save(['ppa' dataSet num2str(dataNum) 'Test'], 'classError', 'll', ...
     'beta', 'numIters');

% Display the functions completion
fprintf('Data saved ... job finishing ...\n')
     