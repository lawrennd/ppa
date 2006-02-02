function fbarLike =ppaFBarLikelihood(model)


x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);

  
logConst = -0.5.*size(model.kern.Kstore,1).*log(2.*pi);

[invK,UK] = pdinv(K);
logdetK = logdet(K,UK);
    
fbarLike = 0;

for i = 1 : size(model.B,2)
    
    invC = invK+model.B(:,i).*eye(size(K));
    [C, UC] = pdinv(invC);
    
    mu = C*diag(model.B(:, i))*model.expectations.f(:, i);
    
    logdetC = logdet(invC,UC);
    logdetB = logdet((1./model.B(:,i)).*eye(size(K)));  
    
    fBarGauss = -0.5.*trace(model.expectations.fBarfBar(:,:,i)*invK);
    
    ffBarGauss =-0.5.*sum(model.B(:,i).*model.expectations.ff(:,i)) ...
                +sum(model.B(:,i).*model.expectations.f(:,i).*model.expectations.fBar(:,i)) ...
                   -0.5.*sum(model.B(:,i).*diag(model.expectations.fBarfBar(:,:,i)));
    %           0.5.*trace(model.expectations.fBarfBar(:,:,i)*diag(model.B(:, i)))-0.5.*sum(model.B(:,i).*diag(model.expectations.fBarfBar(:,:,i)))
               
    %trace(model.expectations.fBarfBar(:,:,i)*invC)
    %model.expectations.fBar(:,i)'*invC*model.expectations.fBar(:,i)
    minusqFbarGauss = +0.5.*trace(model.expectations.fBarfBar(:,:,i)*invC) ...
                    -model.expectations.fBar(:,i)'*invC*mu(:,i)+0.5.*mu(:,i)'*invC*mu(:,i);
    
    
    normalCal = logConst -0.5.*logdetK - 0.5*logdetB - 0.5*logdetC; 
    
    
      
    fbarLike = fbarLike + normalCal + fBarGauss + ffBarGauss + minusqFbarGauss;
    
end

