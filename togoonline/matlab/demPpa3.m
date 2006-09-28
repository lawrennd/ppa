% DEMPPA3 PPA DEMONSTRATION THREE
% FORMAT
% DESC A simple demonstration of the probabilistic point assimilation using
% the Banana data set.

% PPA

% Alternative data set the can not be solved linearly
X=load('../data/banana_train_data_1.asc');
y=load('../data/banana_train_labels_1.asc');

X=X(1:50,:);
y=y(1:50,:);
% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

options.varKern =0;
options.maxOuterIter = 600;
options.tol = 1e-5;
options.updateBeta = 1;
options.scalarB = 0;
model=ppa(X, y, noiseModel, kernelType);
[model]=ppaOptimisePPA(model, options);