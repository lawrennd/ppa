function diff = ppadiffFBar(model,oldmodel)


diff=0;

invK = pdinv(model.kern.Kstore);
for i = size(model.y,2)
    invCnew =  diag(model.B(:, i)) + invK;
    [Cnew, UinvCnew] = pdinv(invCnew);
    invCold = oldmodel.ninvC(:,:,i);
    [Cold, UinvCold] = pdinv(invCold);
    %logdetInvC = logdet(invC,UC);
    
    diff = diff - 0.5 .* sum(sum((model.expectations.fBarfBar(:,:,i)-oldmodel.expectations.fBarfBar(:,:,i)).*invK)) ...
        -0.5.*sum((diag(model.expectations.fBarfBar(:,:,i))-diag(oldmodel.expectations.fBarfBar(:,:,i))).*model.B(:,i)) ...
        + sum(model.expectations.f(:,i).*model.B(:,i).*(model.expectations.fBar(:,i)-oldmodel.expectations.fBar(:,i)))...
        + 0.5 .* logdet(invCold, UinvCold) - 0.5 .* logdet(invCnew,UinvCnew);
    
    
   
end
%-0.5.*sum((diag(oldmodel.expectations.fBarfBar(:,:,i))-diag(model.expectations.fBarfBar(:,:,i))).*model.B(:,i))
%-0.5.*logDetInvoldC+0.5.*