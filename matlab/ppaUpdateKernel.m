function model = ppaUpdateKernel(model, options)

% PPAUPDATEKERNEL Update the kernel parameters.

% Update the kernel parameters.

model=ppaOptimiseKernel(model, options.kernDisplay, options.kernIters);
model.kern.Kstore=kernCompute(model.kern, model.X);
model.kern.invKstore=pdinv(model.kern.Kstore);
