function model = ppaMStep(model, options)

% PPAMSTEP Perform the M-step for probabilistic point assimilation.

% PPA

% Call the update for the K Kernel
if options.kernIters
  model = ppaUpdateKernel(model, options);
end
% Call the update for the B kernel
if options.scalarB
  model = ppaUpdateBscalar(model);
else
  model = ppaUpdateB(model);
end
