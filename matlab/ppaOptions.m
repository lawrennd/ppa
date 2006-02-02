function options = ppaOptions;

% PPAOPTIONS Default options for the probabilistic point assimilation.

% PPA

options.display = 0; % this is display for likelihood changes.
options.kernDisplay = 0;% this is display for kernel optimisation.
options.BDisplay = 0;% this is display for Beta optimisation.
options.tol = 1e-6; % this gives the likelihood tolerance.
options.scalarB = 1;
options.maxOuterIter = 9000;
options.kernIters = 500;
options.BIters = 500;
options.varKern = 0; % this determines whether we use the variational kernel likelihood
options.doMStep = 1;
options.updateBeta =0;
options.rememLoglikeVals = 0;
options.doDebug =0;