% DEMPPA4 A simple demonstration. 

% PPA


randn('seed', 1e6)
rand('seed', 1e6)

% Generate a toy data-set
numDataPart = 100;
[X, y] = generateCrescentData(numDataPart);
unlab = find(rand(size(y))>10/numDataPart);
y(unlab) = NaN;
lab = find(~isnan(y));
% Define the noise model to be used
noiseModel='ncnm';

% Define the kernel to be used
kernelType={'rbf', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.

model=ppa(X(lab, :), y(lab, :), noiseModel, kernelType);
% set noise width
model.noise.width = 1;
% set L1 regularisers on kernel.
prior.type = 'gamma';
prior = priorParamInit(prior);
prior.a = 1;
prior.b = 1;
prior.index = 2;
model.kern.comp{1}.priors(1) = prior;
prior.index = 1;
model.kern.comp{2}.priors(1) = prior;
%model.kern.comp{3}.priors(1) = prior;
model=ppaOptimisePPA(model, options);
b = model.B(1, 1);
model=ppa(X, y, noiseModel, model.kern);
model.noise.width = 1;
model=ppaOptimisePPA(model, options);

