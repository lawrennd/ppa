function g = ppaBCovarianceGradient(invK, m)

% PPABCOVARIANCEGRADIENT The gradient of the likelihood approximation wrt the covariance.
% FORMAT
% DESC   The gradient of the likelihood approximation wrt the covariance.
% ARG invK : The posterior covariance.
% ARG m : The posterior mean.
% RETURN g : The calculated value of the gradient.

% PPA

invKm = invK*m;

g = -invK + invKm*invKm';
g= g*.5;
