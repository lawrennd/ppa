% DEMPPA3 A simple demonstration on the Banana data.

% PPA

% Alternative data set the can not be solved linearly
X=load('../data/banana_train_data_1.asc');
y=load('../data/banana_train_labels_1.asc');


% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

model=ppa(X, y, noiseModel, kernelType);

[model]=ppaOptimisePPA(model, options)

%save('dem3NV', 'savedLoglike');

