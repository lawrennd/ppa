function g = ppaCovarianceGradient(invK, m)

% PPACOVARIANCEGRADIENT The gradient of the likelihood approximation wrt the covariance.

% PPA

invKm = invK*m;

g = -invK + invKm*invKm';
g= g*.5;
