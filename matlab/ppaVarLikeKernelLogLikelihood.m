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
  [invK, UK] = pdinv(K);
  logDetTerm = logdet(K, UK);
end
  
for i = 1:size(m, 3)
  if ~model.noise.spherical
    [invK, UK] = pdinv(K);
    logDetTerm = logdet(K, UK);
  end
  
  L = L -.5*logDetTerm- .5*sum(sum(m(:, :, i).*invK));
  
end