function model = ppaUpdateB(model)

% PPAUPDATEB Update the individual values of B.

% PPA

numData = size(model.y, 1);
for i=1:size(model.y, 2)
  model.B(:, i) = 1./(model.expectations.ff(:, i) ...
      -2.*model.expectations.fBar(:, i).*model.expectations.f(:, i) ...
      + diag(model.expectations.fBarfBar(:, :, i))); 
end