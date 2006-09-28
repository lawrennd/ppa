% DEMREGRESSION1 PPA REGRESSION DEMONSTRATION
% FORMAT
% DESC A simple demonstration of the probabilistic point assimilation using
% a data-set which is sampled from a GP with known parameters.

% PPA

% Sample a regression data-set.
[X, y] = ppaLoadData('regressionOne');

% Reduce number of test points
noiseModel = 'gaussian';

% Just use the rbf ard kernel.
kernelType = {'rbfard', 'linard', 'white'};

options = ppaOptions;
options.display = 2; % display graphically as we go.
options.varKern =0;

options.tol = 1e-5;

model=ppa(X, y, noiseModel, kernelType);

model.options.scalarB =0;

model=ppaOptimisePPA(model, options);

