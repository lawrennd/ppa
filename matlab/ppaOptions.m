function options = ppaOptions;

% PPAOPTIONS Default options for the probabilistic point assimilation.

% PPA

options.display = 0; % this is display for likelihood changes.
options.kernDisplay = 0; % this is display for kernel optimisation.
options.tol = 1e-5; % this gives the likelihood tolerance.
options.scalarB = 1;
options.maxOuterIter = 5000;
options.kernIters = 100;
options.varKern = 0; % this determines whether we use the variational kernel likelihood