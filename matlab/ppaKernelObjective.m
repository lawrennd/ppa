function f = ppaKernelObjective(params, model)

% PPAKERNELOBJECTIVE Likelihood approximation.

% PPA
%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.kern = kernExpandParam(model.kern, params);
f = ppaKernelLogLikelihood(model);
f = f + kernPriorLogProb(model.kern);
f = -f;
