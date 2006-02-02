function g = BGradient(covGrad)

% BETAGRADIENT Gradient of Beta parameters.

% BETA

g = trace(covGrad);
