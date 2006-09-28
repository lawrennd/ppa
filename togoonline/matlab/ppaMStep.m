function [model,options]= ppaMStep(model, options)

% PPAMSTEP Perform the M-step for probabilistic point assimilation.
% FORMAT
% DESC Perform the M-step for probabilistic point assimilation.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% RETURN options : The updated options for the PPA model.
% SEEALSO ppaUpdateKernel, ppaUpdateBeta, ppaDebugTool
 
% PPA 

if options.doDebug
    if options.varKern
        model = ppaDebugTool(model,options,'SV-Mstep-Begin-Kern');    
    else
        model = ppaDebugTool(model,options,'KL-Mstep-Begin-Kern');
    end
end

% Call the update for the K Kernel
if options.kernIters
  model = ppaUpdateKernel(model, options);
end

if options.doDebug
    if options.varKern
        model = ppaDebugTool(model,options,'SV-Mstep-End-Kern');    
        model = ppaDebugTool(model,options,'SV-Mstep-Begin-Beta');    
    else
        model = ppaDebugTool(model,options,'KL-Mstep-End-Kern');
        model = ppaDebugTool(model,options,'KL-Mstep-Begin-Beta');    
    end
end


if options.updateBeta
  
    model = ppaUpdateBeta(model,options);
end


if options.doDebug
    if options.varKern
        model = ppaDebugTool(model,options,'SV-Mstep-End-Beta');    
    else
        model = ppaDebugTool(model,options,'KL-Mstep-End-Beta');    
    end
end