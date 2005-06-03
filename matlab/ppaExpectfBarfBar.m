function model = ppaExpectfBarfBar(model)

% PPAEXPECTFBARFBAR Second moment under q(fBar).

% PPA

for i = 1:size(model.y, 2);
  model.expectations.fBarfBar(:, :, i) = ...
      pdinv(diag(model.B(:, i)) + pdinv(model.kern.Kstore)) ...
      + model.expectations.fBar(:, i)*model.expectations.fBar(:, i)';
end