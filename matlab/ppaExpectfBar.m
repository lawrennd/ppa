function model = ppaExpectfBar(model)

% PPAEXPECTFBAR Expectation under q(fBar).

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

for i = 1:size(model.y, 2)
    model.expectations.fBar(:, i) = pdinv(diag(B(:, i)) + ...
                                              pdinv(model.kern.Kstore))...
                                         *diag(B(:, i))...
                                         *model.expectations.f(:, i);
end
