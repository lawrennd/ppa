% DEMPPA1 PPA DEMONSTRATION ONE
% FORMAT
% DESC A simple demonstration of the probabilistic point assimilation using the random dataset.

% PPA

% Load the data
X=load('../data/rand_data.asc');
y=load('../data/rand_labels.asc');
X=X(1:15,:);
y=y(1:15,:);
% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'whitefixed'};


options = ppaOptions;
options.scalarB = 0;
options.BDisplay =1;
options.updateBeta =1;
options.KernDisplay = 1;
options.display = 2; % display graphically as we go.

 options.varKern =0;

model=ppa(X, y, noiseModel, kernelType);

model=ppaOptimisePPA(model, options);


% options = ppaOptions;
% options.display = 2; % display graphically as we go.
% 
% model=ppa(X, y, noiseModel, kernelType);
% model=ppaOptimisePPA(model, options);
% options.updateNoise = 1;
% options.maxOuterIter = 600;
% model.kern.comp{3}.variance = 1e-6;
