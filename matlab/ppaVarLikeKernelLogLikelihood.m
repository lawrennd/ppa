function L = ppaVarLikeKernelLogLikelihood(model);

% PPAVARLIKEKERNELLOGLIKELIHOOD Return the approximate variational log-likelihood for the PPA.

% PPA

x = model.X;
numData = size(x, 1);
m = model.expectations.fBarfBar;
K = kernCompute(model.kern, x);
L = 0;% should i have the two pi constant here -.5*numData*log(2*pi)

if model.noise.spherical
  % there is only one value for all beta
  [invK, UC] = pdinv(K);
  logDetTerm = logdet(K, UC);
end
  
for i = 1:size(m, 3)
  if ~model.noise.spherical
    [invK, UC] = pdinv(K);
    logDetTerm = logdet(K, UC);
  end
  L = L -.5*logDetTerm- .5*trace(m(:, :, i)*invK);
end