function g = ppaVarLikeCovarianceGradient(invK, m)

% PPAVARLIKECOVARIANCEGRADIENT The gradient of the variational likelihood approximation wrt the covariance.

% PPA

invKMInvK = invK*m*invK;

g = -invK + invKMInvK;
g= g*.5;
