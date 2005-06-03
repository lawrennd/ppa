function [model,options]= ppaMStep(model, options)

% PPAMSTEP Perform the M-step for probabilistic point assimilation.

% PPA

if ~options.varKern
    [currentLogLike]=ppaCalculateLogLike(model);
    tempKern.diagK=model.kern.diagK;
    tempKern.type= model.kern.type;
    tempKern.comp=model.kern.comp;
    tempKern.nParams=model.kern.nParams;
    tempKern.transforms=model.kern.transforms;
    tempKern.paramGroups=model.kern.paramGroups;
    tempKern.whiteVariance=model.kern.whiteVariance;
end


% Call the update for the K Kernel
 if options.kernIters
   model = ppaUpdateKernel(model, options);
 end

% check for kernel switch
if ~options.varKern
    [logLikeK]=ppaCalculateLogLike(model);
    logLikeDiffK=logLikeK-currentLogLike;
    if(logLikeDiffK<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates K, log-likelihood change %2.7f\n',logLikeDiffK);   
        end
        
        % Roll back kernel
        model.kern=tempKern;
        model.kern.Kstore=kernCompute(model.kern, model.X);
        model.kern.invKstore=pdinv(model.kern.Kstore);
        
        % Do this update again this time with varaitional method
        model = ppaUpdateKernel(model, options);
    end
end


% Call the update for the B kernel
if options.scalarB
  model = ppaUpdateBscalar(model);
else
  model = ppaUpdateB(model);
end

% check for kernel switch
if ~options.varKern
    [logLikeB]=ppaCalculateLogLike(model);
    logLikeDiffB=logLikeB-logLikeK;%currentLogLike;
    if(logLikeDiffB<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates B, log-likelihood change %2.7f\n',logLikeDiffB);   
        end
    end
end

