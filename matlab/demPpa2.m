% DEMPPA2 A simple overlapping data set.

% PPA

X=load('../data/overlap_train_data_1.asc');
y=load('../data/overlap_train_labels_1.asc');


% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

model=ppa(X, y, noiseModel, kernelType);
model=ppaOptimisePPA(model, options);



