function  [classError, aveInfoVal, aveMagM] = ppaClassAverageInformation(ytest, xTest,model)

% PPACLASSAVERAGEINFORMATION A function that calculates the class error, the
% average information and the the norm of the posterior mean.
% FORMAT
% DESC A function that calculates the class error, the
% average information and the the norm of the posterior mean.
% ARG ytest : The test labels.
% ARG xtest : The test input data.
% ARG model : The current PPA model.
% RETURN classError : The class error
% RETURN aveInfoVal : The average information value.
% RETURN aveMagM : The average magnitude of the mean vector.

% PPA


[mu, varsigma] = ppaPosteriorMeanVar(model, xTest);

yPred = noiseOut(model.noise, mu, varsigma);
classError = 1- sum(ytest==yPred)/length(ytest);
pt= sum(model.y ==1)/length(model.y)

for i = 1:size(xTest,1)
    % This is a gaussian with mean mu, covar = varsigma and evaluated for y=1;
    probi  = cumGaussian(mu(i,:)/(sqrt(model.noise.sigma2+varsigma(i,:))));
        
    H = -xlog2y(pt)-xlog2y(1-pt);
    
    infoVal(i) = xlog2y(0.5*(ytest(i,:) + 1),probi) + xlog2y(0.5*(1 - ytest(i,:)),1-probi) + H;
   
    
end

aveMagM = norm(mu);

aveInfoVal = mean(infoVal)+1;