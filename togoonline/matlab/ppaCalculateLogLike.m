function logLike = ppaCalculateLogLike(model,options)

% PPACALCULATELOGLIKE A general function that picks the correct likelihood function
% FORMAT
% DESC A general function that picks the correct likelihood function.
% ARG model : The current PPA model.
% ARG options : The options of the PPA model.
% RETURN logLike : The calculated value of the log likelihood.
% SEEALSO ppaCalculateRegressionLike, ppaCalculateQFLogLike,
% ppaCalculateRegressionKLLike, ppaCalculateKLLogLike

% PPA 
if strcmp(model.noise.type,'gaussian')
    % As it is a gaussian noise model we can use the regression likelihood
    logLike = ppaCalculateRegressionLike(model);
    
else
    % Calculate the likelihood of the current model using the QF
    % technique
    logLike = ppaCalculateQFLogLike(model);
end
