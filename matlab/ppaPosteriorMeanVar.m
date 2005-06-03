function [mu, varsigma] = ppaPosteriorMeanVar(model, X);

% PPAPOSTERIORMEANVAR Mean and variances of the posterior at points given by X.

% PPA

D = size(model.y, 2);
numData = size(X, 1);

varsigma = zeros(numData, D);
mu = zeros(numData, D);

% Compute kernel for new point.
kX = kernCompute(model.kern, X, model.X)';

% COmpute diagonal of kernel for new point.
diagK = kernDiagCompute(model.kern, X);
for i = 1:D
  invSigma = pdinv(diag(1./model.B(:,i)) + model.kern.Kstore);
  Kinvk = invSigma*kX;
  for n = 1:numData
    varsigma(n, i) = diagK(n) - kX(:, n)'*invSigma*kX(:, n);
  end
  if any(varsigma(:, i) < 0)
    warning('Varsigma values less than zero, setting to zero.');
    varsigma(find(varsigma(:, i)<0), i)=0;
  end
  mu(:, i) = Kinvk'*model.expectations.fBar(:, i);
end
