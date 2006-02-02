function loglike = ppaCalculateLogLike(model,options)

% PPACALCULATELOGLIKE Compute the log likelihood of the data 

% PPA

invK=model.kern.invKstore;
[invK, UK] = pdinv(model.kern.Kstore);
loglike = 0;
logdetK = logdet(model.kern.Kstore,UK);
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




for i = 1:size(model.y, 2)
    
  invC =  diag(B(:, i)) + invK;
  [C, UinvC] = pdinv(invC);
  logdetInvC = logdet(invC,UinvC);    
  
  part1 = -0.5.*logdetK-0.5.*logdetInvC;
  part2 = -0.5.*trace(model.expectations.fBarfBar(:,:,i)*invK);
  part3 = 0.5.*size(invK,1);
  
  part4 = - 0.5 .*sum( B(:,i).* (diag(model.expectations.fBarfBar(:,:,i))- model.expectations.fBar(:,i).*model.expectations.fBar(:,i)));
  part5 = noiseLogLikelihood(model.noise, model.expectations.fBar(:,i), 1./B(:,i), model.y(:,i));
  
  loglike = loglike + part1+part2+part3 + part4 + part5;
  
end

loglike = loglike + kernPriorLogProb(model.kern);