function model = ppaExpectfBar(model)

% PPAEXPECTFBAR Expectation under q(fBar).

% PPA

for i = 1:size(model.y, 2)
  model.expectations.fBar(:, i) = pdinv(diag(model.B(:, i)) + ...
                                             model.kern.invKstore)...
                                        *diag(model.B(:, i))...
                                        *model.expectations.f(:, i);
end