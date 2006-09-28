function y = ppaOut(model, x);

% PPAOUT Evaluate the output of an ppa model.
% FORMAT
% DESC Evaluate the output of an ppa model.
% ARG model : The current ppa model.
% ARG x : The test input data.
% RETURN y : Predicted labels.

% PPA

[mu, varsigma] = ppaPosteriorMeanVar(model, x);
y = noiseOut(model.noise, mu, varsigma);
