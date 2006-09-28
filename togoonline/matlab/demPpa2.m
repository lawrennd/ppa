% DEMPPA2 PPA DEMONSTRATION TWO
% FORMAT
% DESC A simple demonstration of the probabilistic point assimilation using
% the overlapping data set.

% PPA


X=load('../data/overlap_train_data_1.asc');
y=load('../data/overlap_train_labels_1.asc');

% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias','whitefixed'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

options.varKern =0;

model=ppa(X, y, noiseModel, kernelType);

model=ppaOptimisePPA(model, options);



