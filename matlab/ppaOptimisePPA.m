function [model] = ppaOptimisePPA(model, options);

% PPAOPTIMISEPPA Optimise the probabilistic point assimilation model.

% PPA

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
[oldLogLike]=ppaCalculateLogLike(model);

while(convergence==0 & counter < options.maxOuterIter)
  counter=counter+1;  
  
  
  % Do the M step calculations
  [model,options]=ppaMStep(model, options);  
 
  
  % Do the E step calculations
  [model,options]=ppaEStep(model, options);

  % Calculate the likelihood of the current model 
  [logLike]=ppaCalculateLogLike(model);
  
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
  
  oldLogLike=logLike;  
end

if(convergence~=1)
    fprintf('Algorithm has reached maximum number of iterations');
end
model.numIters = counter;