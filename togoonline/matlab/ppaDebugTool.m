function model = ppaDebugTool(model,options,debugType)

% PPADEBUGTOOL A function that can be used to debug PPA
% FORMAT
% DESC A function that can be used to debug PPA
% ARG model : The current PPA model.
% ARG options : The options of the ppa model.
% ARG debugType : The debug type.
% RETURN model : The updated PPA model.

% PPA

switch debugType
    
    case 'KL-Mstep-Begin-Kern'
        if strcmp(model.noise.type,'gaussian')
            
            model.updatediffs(1) = ppaCalculateRegressionKLLike(model);
        else
            
            % Use the difference KL kern slot to store the pre update value
            model.updatediffs(1) =  ppaKLMstepLikelihood(model);
        end

    case 'KL-Mstep-End-Kern'
        
       if strcmp(model.noise.type,'gaussian')
           newKernLike = ppaCalculateRegressionKLLike(model);
          
       else
           newKernLike = ppaKLMstepLikelihood(model);           
       end

       if(newKernLike-model.updatediffs(1)<0)
           fprintf('\n Problem with K, KL log-likelihood change %2.12f\n',newKernLike-model.updatediffs(1));
       end
       
       model.updatediffs(1) = newKernLike-model.updatediffs(1);
    
    
    case 'KL-Mstep-Begin-Beta'
        if strcmp(model.noise.type,'gaussian')
            model.updatediffs(2) = ppaCalculateRegressionKLLike(model);
            
        else
            model.updatediffs(2) = ppaKLMstepLikelihood(model);
        end
    
    
    case 'KL-Mstep-End-Beta'
        
        if strcmp(model.noise.type,'gaussian')
            newBetaLike = ppaCalculateRegressionKLLike(model);
        else
            newBetaLike = ppaKLMstepLikelihood(model);
        end

        model.updatediffs(2) = newBetaLike - model.updatediffs(2);
        
        if model.updatediffs(2) < 0
                    fprintf('\n Problem with B, KL log-likelihood change %2.12f\n',model.updatediffs(2));
        end
            
        
        
    case 'SV-Mstep-Begin-Kern'
        
        if strcmp(model.noise.type,'gaussian')
            model.updatediffs(1) = ppaCalculateRegressionLike(model);
        else
            model.updatediffs(1) = ppaSVMstepLikelihood(model);
        end
        
    case 'SV-Mstep-End-Kern'
        
        if strcmp(model.noise.type,'gaussian')
            newKernLike = ppaCalculateRegressionLike(model);
        else
            newKernLike = ppaSVMstepLikelihood(model);
        end
               
        model.updatediffs(1) = newKernLike - model.updatediffs(1);
        
        if(model.updatediffs(1)<0)
                fprintf('\n Problem with K, SV log-likelihood change %2.12f\n',model.updatediffs(1));
        end

    case 'SV-Mstep-Begin-Beta'
        
        if strcmp(model.noise.type,'gaussian')
            model.updatediffs(2) = ppaCalculateRegressionLike(model);
        else
            model.updatediffs(2) = ppaSVMstepLikelihood(model);
        end
        
    case 'SV-Mstep-End-Beta'
        
        if strcmp(model.noise.type,'gaussian')
            newBetaLike = ppaCalculateRegressionLike(model);
        else
            newBetaLike = ppaSVMstepLikelihood(model);
        end
               
        model.updatediffs(2) = newBetaLike - model.updatediffs(2);
        
        if(model.updatediffs(2)<0)
                fprintf('\n Problem with beta, SV log-likelihood change %2.12f\n',model.updatediffs(2));
        end
    
    case 'Expect-q(fBar)'
         if strcmp(model.noise.type,'gaussian')            
             model.updatediffs(7) = ppaCalculateRegressionLike(model);
         else
             model.updatediffs(7) = ppaNewfBarLike(model, 0);
         end

        [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,0);

        if strcmp(model.noise.type,'gaussian')            
             newQFlike = ppaCalculateRegressionLike(model);
         else
             newQFlike = ppaNewfBarLike(model, 0);
        end
        model.updatediffs(7) = newQFlike - model.updatediffs(7);
     
    case 'Expect-Begin-fBar'
        
        if strcmp(model.noise.type,'gaussian')            
             model.updatediffs(3) = ppaCalculateRegressionLike(model);
         else
             model.updatediffs(3) = ppaNewfBarLike(model, 0);
        end
        
    case 'Expect-End-fBar'
        [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,0);
        if strcmp(model.noise.type,'gaussian')            
            newfBarLike = ppaCalculateRegressionLike(model);
        else
            newfBarLike = ppaNewfBarLike(model, 0);
        end
        model.updatediffs(3) = newfBarLike-model.updatediffs(3);
        
    case 'Expect-Begin-fBarfBar'
            if strcmp(model.noise.type,'gaussian')            
             model.updatediffs(4) = ppaCalculateRegressionLike(model);
         else
             model.updatediffs(4) = ppaNewfBarLike(model, 0);
        end
    
    case 'Expect-End-fBarfBar'
        [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,0);
        if strcmp(model.noise.type,'gaussian')            
            newfBarfBarLike = ppaCalculateRegressionLike(model);
        else
            newfBarfBarLike = ppaNewfBarLike(model, 0);
        end
        model.updatediffs(4) = newfBarfBarLike-model.updatediffs(4);
               
           
    case 'Expect-q(f)'
        
        if strcmp(model.noise.type,'gaussian')
            
            oldQF = ppaCalculateRegressionLike(model);
            
            % Correction with respect to qf approximating distribution
            [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,0,1);
            newQF = ppaCalculateRegressionLike(model);
            model.updatediffs(8) = newQF - oldQF;
        end

    case 'Expect-Begin-f'
        if strcmp(model.noise.type,'gaussian')
            model.updatediffs(5) = ppaCalculateRegressionLike(model);
        end

    case 'Expect-End-f'
        if strcmp(model.noise.type,'gaussian')
            [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,0,1);
            newfLike = ppaCalculateRegressionLike(model);
            model.updatediffs(5)= newfLike - model.updatediffs(5);
        end
        
    case 'Expect-Begin-ff'
        if strcmp(model.noise.type,'gaussian')
            model.updatediffs(6) = ppaCalculateRegressionLike(model);
        end

    case 'Expect-End-ff'
        if strcmp(model.noise.type,'gaussian')
            [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,0,1);
            newffLike = ppaCalculateRegressionLike(model);
            model.updatediffs(6)= newffLike - model.updatediffs(6);
        end
                

    case 'q(f)-calc'
        if options.varKern
             model.updatediffs(12) = model.logLike - model.oldLogLike - model.updatediffs(1)- model.updatediffs(2)- model.updatediffs(7);
             if model.updatediffs(12) < 0
                 warning('qf goes down')
             end
         else
             model.updatediffs(12) = model.logLike - model.oldLogLike - model.updatediffs(1)- model.updatediffs(2);
             if model.updatediffs(12) < 0
                 warning('qf goes down')
             end 
        end
         
    case 'KL-check'
        if strcmp(model.noise.type,'gaussian')
            if ~options.varKern
                logLike = ppaCalculateRegressionLike(model);
                KLlogLike = ppaCalculateRegressionKLLike(model);
                diffKL = logLike - KLlogLike;
                fprintf('\n After the update of q(fBar) the difference in the bounds is %e \n',diffKL);
            else
                
                logLike = ppaCalculateRegressionLike(model);
                KLlogLike = ppaCalculateRegressionKLLike(model);
                diffKL = logLike - KLlogLike;
                fprintf('\n After the update of q(fBar) the difference in the bounds is %e \n',diffKL);
                %fprintf('\n The KL comparison with the standard likelihood requires KL correction to be used. \n');
            end
        else
            fprintf('\n The KL comparison with the standard likelihood can only be calculated with the Regression noise model. \n');
        end
        
                
                
    otherwise
        warning('Debug type not defined');
        
end