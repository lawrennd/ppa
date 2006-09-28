function f = ppaBetaObjective(params, model)

% PPABETAOBJECTIVE Likelihood approximation.
% FORMAT
% DESC Likelihood approximation.
% ARG params : The current params vector.
% ARG model : The current PPA model.
% RETURN f : The calculated value of the kernel objective.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.B = BExpandParam(model.B, params);
f = ppaBetaLogLikelihood(model);
f = -f;