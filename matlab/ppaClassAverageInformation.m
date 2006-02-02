function  [classError, aveInfoVal, aveMagM] = ppaClassAverageInformation(ytest, xTest,model)

[mu, varsigma] = ppaPosteriorMeanVar(model, xTest);

yPred = noiseOut(model.noise, mu, varsigma);
classError = 1- sum(ytest ==yPred)/length(ytest);
pt= sum(model.y ==1)/length(model.y)

for i = 1:size(xTest,1)
    % This is a gaussian with mean mu, covar = varsigma and evaluated for y=1;
    probi  = cumGaussian(mu(i,:)/(sqrt(model.noise.sigma2+varsigma(i,:))));
        
    H = -xlog2y(pt)-xlog2y(1-pt);%-pt*log2(pt)-(1-pt)*log2(1-pt);
    
    infoVal(i) = xlog2y(0.5*(ytest(i,:) + 1),probi) + xlog2y(0.5*(1 - ytest(i,:)),1-probi) + H;
   
    
end

aveMagM = norm(mu);

aveInfoVal = mean(infoVal);