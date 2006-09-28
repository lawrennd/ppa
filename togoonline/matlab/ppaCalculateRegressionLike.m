function logLike = ppaCalculateRegressionLike(model)

%  PPACALCULATEREGRESSION A likelihood function specific to the regression noise model
% FORMAT
% DESC A likelihood function specific to the regression noise model
% ARG model : The current PPA model.
% RETURN logLike : The calculated value of the log likelihood.

% PPA

logLike = 0;

numData = size(model.y, 1);

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    numData = size(model.X, 1);
    numOut = size(model.y, 2);
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    



gaussConst = 0.5 * numData;

[invK,UK] = pdinv(model.kern.Kstore);

for i = 1 : size(model.y,2)
    % The variance of the noise is varsigma2 so we augment it with 0 such that
    varNoise = zeros(size(model.y(:,i)));
    
    % Noise model responsibilties to the loglike
    part1 = gaussianLogLikelihood(model.noise, model.expectations.f(:,i), varNoise, model.y(:,i))-0.5*((model.noise.sigma2)^-1)*sum(model.expectations.ff(:,i)-model.expectations.f(:,i).*model.expectations.f(:,i));
   
    % To do with the likelihood    
    part2 = -gaussConst * log(2*pi) + 0.5*logdet(diag(B(:,i))) - 0.5.*sum(B(:,i).*model.expectations.ff(:,i)) ...
        + model.expectations.f(:,i)'*diag(B(:,i))*model.expectations.fBar(:,i) ...
        -0.5.*trace(model.expectations.fBarfBar(:,:,i)*diag(B(:,i)));
    
    % To do with the GP prior    
    part3 = -gaussConst*log(2*pi) - 0.5*logdet(model.kern.Kstore,UK) ...
        -0.5*trace(model.expectations.fBarfBar(:,:,i)*invK);
    
    % To do with the expectations of fBar
    part4 = -model.qExpectfBar;
    
    % To do with the expectations of f
    part5 = -model.qExpectf;
    
    logLike = logLike + part1 + part2 + part3 + part4 + part5;
end
logLike = logLike + kernPriorLogProb(model.kern);



