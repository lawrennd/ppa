function model=ppaExpectf(model)

% PPAEXPECTF Compute the expectation of f.

% PPA
numData = size(model.y, 1);
% iterate and perform calculation for each data point
for i=1:numData
    % the equation takes the form
    % <f_i>=<fBar_i>+inv(beta_n)*g_n
    model.expectations.f(i,:)=model.expectations.fBar(i,:)+ ...
        model.g(i,:).*1/model.B(i, :);
end


