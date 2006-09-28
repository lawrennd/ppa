function logSVLike = ppaSVMstepLikelihood(model)

% PPASVMSTEPLIKELIHOOD A function that can be used to debug PPA
% FORMAT
% DESC A function that can be used to debug PPA
% ARG model : The current PPA model.
% RETURN logSVLike : Calculate the likelihood of SV M step.

% PPA


x = model.X;
mu = model.expectations.fBar;
%K = kernCompute(model.kern, x);
%%23/05/06
K=model.kern.Kstore;
logConst = -0.5.*size(model.kern.Kstore,1).*log(2.*pi);
logSVLike =0;

for i = 1 : size(model.B,2)
    [invK,UK] = pdinv(K);
    logdetK = logdet(K,UK);
    
    normalCal = logConst - 0.5.*logdetK- 0.5.*trace(model.expectations.fBarfBar*invK);
    
    betaCal = logConst + 0.5.*logdet(model.B(:,i)*eye(size(K))) -0.5.*model.B(:,i).*sum(model.expectations.ff(:,i)) ...
                +model.B(:,i).*model.expectations.f(:,i)'*model.expectations.fBar(:,i) ...
                   -0.5.*model.B(:,i).*sum(diag(model.expectations.fBarfBar(:,:,i)));
               
                   
    
    logSVLike = logSVLike + normalCal + betaCal;
    
end
