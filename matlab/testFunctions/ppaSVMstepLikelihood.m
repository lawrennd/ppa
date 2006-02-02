function logKLLike = ppaSVMstepLikelihood(model)



x = model.X;
mu = model.expectations.fBar;
K = kernCompute(model.kern, x);

logConst = -0.5.*size(model.kern.Kstore,1).*log(2.*pi);
logKLLike =0;

for i = 1 : size(model.B,2)
    [invK,UK] = pdinv(K);
    logdetK = logdet(K,UK);
    
    normalCal = logConst - 0.5.*logdet(K)- 0.5.*trace(model.expectations.fBarfBar*invK);
    
    betaCal = logConst + 0.5.*logdet(model.B(:,i)*eye(size(K))) -0.5.*sum(model.B(:,i).*model.expectations.ff(:,i)) ...
                +sum(model.B(:,i).*model.expectations.f(:,i).*model.expectations.fBar(:,i)) ...
                   -0.5.*sum(model.B(:,i).*diag(model.expectations.fBarfBar(:,:,i)));
               
                   
    
    logKLLike = logKLLike + normalCal + betaCal;
    
end
