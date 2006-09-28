function logLike = ppaCalculateRegressionKLLike(model)

%  PPACALCULATEREGRESSIONKLLIKE A likelihood function specific to the regression
%  noise model and the KL corrected bound.
% FORMAT
% DESC A likelihood function specific to the regression
%  noise model and the KL corrected bound.
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


gaussConst = 0.5 * size(model.y,1);
m = model.expectations.f;
fBar = model.expectations.fBar;
ff = model.expectations.ff;

for i = 1 : size(model.y,2)
    
    C = model.kern.Kstore + diag(1./B(:,i));
    [invC,UC] = pdinv(C);
    
    % The variance of the noise is varsigma2 so we augment it with 0 such that
    varNoise = zeros(size(model.y(:,i)));
    
    % Noise model responsibilties to the loglike
    part1 = gaussianLogLikelihood(model.noise, model.expectations.f(:,i), varNoise, model.y(:,i))-0.5*(model.B(:,i)+(model.noise.sigma2)^-1)*sum(model.expectations.ff(:,i)-model.expectations.f(:,i).*model.expectations.f(:,i));
    
    part2 = -gaussConst*log(2*pi)-0.5*logdet(C,UC)-0.5*model.expectations.f(:,i)'*invC*model.expectations.f(:,i);
    
       
    part3 = -model.qExpectf;
    
    logLike = logLike + part1 + part2 + part3;
end

logLike = logLike + kernPriorLogProb(model.kern);