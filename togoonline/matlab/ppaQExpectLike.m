function [qExpectfBar , qExpectf] = ppaQExpectLike(model,upFbar,upF)

% PPAQEXPECTLIKE A function that calculates the parts of the likelihood
% relating to the approximating distributions.
% FORMAT
% DESC A function that calculates the parts of the likelihood
% relating to the approximating distributions
% ARG model : The current PPA model.
% ARG upFbar : Binary choice to update q(fBar).
% ARG upF : Binary choice to update q(f).
% RETURN qExpectfBar : The value of q(fBar).
% RETURN qExpectf : The value of q(f).

% PPA

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    numData = size(model.X, 1);
    numOut = size(model.y, 2);
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    

diagB = diag(B);
gaussConst = 0.5 * size(model.y,1);
if upFbar == 1
    
    invVarFBar = pdinv(model.kern.Kstore) + diagB;
    [varFBar,UIVF] = pdinv(invVarFBar);
    mu =diagB*varFBar*model.expectations.f;
    qExpectfBar = -gaussConst*log(2*pi) + 0.5.*logdet(invVarFBar,UIVF)...
               -0.5*trace(model.expectations.fBarfBar*invVarFBar)...
               + model.expectations.f'*diagB*model.expectations.fBar ...
           -0.5.*model.expectations.f'*diagB*varFBar*diagB*model.expectations.f;
               
               
else
   qExpectfBar = model.qExpectfBar;
end

if upF == 1
    qExpectf = -gaussConst*log(2*pi);
    for i=1:size(model.y,1)
    invGamma = 1/model.noise.sigma2 + B(i,:);
    gammaF = invGamma .^-1;
   
   
        % the equation takes the form
        % <f_i>=<fBar_i>+inv(beta_n)*g_n
        m(i,:)=model.expectations.fBar(i,:)+model.g(i,:).*(1./B(i,:));
    
    
    qExpectf = qExpectf- 0.5*log(gammaF)...
               -0.5.*invGamma .*(model.expectations.ff(i,:) - 2.*model.expectations.f(i,:)'*m(i,:) + m(i,:)'*m(i,:));
          
end
else
    qExpectf = model.qExpectf;
end


