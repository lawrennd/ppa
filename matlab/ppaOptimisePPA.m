function model = ppaOptimisePPA(model, options);

% PPAOPTIMISEPPA Optimise the probabilistic point assimilation model.

% PPA

% Initalise the parameters
model = ppaInit(model);

% set convergence and counter
convergence=0;
counter=1;

% plot inital setup
if options.display>1
  if size(model.X, 2) == 2
    ppaTwoDPlot(model, counter, model.X, model.y);
  end
end

% calculate start loglikelihood
[oldLogLike]=ppaCalculateLogLike2(model);

while(convergence==0)
  % Do the E step calculations
  model=ppaEStep(model);
  
  % Do the M step calculations
  model=ppaMStep(model);  
    
  % Calculate the likelihood of the current model 
  [logLike]=ppaCalculateLogLike2(model);
  
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
  counter=counter+1;
end