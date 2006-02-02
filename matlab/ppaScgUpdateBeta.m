function model = ppaScgUpdateBeta(model,options)

% PPASCGUPDATEBETA - A function that updates the Beta parameter set

% PPA

if ~options.varKern
    % KL corrected Beta Update    
    model = ppaOptimiseB(model,options.BDisplay,options.BIters,options.scalarB);
else
    % Standard variational Beta Update    
    model = ppaVarLikeOptimiseB(model,options.BDisplay,options.BIters,options.scalarB);
end