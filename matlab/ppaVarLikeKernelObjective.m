function f = ppaVarLikeKernelObjective(params, model)

% PPAVARLIKEKERNELOBJECTIVE Variational Likelihood Kernel approximation.

% PPA

%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

model.kern = kernExpandParam(model.kern, params);
f = ppaVarLikeKernelLogLikelihood(model);
f = f + kernPriorLogProb(model.kern);
f = -f;