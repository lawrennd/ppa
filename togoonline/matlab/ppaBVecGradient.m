function g = ppaBVecGradient(covGrad)

% PPABVecGRADIENT Function that finds the gradient of the covariance with respect to beta.
% FORMAT
% DESC Function that finds the gradient of the covariance with respect to beta.
% ARG covGrad : The posterior covariance gradient.
% RETURN g : The calculated value of the gradient.

% PPA

g = diag(covGrad);