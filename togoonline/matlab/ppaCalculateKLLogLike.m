function loglike = ppaCalculateKLLogLike(model)

% PPACALCULATEKLLOGLIKE Compute the log likelihood of the data 
% FORMAT
% DESC Compute the log likelihood of the data.
% ARG model : The current PPA model.
% RETURN logLike : The calculated value of the log likelihood.

% PPA

loglike = 0;

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


m = model.expectations.f;
fBar = model.expectations.fBar;
ff = model.expectations.ff;

for i = 1 : size(model.y,2)
    
    A = model.kern.Kstore + diag(1./B(:,i));
    [invA,UA] = pdinv(A);
    logdetA = logdet(A,UA); 
    logdetBeta = size(model.y,1)*log(B(1,i));
    
    part1 =  -0.5.*numData*log(2*pi)-0.5.*logdetA-0.5.*m(:,i)'*invA*m(:,i);
    part2 = +0.5.*numData*log(2*pi)-0.5.*logdetBeta;
    part3 = + 0.5 .*B(1,i).*(sum(ff(:,i))- 2.*fBar(:,i)'*m(:,i) + model.expectations.fBar(:,i)'*model.expectations.fBar(:,i));
    part4 = noiseLogLikelihood(model.noise, model.expectations.fBar(:,i), 1./B(:,i), model.y(:,i));
    part5 = - 0.5.*sum(B(:,i).*(model.expectations.ff(:,i)-m(:,i).*m(:,i)));
 loglike = loglike + part1+part2+part3 + part4 + part5;
  
end   
    
    
loglike = loglike + kernPriorLogProb(model.kern);