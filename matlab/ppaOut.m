function y = ppaOut(model, x);

% PPAOUT Evaluate the output of an ivm model.

% PPA

[mu, varsigma] = ppaPosteriorMeanVar(model, x);
y = noiseOut(model.noise, mu, varsigma);
