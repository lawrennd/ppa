function [model,logLikeVals,cpuStore] = ppaOptimisePPA(model, options);

% PPAOPTIMISEPPA Optimise the probabilistic point assimilation model.
% FORMAT
% DESC Optimise the probabilistic point assimilation model.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% RETURN logLikeVals : Store of the loglike values at each iteration.
% RETURN cpuStore : Store of the cpu values of each iteration.
% SEEALSO ppaInit, ppaCalculateLogLike, ppaMStep, ppaEStepIter, ppaRegressPlot, ppaTwoDPlot
 
% PPA 

logLikeVals = [];
cpuStore    = [];


% Initalise the parameters
model = ppaInit(model,options);

% plot inital setup
if options.display>1
  if size(model.X, 2) == 2
      if strcmp(model.noise.type,'gaussian')
          ppaRegressPlot(model,'mesh',1,model.X,model.y);
      else
          ppaTwoDPlot(model, 1, model.X, model.y);
      end
  end
end

% set convergence and counter
convergence=0;
counter=0;

% calculate start loglikelihood
oldLogLike = ppaCalculateRegressionLike(model);%
%oldLogLike = ppaCalculateQFLogLike(model);%ppaCalculateLogLike(model,options);
model.oldLogLike = oldLogLike;

if options.rememLoglikeVals
    cpuStore=[cpuStore,0];
    logLikeVals = [logLikeVals,oldLogLike];  
end

while(convergence==0 & counter < options.maxOuterIter)
  counter=counter+1;  
  
   if options.rememLoglikeVals
      a=cputime;
   end
  
if options.updateNoise
    [model,options]=ppaUpdateNoiseStep(model, options); 
    [model,options]= ppaEStepF(model, options);
    % Do the E step calculations
    [model,options] = ppaEStepIter(model,options);
end
  
  % Do the M step calculations
  if options.doMStep
    [model,options]=ppaMStep(model, options);  
  end
%model = ppaCavityUpdate(model);
%model = ppaCavityVecUpdate(model)
 % Do the E step calculations
[model,options] = ppaEStepIter(model,options);
   
 %logLike = ppaCalculateLogLike(model,options);

 if options.doDebug
     if ~strcmp(model.noise.type,'gaussian')
         model.logLike = logLike;
         model = ppaDebugTool(model,options,'q(f)-calc');
         model.oldLogLike = logLike;
     end
     ppaDebugDisplay(model,options);     
 end


  
  if options.display>1
  if size(model.X, 2) == 2
      if strcmp(model.noise.type,'gaussian')
          ppaRegressPlot(model,'mesh',counter,model.X,model.y);
      else
          ppaTwoDPlot(model, counter, model.X, model.y);
          pause(1)
      end
  end
  end
%logLike = ppaCalculateQFLogLike(model);
logLike = ppaCalculateRegressionLike(model);
  logLikeDiff=logLike-oldLogLike;
  
  if options.display
    % Display details 
    %fprintf('Update %d, log-likelihood change %2.7f and the regression diff  is %2.7f and %2.7f\n', counter, logLikeDiff, KLCORRECTBY,logLikeCheckDiff);
    fprintf('Update %d, log-likelihood change %2.7f\n', counter, logLikeDiff);
  end
 
  
  % Check for loglike going down
  if(logLikeDiff<0)
    % If the loglike goes down display warning of this
    warning('Log likelihood went down');
    
  else
    if(logLikeDiff<options.tol)
      convergence=1;
      fprintf('Algorithm has converged');
    end
  end
   if options.rememLoglikeVals
      b=cputime;
      cpuStore=[cpuStore,b-a];
      logLikeVals = [logLikeVals,logLike];  
  end
  
  oldLogLike=logLike;  
  %else
   %   [model,options] = ppaEStepAlt(model,options);
  %end
end

if(convergence~=1)
    fprintf('Algorithm has reached maximum number of iterations');
end
model.logLike=logLike;
model.numIters = counter;