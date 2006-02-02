function [fbarLike] = ppaResultFbarLike(model)

logConst = -0.5.*size(model.kern.Kstore,1).*log(2.*pi);


x = model.X;
m = model.expectations.f;
K = kernCompute(model.kern, x);
    
fbarLike = 0;

for i = 1 : size(model.B,2)
    
    A = K+(1./model.B(:,i)).*eye(size(K));
    [invA, UA] = pdinv(A);
    
    fbarLike = fbarLike + logConst - 0.5.*logdet(A,UA)-0.5.*m(:,i)'*invA*m(:,i);
end
    
    
