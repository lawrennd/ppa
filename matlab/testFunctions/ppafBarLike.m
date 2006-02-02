function [fBarLike,model] = ppafBarLike(model, calcqfBar)


invK=model.kern.invKstore;
[invK, UK] = pdinv(model.kern.Kstore);
loglike = 0;
logDetK = 0.5 .*logdet(model.kern.Kstore,UK);

numData = size(model.y, 1);

logConst = 0.5 .*size(invK,1) * log(2*pi);

fBarLike=0;

for i = 1 : size(model.y,2)
    
    priorGauss = -logConst - logDetK - 0.5.*trace(model.expectations.fBarfBar(:,:,i)*invK);    
    
    B = diag(model.B(:,i));
    invB = diag(1./model.B(:,i));
    
    likeGauss = -logConst + 0.5.*sum(log(B(:,i))) - 0.5.*sum(B(:,i).*model.expectations.ff(:,i)) ...
                                      + sum(B(:,i).*model.expectations.f(:,i).*model.expectations.fBar(:,i)) ...
                                        - 0.5.*sum(B(:,i).*diag(model.expectations.fBarfBar(:,:,i)));
    fBarLike = fBarLike + priorGauss + likeGauss;
end

%fBarLike
%calcqfBar
if ~calcqfBar
    fBarLike = fBarLike - model.qfBar;
else
    qfBar = 0;
   % 
%       invC =  diag(B(:, i)) + invK;
%   [C, UC] = pdinv(invC);
%   logdetInvC = logdet(invC,UC);    
%   
%   part1 = -0.5.*logdetK-0.5.*logdetInvC
  %
    for i = size(model.y,2)
        B = diag(model.B(:,i));
     
       invC =  diag(B(:, i)) + invK;
       [C, UC] = pdinv(invC);
       logDetInvC = logdet(invC,UC) ;      
       
       mu = C * B * model.expectations.f(:,i);
        
       qfBarLike = -logConst + 0.5 .*logDetInvC - 0.5.*trace(model.expectations.fBarfBar(:,:,i)*invC) ...
                       + model.expectations.fBar(:,i)'*invC*mu(:,i) ...
                          -0.5.*mu'*invC*mu;
    
        qfBar = qfBar + qfBarLike;
        
    end
    %qfBar;
    %hey=2
    model.qfBar = qfBar;
    fBarLike = fBarLike - qfBar;
end
qfBar = model.qfBar;
qfBar = qfBar;