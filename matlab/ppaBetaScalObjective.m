function f = ppaBetaScalObjective(params, model)

% PPABETASCALOBJECTIVE Likelihood approximation.

% PPA
%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.B = BExpandParam(model.B, params);
f = ppaBetaScalLogLikelihood(model);
f = -f;
