function [model,options]= ppaEStep(model, options)

% PPAESTEP Perform the expectation step in the EM optimisation.
% FORMAT
% DESC Perform the expectation step in the EM optimisation.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% RETURN options : The updated options for the PPA model.
% SEEALSO noiseUpdateNuG, ppaExpectfBar, ppaExpectfBarfBar, ppaExpectf,
% ppaExpectff, ppaDebugTool
 
% PPA 

numData = size(model.X, 1);
numOut = size(model.y, 2);

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    
  
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-q(fBar)');    
            model = ppaDebugTool(model,options,'Expect-Begin-fBar');
        end

        model = ppaExpectfBar(model); % these are expectations under q(fBar)
        
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-End-fBar');  
            model = ppaDebugTool(model,options,'Expect-Begin-fBarfBar');  
        end

        model = ppaExpectfBarfBar(model); % these are expectations under q(fBar)
        
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-End-fBarfBar');   
        else
            [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,0);
        end

        % We can check at this point as whether the two bounds correspond
        if options.KLCheck
            model = ppaDebugTool(model,options,'KL-check');   
        end

        % Compute G and nu
        [model.g, model.nu] = noiseUpdateNuG(model.noise, model.expectations.fBar, ...
                                      1./B, ...
                                      model.y);
        % Compute gamma
        model.gamma = (((model.g).^2)-model.nu)/2;
        
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-q(f)');
            model = ppaDebugTool(model,options,'Expect-Begin-f');
        end

        model = ppaExpectf(model); % these are expectations under q(f)
        
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-End-f');  
            model = ppaDebugTool(model,options,'Expect-Begin-ff');  
        end

        model = ppaExpectff(model);
        
        if options.doDebug
            model = ppaDebugTool(model,options,'Expect-End-ff');   
        else
            if strcmp(model.noise.type,'gaussian')
                [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,0,1);
            end
        end
    