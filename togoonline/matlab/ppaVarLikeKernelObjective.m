function f = ppaVarLikeKernelObjective(params, model)

% PPAVARLIKEKERNELOBJECTIVE Variational Likelihood Kernel approximation.
% FORMAT
% DESC Variational Likelihood Kernel approximation.
% ARG params : A vector of the current param values.
% ARG model : The current PPA model.
% RETURN f : The calculated value of the variational Kernel objective.
 
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
