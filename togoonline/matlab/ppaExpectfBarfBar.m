function model = ppaExpectfBarfBar(model)

% PPAEXPECTFBARFBAR Second moment under q(fBar).
% FORMAT
% DESC Compute the expectation of fBarfBar.
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

for i = 1:size(model.y, 2);

  model.expectations.fBarfBar(:, :, i) = ...
      pdinv(diag(B(:, i)) + pdinv(model.kern.Kstore)) ...
      + model.expectations.fBar(:, i)*model.expectations.fBar(:, i)';
  
end
