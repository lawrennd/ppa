function g = ppaBetaGradient(params, model)

% PPABETAGRADIENT Gradient of likelihood approximation wrt beta parameter.
% FORMAT
% DESC Gradient of likelihood approximation wrt beta parameter.
% ARG params : The current params vector.
% ARG model : The current PPA model.
% RETURN g : The calculated value of the gradient.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.B = BExpandParam(model.B, params);
g = ppaBetaLogLikeGrad(model);
g = -g;

