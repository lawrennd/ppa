function g = ppaVarLikeCovarianceGradient(invK, m)

% PPAVARLIKECOVARIANCEGRADIENT The gradient of the variational likelihood
% approximation wrt the covariance.
% FORMAT
% DESC   The gradient of the variational likelihood approximation wrt the covariance.
% ARG invK : The posterior covariance.
% ARG m : The posterior mean.
% RETURN g : The calculated value of the gradient.
 
% PPA 

invKMInvK = invK*m*invK;
 
g = -invK + invKMInvK;
g= g*.5;
