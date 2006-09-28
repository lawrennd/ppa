function model = ppaUpdateKernel(model, options)

% PPAUPDATEKERNEL Update the kernel parameters.
% FORMAT
% DESC Update the kernel parameters.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% SEEALSO ppaOptimiseKernel, ppaVarLikeOptimiseKernel
 
% PPA 
    
% Update the kernel parameters.
if ~options.varKern
 model=ppaOptimiseKernel(model, options.kernDisplay, options.kernIters,options.optimiser);

 if options.display
     fprintf('Using KL kernel update - ');
 end
 
else
 model=ppaVarLikeOptimiseKernel(model, options.kernDisplay, options.kernIters,options.optimiser);
 if options.display
     fprintf('Using variational kernel update - ');
 end
end


model.kern.Kstore=kernCompute(model.kern, model.X);
model.kern.invKstore=pdinv(model.kern.Kstore);
