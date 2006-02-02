function g = ppaBetaScalGradient(params, model)

% PPABETASCALGRADIENT Gradient of likelihood approximation wrt beta parameter.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.B = BExpandParam(model.B, params);
g = ppaBetaScalLogLikeGrad(model);
g = -g;

