function g = BGradient(covGrad)

% BETAGRADIENT Gradient of Beta parameters.
% FORMAT
% DESC Gradient of Beta parameters.
% ARG covGrad : The gradient matrix of the covariance.
% RETURN g : The calculated value of the gradient.

% PPA

g = trace(covGrad);
