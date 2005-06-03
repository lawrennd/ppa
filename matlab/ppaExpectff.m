function model = ppaExpectff(model)

% PPAEXPECTFF Second moment of f under q(f).

% PPA

numData = size(model.y, 1);
m = model.expectations.fBar;
for i=1:numData    
    % the equation takes the form 
    % <f_if_i>=2*beta_i^(-1)*gamma_i*beta_i^(-1)+beta_i^(-1)+2*m_n*<f_n>-m_n^2
    model.expectations.ff(i, :)= ...
        (2.*1./model.B(i, :).*model.gamma(i,:).*1./model.B(i, :)) ...
        + 1./model.B(i, :)+2.*m(i,:) ...
        .*model.expectations.f(i,:) ...
        -m(i,:).*m(i,:);
end