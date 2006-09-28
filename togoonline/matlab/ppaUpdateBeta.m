function model = ppaUpdateBeta(model,options)

% PPAUPDATEBETA A function that updates the Beta parameter set
% FORMAT
% DESC A function that updates the Beta parameter set
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% SEEALSO ppaOptimiseB, ppaVarLikeOptimiseB
 
% PPA 
    
if ~options.varKern
    % KL corrected Beta Update    
    
    model = ppaOptimiseB(model,options.BDisplay,options.BIters,options.scalarB,options.optimiser);
else
    % Standard variational Beta Update    
    model = ppaVarLikeOptimiseB(model,options.BDisplay,options.BIters,options.scalarB,options.optimiser);
end