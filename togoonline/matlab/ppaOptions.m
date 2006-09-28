function options = ppaOptions;

% PPAOPTIONS Default options for the probabilistic point assimilation.
% FORMAT
% DESC Default options for the probabilistic point assimilation.
% RETURN options : A vector containing the default ppa option values.

% PPA

options.display = 2; % this is display for likelihood changes.
options.kernDisplay = 0;% this is display for kernel optimisation.
options.BDisplay = 0;% this is display for Beta optimisation.
options.noiseDisplay = 0; % this is the display for the noise optimisation
options.tol = 1e-7; % this gives the likelihood tolerance.
options.scalarB = 1;
options.maxOuterIter = 100;
options.kernIters =100;%500;
options.BIters = 500;
options.noiseIters = 50;
options.varKern = 0; % this determines whether we use the variational kernel likelihood
options.doMStep = 1;
options.updateBeta = 1;
options.updateNoise = 0;
options.rememLoglikeVals = 0;
options.doDebug = 0;
options.EstepIters = 1;
options.typeEStep = 1;
options.KLCheck = 0;
options.optimiser = 'scg';