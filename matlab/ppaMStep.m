function model = ppaMStep(model)

% PPAMSTEP Perform the M-step for probabilistic point assimilation.

% PPA

% Call the update for the B kernel
model = ppaUpdateBscalar(model);

% Call the update for the K Kernel
model = ppaUpdateKernel(model);