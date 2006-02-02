function L = ppaBetaScalLogLikelihood(model);

% PPABETASCALLOGLIKELIHOOD Return the approximate log-likelihood for the PPA.

% PPA

x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);
L = 0;

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    numData = size(model.X, 1);
    numOut = size(model.y, 2);
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    

if model.noise.spherical
  % there is only one value for all beta
  [invK, UK] = pdinv(K+diag(1./B(:, 1)));
  logDetTerm = logdet(K+diag(1./B(:, 1)), UK);
end
  
for i = 1:size(m, 2)
  if ~model.noise.spherical
    [invK, UK] = pdinv(K+diag(1./B(:, i)));
    logDetTerm = logdet(K+diag(1./B(:, 1)), UK);
  end
  L = L -.5*logDetTerm - .5*m(:, i)'*invK*m(:, i);
  
  L = L - 0.5.*sum(B(:,i).*(model.expectations.ff(:,i)-m(:,i).*m(:,i)));
  
end
