function options = ppaOptions;

% PPAOPTIONS Default options for the probabilistic point assimilation.

% PPA

options.display = 0; % this is display for likelihood changes.
options.kernDisplay = 0; % this is display for kernel optimisation.
options.tol = 1e-6; % this gives the likelihood tolerance.
options.scalarB = 0;
options.maxOuterIter = 1000;
options.kernIters = 100;
