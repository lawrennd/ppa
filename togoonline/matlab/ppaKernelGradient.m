function g = ppaKernelGradient(params, model)

% PPAKERNELGRADIENT Gradient of likelihood approximation wrt kernel parameters.
% FORMAT
% DESC Gradient of likelihood approximation wrt kernel parameters.
% ARG params : The current params vector.
% ARG model : The current PPA model.
% RETURN g : The calculated value of the gradient.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.kern = kernExpandParam(model.kern, params);
g = ppaKernelLogLikeGrad(model);
g = g + kernPriorGradient(model.kern);
g = -g;

