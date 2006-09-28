function [mu, varsigma] = ppaPosteriorMeanVar(model, X);

% PPAPOSTERIORMEANVAR Mean and variances of the posterior at points given by X.
% FORMAT
% DESC Mean and variances of the posterior at points given by X.
% ARG model : The current PPA model.
% ARG X : The input dataset (normally a test set).
% RETURN mu : Vector of means of the label values of the input data set X.
% RETURN varsigma : Vector of variances of the label values of the input data set X.
 
% PPA 

D = size(model.y, 2);


if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    numData = size(model.X, 1);
    numOut = size(model.y, 2);
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    

numData = size(X, 1);

varsigma = zeros(numData, D);
mu = zeros(numData, D);

% Compute kernel for new point.
kX = kernCompute(model.kern, X, model.X)';

% Compute diagonal of kernel for new point.
diagK = kernDiagCompute(model.kern, X);
for i = 1:D
  invSigma = pdinv(diag(1./B(:,i)) + model.kern.Kstore);
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
