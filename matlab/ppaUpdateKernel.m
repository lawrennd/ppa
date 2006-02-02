function model = ppaUpdateKernel(model, options)

% PPAUPDATEKERNEL Update the kernel parameters.

% PPA

    
% Update the kernel parameters.
if ~options.varKern
 model=ppaOptimiseKernel(model, options.kernDisplay, options.kernIters);

 if options.display
     fprintf('Using non variational kernel update - ');
 end
else
 model=ppaVarLikeOptimiseKernel(model, options.kernDisplay, options.kernIters);
 if options.display
     fprintf('Using variational kernel update - ');
 end
end
model.kern.Kstore=kernCompute(model.kern, model.X);
model.kern.invKstore=pdinv(model.kern.Kstore);
