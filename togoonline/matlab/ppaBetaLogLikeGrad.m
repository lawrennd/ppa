function g = ppaBetaLogLikeGrad(model)

% PPABETALOGLIKEGRAD Gradient of the beta likelihood wrt beta parameter.
% FORMAT
% DESC Gradient of the beta likelihood wrt beta parameter.
% ARG model : The current PPA model.
% RETURN g : The calculated value of the gradient.

% PPA

x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);

g=0;

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
  invK = pdinv(K+diag(1./B(:, 1)));
end

for j = 1:size(m, 2)
  if ~model.noise.spherical
    invK = pdinv(K+diag(1./B(:, j)));
  end
  covGrad = feval([model.type 'BCovarianceGradient'], invK, m(:, j));
  
  g = g - (B(:,j).^-2).*ppaBVecGradient(covGrad);
  
  
  g = g - 0.5.*(model.expectations.ff(:,j)-m(:,j).*m(:,j));      

  
end  
fhandle = str2func([model.betaTransform 'Transform']);
g = g.*fhandle(model.B, 'gradfact');  g=g';
