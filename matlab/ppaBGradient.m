function g= ppaBGradient(covGrad)

% PPABGRADIENT - Function that finds the gradient of the covariance with respect to beta

g = trace(covGrad);