function model=ppaExpectf(model)

% PPAEXPECTF Compute the expectation of f.
% FORMAT
% DESC Compute the expectation of f.
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

% iterate and perform calculation for each data point

for i=1:numData
    % the equation takes the form
    % <f_i>=<fBar_i>+inv(beta_n)*g_n
    model.expectations.f(i,:)=model.expectations.fBar(i,:)+ ...
        model.g(i,:).*(1./B(i, :));
end
