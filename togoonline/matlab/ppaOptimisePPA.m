function [model,logLikeVals,cpuStore] = ppaOptimisePPA(model, options);

% PPAOPTIMISEPPA Optimise the probabilistic point assimilation model.

% PPA

logLikeVals = [];
cpuStore    = [];
% Initalise the parameters
model = ppaInit(model,options);

% plot inital setup
if options.display>1
  if size(model.X, 2) == 2
    ppaTwoDPlot(model, 1, model.X, model.y);
  end
end


% set convergence and counter
convergence=0;
counter=0;
% calculate start loglikelihood
[oldLogLike]=ppaCalculateLogLike(model,options);
%oldLogLikecheck = ppaCalculateLogLikeCheck(model);
%KLCORRECTBY =oldLogLikecheck - oldLogLike  

if options.rememLoglikeVals
    %b=cputime;
    cpuStore=[cpuStore,0];
    logLikeVals = [logLikeVals,oldLogLike];  
end

% A check for the f updates
model.oldLogLike = oldLogLike;

while(convergence==0 & counter < options.maxOuterIter)
  counter=counter+1;  
  
   if options.rememLoglikeVals
      a=cputime;
   end
  
  
  % Do the M step calculations
  if options.doMStep
      [model,options]=ppaMStep(model, options);  
  end
 
  
  
  % Do the E step calculations
  [model,options]=ppaEStep(model, options);

  % Calculate the likelihood of the current model 
  [logLike]=ppaCalculateLogLike(model,options);
  
%logLikecheck = ppaCalculateLogLikeCheck(model);
%KLCORRECTBY =logLikecheck - logLike  ;

  if options.doDebug
      logLike=logLike
      model.updatediffs(4) = logLike - model.oldLogLike - model.updatediffs(1)- model.updatediffs(2)- model.updatediffs(3);
      diffs = model.updatediffs;
      diffs = diffs
  end

  % A check for the f updates
  if options.doDebug
      model.oldLogLike = logLike;
  end
  
  
  % Plot results at n iteration intervals
  if options.display > 1
    if ~mod(counter,25)
      if size(model.X, 2) == 2
        ppaTwoDPlot(model, counter, model.X, model.y);
      end
    end
  end
  
  logLikeDiff=logLike-oldLogLike;
  
  if options.display
    % Display details 
    %fprintf('Update %d, log-likelihood change %2.7f and the KL correction is %2.7f\n', counter, logLikeDiff, KLCORRECTBY);
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
end

if(convergence~=1)
    fprintf('Algorithm has reached maximum number of iterations');
end
model.logLike=logLike;
model.numIters = counter;