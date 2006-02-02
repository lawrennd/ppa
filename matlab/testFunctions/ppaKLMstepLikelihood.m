function logKLLike = ppaKLMstepLikelihood(model)



x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);

logConst = -0.5.*size(model.kern.Kstore,1).*log(2.*pi);
logKLLike = 0;
for i = 1 : size(model.B,2)
    [invC,UC] = pdinv(K+(1./model.B(:,i)).*eye(size(K)));
    logdetC = logdet(K+(1./model.B(:,i)).*eye(size(K)),UC);
    
    normalCal = logConst - 0.5.*logdetC -0.5.*m(:,i)'*invC*m(:,i);
    betaDiv = -0.5.*model.B.*sum(model.expectations.ff(:,i) - m(:,i).*m(:,i));
    
    logKLLike = logKLLike + normalCal + betaDiv;
    
end

