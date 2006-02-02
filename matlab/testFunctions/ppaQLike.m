function  minusqFbarGauss = ppaQLike(model)

mu=model.mu;
invC = model.invC;

for i = 1 : size(model.B,2)
    
[C, UC] = pdinv(invC);
logdetC = logdet(invC,UC);

minusqFbarGauss = -0.5*logdetC + 0.5.*trace(model.expectations.fBarfBar(:,:,i)*invC) ...
                    -model.expectations.fBar(:,i)'*invC*mu(:,i)+0.5.*mu(:,i)'*invC*mu(:,i);
    
end