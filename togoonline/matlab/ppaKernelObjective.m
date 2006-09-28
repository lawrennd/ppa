function f = ppaKernelObjective(params, model)

% PPAKERNELOBJECTIVE Likelihood approximation.
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
model.kern = kernExpandParam(model.kern, params);
f = ppaKernelLogLikelihood(model);
f = f + kernPriorLogProb(model.kern);
f = -f;
