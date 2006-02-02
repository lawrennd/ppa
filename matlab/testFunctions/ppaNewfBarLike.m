function [fBarLike,model] = ppaNewfBarLike(model, calcqfBar)


%invK=model.kern.invKstore;
[invK, UK] = pdinv(model.kern.Kstore);

%logDetK = 0.5 .*logdet(model.kern.Kstore,UK);
numData = size(model.y, 1);

B = model.B;

fBarLike=0;

for i = 1 : size(model.y,2)
    if ~calcqfBar
        invC = model.invC(:,:,i);
    else
        invC =  diag(B(:, i)) + invK;        
        model.invC(:,:,i) = invC;
    end
    [C, UinvC] = pdinv(invC);
    logDetInvC = logdet(invC,UinvC) ;
    
    fBarLike = fBarLike -0.5.*logDetInvC ...
    -0.5.*sum(sum(model.expectations.fBarfBar(:,:,i).*invK))  ...
    -0.5.*sum(diag(model.expectations.fBarfBar(:,:,i)).*model.B(:,i)) ...
    + sum(model.B(:,i).*model.expectations.fBar(:,i).*model.expectations.f(:,i));
   
    %+ 0.5.*logdet(invC)
end
%fBarLike=0.5.*fBarLike;