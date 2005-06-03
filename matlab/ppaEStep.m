function [model,options]= ppaEStep(model, options)

% PPAESTEP Perform the expectation step in the EM optimisation.

% PPA



numData = size(model.X, 1);

% Compute G and nu
[model.g, model.nu] = noiseUpdateNuG(model.noise, ...
                                     model.expectations.fBar, ...
                                     1./model.B, ...
                                     model.y);

% Compute gamma
model.gamma = (((model.g).^2)-model.nu)/2;


if ~options.varKern
    [currentLogLike]=ppaCalculateLogLike(model);
end
    

model = ppaExpectf(model); % these are expectations under q(f)

% check for kernel switch
if ~options.varKern
    [logLikeF]=ppaCalculateLogLike(model);
    logLikeDiffF=logLikeF-currentLogLike;
    if(logLikeDiffF<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates, log-likelihood change %2.7f\n',logLikeDiffF);   
        end
    end
end


model = ppaExpectff(model);

% check for kernel switch
if ~options.varKern
    [logLikeFF]=ppaCalculateLogLike(model);
    logLikeDiffFF=logLikeFF-logLikeF;
    if(logLikeDiffFF<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates, log-likelihood change %2.7f\n',logLikeDiffFF);   
        end
    end
end


model = ppaExpectfBar(model); % these are expectations under q(fBar)

% check for kernel switch
if ~options.varKern
    [logLikeFBAR]=ppaCalculateLogLike(model);
    logLikeDiffFBAR=logLikeFBAR-logLikeFF;
    if(logLikeDiffFBAR<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates, log-likelihood change %2.7f\n',logLikeDiffFBAR);   
        end
    end
end

  
model = ppaExpectfBarfBar(model);

% check for kernel switch
if ~options.varKern
    [logLikeFBARFBAR]=ppaCalculateLogLike(model);
    logLikeDiffFBARFBAR=logLikeFBARFBAR-logLikeFBAR;
    if(logLikeDiffFBARFBAR<0)
        % If the loglike goes down and we are using the non varitional kernel
        % updates switch to variationl
        options.varKern = 1;
        if options.display
            fprintf('Switching to full variational updates, log-likelihood change %2.7f\n',logLikeDiffFBARFBAR);   
        end
    end
end
 
    
    
    
       
    
