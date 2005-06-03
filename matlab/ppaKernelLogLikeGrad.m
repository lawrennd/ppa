function g = ppaKernelLogLikeGrad(model)

% PPAKERNELLOGLIKEGRAD Gradient of the kernel likelihood wrt kernel parameters.

% PPA

x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);
g = zeros(1, model.kern.nParams);

if model.noise.spherical
  % there is only one value for all beta
  invK = pdinv(K+diag(1./model.B(:, 1)));
end

for j = 1:size(m, 2)
  if ~model.noise.spherical
    invK = pdinv(K+diag(1./model.B(:, j)));
  end
  covGrad = feval([model.type 'CovarianceGradient'], invK, m(:, j));
  g = g + kernGradient(model.kern, x, covGrad);
end  
