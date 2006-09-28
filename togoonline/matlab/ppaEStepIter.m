function [model,options] = ppaEStepIter(model,options)

% PPAESTEPITER A function that controls the number of E-step interations.
% FORMAT
% DESC A function that controls the number of E-step interations.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% RETURN options : The possibley updated options for the PPA model.

% PPA

if options.EstepIters > 0
    [model,options] = ppaEStep(model,options);

    if options.EstepIters > 1
        oldLogLikeE = ppaCalculateLogLike(model,options);
        counterE = 0;
        convergenceE = 0;
        
        while(convergenceE==0 & counterE < options.EstepIters)
        
            counterE=counterE+1;  
            
            [model,options] = ppaEStep(model,options);
            
            logLikeE = ppaCalculateLogLike(model,options);
            
            logLikeDiffE=logLikeE-oldLogLikeE;
            
            % Check for loglike going down
            if(logLikeDiffE<0)
                if(logLikeDiffE < -options.tol*1e-2)
                    % If the loglike goes down display warning of this
                    warning('E step Log likelihood went down');
                end

            else
                if(logLikeDiffE<options.tol)
                    convergenceE=1;
                    %fprintf('Algorithm has converged');
                end
            end

            oldLogLikeE=logLikeE;
        end

        if convergenceE ~=1
            fprintf('E step has reached maximum number of iterations');
        end
    end
end