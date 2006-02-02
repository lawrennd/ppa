function g = ppaVarLikeKernelGradient(params, model)

% PPAVARLIKEKERNELGRADIENT Gradient of variational likelihood approximation wrt kernel parameters.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.kern = kernExpandParam(model.kern, params);
g = ppaVarLikeKernelLogLikeGrad(model);
g = g + kernPriorGradient(model.kern);
g = -g;
