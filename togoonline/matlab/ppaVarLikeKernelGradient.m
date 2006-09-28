function g = ppaVarLikeKernelGradient(params, model)

% PPAVARLIKEKERNELGRADIENT Gradient of variational likelihood approximation wrt kernel parameters.
% FORMAT
% DESC Gradient of variational likelihood approximation wrt kernel parameters.
% ARG params : The current params matrix.
% ARG model : The current PPA model.
% RETURN g : The calculated value of the gradient.
 
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
