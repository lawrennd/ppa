function g = ppaVarLikeKernelLogLikeGrad(model)

% PPVARLIKEAPPROXLOGLIKEKERNGRAD Gradient of the kernel variational likelihood wrt kernel parameters.

% PPA

x = model.X;
numData = size(x, 1);
m = model.expectations.fBarfBar;
K = kernCompute(model.kern, x);
g = zeros(1, model.kern.nParams);

if model.noise.spherical
  % there is only one value for all beta
  invK = pdinv(K);
end

for j = 1:size(m, 3)
  if ~model.noise.spherical
    invK = pdinv(K);
  end
  covGrad = feval([model.type 'VarLikeCovarianceGradient'], invK, m(:,:, j));
  g = g + kernGradient(model.kern, x, covGrad);
end  
