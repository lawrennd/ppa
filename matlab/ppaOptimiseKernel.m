function model = ppaOptimiseKernel(model, display, iters);

% PPAOPTIMISEKERNEL Optimise the kernel parameters.

% PPA

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


model = optimiseParams('kern', 'scg', 'ppaKernelObjective', ...
                       'ppaKernelGradient', options, model);
  