function g = ppaKernelGradient(params, model)

% PPAKERNELGRADIENT Gradient of likelihood approximation wrt kernel parameters.

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

