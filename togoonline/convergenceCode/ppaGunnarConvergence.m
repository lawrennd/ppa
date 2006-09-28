function ppaGunnarConvergence(dataSet,dataNum,kernelType)

% PPAGUNNARCONVERGENCE A function that compares the KL likelihood with the
% standard variational likelihood then saves the results

% PPA


fprintf('Dataset: %s, number %d',  dataSet, dataNum)


% Set up the home directory value
HOME = getenv('HOME');

% My desktop
% HOME='h:\'

% My laptop home
HOME='d:\work\'

% My pascal cluster home
%HOME = '/home/nk3';

% Load the given dataset
fs = filesep;
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];
X=load([baseDir dataSet '_train_data_' num2str(dataNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataNum) '.asc']);


% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf', 'white', 'bias'};


options = ppaOptions;
options.display = 1; % display graphically as we go.
options.rememLoglikeVals = 1; % set option to record likelihood and cpu values
options.varKern=0; % Do updates with KL correction

model=ppa(X, y, noiseModel, kernelType); 

model.kern.comp{1}.inverseWidth = 0.1; % Set intial inverseWidth param

[model, KLLogLike,KLCPU]=ppaOptimisePPA(model, options);


KLCPUAVE=mean(KLCPU); % The average cpu time per iteration
numKLIters = model.numIters; % The total number of Iterations
KLFinalLogLike = model.logLike; % The final Value of the log likelihood



% Calculate class error
Xtest=load([baseDir dataSet '_test_data_' num2str(dataNum) '.asc']);
ytest=load([baseDir dataSet '_test_labels_' num2str(dataNum) '.asc']);

yPred = ppaOut(model, Xtest);
KLClass = 1- sum(ytest ==yPred)/length(ytest);

%ll = ppaCalculateLogLike(model,options);
fprintf('Test Error %2.4f\n', KLClass);



% Do updates with SV correction
options.varKern=1;

X=load([baseDir dataSet '_train_data_' num2str(dataNum) '.asc']);
y=load([baseDir dataSet '_train_labels_' num2str(dataNum) '.asc']);

model=ppa(X, y, noiseModel, kernelType);

[model, SVLogLike,SVCPU]=ppaOptimisePPA(model, options);

SVCPUAVE=mean(SVCPU);  % The average cpu time per iteration
numSVIters = model.numIters; % The total number of Iterations
SVFinalLogLike = model.logLike; % The final Value of the log likelihood

% Calculate class error
Xtest=load([baseDir dataSet '_test_data_' num2str(dataNum) '.asc']);
ytest=load([baseDir dataSet '_test_labels_' num2str(dataNum) '.asc']);

yPred = ppaOut(model, Xtest);
SVClass = 1- sum(ytest ==yPred)/length(ytest);


%ll = ppaCalculateLogLike(model);
fprintf('\n Test Error %2.4f\n', SVClass);

ppaBaseDir = [HOME filesep 'mlprojects' filesep 'ppa'];
% Check to see if the directory for saving exists
if isdir([ppaBaseDir  filesep 'conv'])~=1
    mkdir([ppaBaseDir filesep],'conv');
end

% Save these Results
save([ppaBaseDir  'conv' filesep dataSet 'convergence_' num2str(dataNum) '.mat'],  'KLLogLike', 'numKLIters', 'KLFinalLogLike','KLCPU','KLCPUAVE','KLClass',...
    'SVLogLike', 'numSVIters', 'SVFinalLogLike','SVCPU','SVCPUAVE','SVClass')
