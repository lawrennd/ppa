% DEMPPA1 A simple demonstration of the probabilistic point assimilation.

% PPA

% Load the data
X=load('..\data\rand_data.asc');
y=load('..\data\rand_labels.asc');

% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

model=ppa(X, y, noiseModel, kernelType);
model=ppaOptimisePPA(model, options);



