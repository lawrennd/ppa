function model = ppaUpdateB(model)

% PPAUPDATEB Update the individual values of B.

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

numData = size(model.y, 1);
for i=1:size(model.y, 2)
  newB(:, i) = 1./(model.expectations.ff(:, i) ...
      -2.*model.expectations.fBar(:, i).*model.expectations.f(:, i) ...
      + diag(model.expectations.fBarfBar(:, :, i))); 
end

model.B = newB;