function logLike = ppaCalculateQFLogLike(model,options)

% PPACALCULATEQFLOGLIKE Compute the log likelihood of the data using the QF
% technique
% FORMAT
% DESC Compute the log likelihood of the data using the QF
% technique
% ARG model : The current PPA model.
% ARG options : The PPA options.
% RETURN logLike : The calculated value of the log likelihood.

% PPA

invK=model.kern.invKstore;
[invK, UK] = pdinv(model.kern.Kstore);
logLike = 0;
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


gaussConst = 0.5 * numData;

[invK,UK] = pdinv(model.kern.Kstore);

for i = 1 : size(model.y,2)
    
    part1 = - 0.5 .*sum( B(:,i).* (diag(model.expectations.fBarfBar(:,:,i))- model.expectations.fBar(:,i).*model.expectations.fBar(:,i)));
    part2 = noiseLogLikelihood(model.noise, model.expectations.fBar(:,i), 1./B(:,i), model.y(:,i));
   
    % To do with the GP prior    
    part3 = -gaussConst*log(2*pi) - 0.5*logdet(model.kern.Kstore,UK) ...
        -0.5*trace(model.expectations.fBarfBar(:,:,i)*invK);
    
    % To do with the expectations of fBar
    part4 = -model.qExpectfBar;
        
    logLike = logLike + part1 + part2 + part3 + part4;
end
logLike = logLike + kernPriorLogProb(model.kern);
