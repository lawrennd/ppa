function [model,options]= ppaMStep(model, options)

% PPAMSTEP Perform the M-step for probabilistic point assimilation.

% PPA

if options.doDebug
    if options.varKern
        [currentLogLike]=ppaCalculateLogLike(model);
        currentSVLogLike = ppaSVMstepLikelihood(model);
    end

    if ~options.varKern
        [currentLogLike]=ppaCalculateLogLike(model);
        tempKern.diagK=model.kern.diagK;
        tempKern.type= model.kern.type;
        tempKern.comp=model.kern.comp;
        tempKern.nParams=model.kern.nParams;
        tempKern.transforms=model.kern.transforms;
        tempKern.paramGroups=model.kern.paramGroups;
        tempKern.whiteVariance=model.kern.whiteVariance;
        % A test function just checking the part of the likelihood involvign
        % the M Step parameters
        currentKLLoglike = ppaKLMstepLikelihood(model);
    end
end

% Call the update for the K Kernel
if options.kernIters
  model = ppaUpdateKernel(model, options);
end


if options.doDebug
    % check for correct update behaviour
    if ~options.varKern
        [logLikeK]=ppaCalculateLogLike(model);
        logLikeDiffK=logLikeK-currentLogLike;
        
        KernKLLoglike = ppaKLMstepLikelihood(model);
        KernKLLoglikeDiff = KernKLLoglike - currentKLLoglike;
        
           
        if(KernKLLoglikeDiff<0)
            fprintf('\n Problem with K, KL log-likelihood change %2.12f\n',KernKLLoglikeDiff);
        end
        model.updatediffs(1)=KernKLLoglikeDiff;
    end

    if options.varKern
        kernSVLogLike = ppaSVMstepLikelihood(model);
        KernSVLoglikeDiff = kernSVLogLike - currentSVLogLike;
        
                
        if(KernSVLoglikeDiff<0)
            fprintf('\n Problem with K, SV log-likelihood change %2.12f\n',KernSVLoglikeDiff);
        end

        model.updatediffs(1)=KernSVLoglikeDiff;
        
    end
end

if options.updateBeta

    model = ppaScgUpdateBeta(model,options);
 
    % Check for correct updates
    if options.doDebug
        if options.varKern
            BSVLogLike = ppaSVMstepLikelihood(model);
            BSVLoglikeDiff = BSVLogLike - kernSVLogLike;
            model.updatediffs(2)=BSVLoglikeDiff;
 
           if(BSVLoglikeDiff<0)
                fprintf('\n Problem with B, SV log-likelihood change %2.12f\n',BSVLoglikeDiff);
           end

        
        if ~options.varKern
            BKLLoglike = ppaKLMstepLikelihood(model);
            BKLLoglikeDiff = BKLLoglike - KernKLLoglike;
            model.updatediffs(2)=BKLLoglikeDiff;

            if(BKLLoglikeDiff<0)
                fprintf('\n Problem with B, KL log-likelihood change %2.12f\n',BKLLoglikeDiff);
            end

        end
    end
end