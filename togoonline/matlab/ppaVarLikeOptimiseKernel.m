function model = ppaVarLikeOptimiseKernel(model, display, iters,optAlg);

% PPAVARLIKEOPTIMISEKERNEL Optimise the kernel parameters using the variational log-likelihood.
% FORMAT
% DESC Optimise the kernel parameters.
% ARG model : The current PPA model.
% ARG display : Option to display kernel optimisation information.
% ARG iters : The number of optimisation iterations.
% RETURN model : The updated PPA model.
% SEEALSO ppaVarLikeKernelObjective, ppaVarLikeKernelGradient
 
% PPA 

if nargin < 4
    optAlg = 'scg';
end

if nargin < 3
  iters = 500;
  if nargin < 2
    display = 1;
  end
end
options = defaultOptions;
if display
  options(1) = 1;
end
options(14) = iters;

model = optimiseParams('kern', optAlg, 'ppaVarLikeKernelObjective', ...
                       'ppaVarLikeKernelGradient', options, model);