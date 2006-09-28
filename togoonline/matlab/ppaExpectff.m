function model = ppaExpectff(model)


% PPAEXPECTFF Second moment of f under q(f).
% FORMAT
% DESC Compute the expectation of ff.
% ARG model : The current PPA model.
% RETURN model : The updated PPA model.
 
% PPA 


numData = size(model.X, 1);
numOut = size(model.y, 2);

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    

m = model.expectations.fBar;
for i=1:numData    
    % the equation takes the form 
    % <f_if_i>=2*beta_i^(-1)*gamma_i*beta_i^(-1)+beta_i^(-1)+2*m_n*<f_n>-m_n^2
    model.expectations.ff(i, :)= (2.*1./B(i, :).*model.gamma(i,:).*1./B(i, :)) ...
                         + 1./B(i, :)+2.*m(i,:).*model.expectations.f(i,:) ...
                           -m(i,:).*m(i,:);


end
