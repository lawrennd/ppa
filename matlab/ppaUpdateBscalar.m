function model = ppaUpdateBscalar(model)

% PPAUPDATEBSCALAR Update the values of B keeping each data dimension constant.

% PPA

numData = size(model.y, 1);
for i=1:size(model.y, 2)
  invAlpha = sum(model.expectations.ff(:, i)) ...
      -2.*model.expectations.fBar(:, i)'*model.expectations.f(:, i) ...
      + trace(model.expectations.fBarfBar(:, :, i)); 
  
  % Replacing B in the model with its update        
  model.B(:, i) = repmat(numData./invAlpha, numData, 1);
end