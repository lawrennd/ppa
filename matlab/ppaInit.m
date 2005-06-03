function model = ppaInit(model, options)

% PPAINIT Initialise the probabilistic point assimilation model.

% PPA

% Get number of data.
numData = size(model.X, 1);
numOut = size(model.y, 2);

% Compute the full kernel matrix.
model.kern.Kstore=kernCompute(model.kern, model.X);
% Get its inverse.
model.kern.invKstore=pdinv(model.kern.Kstore);

% initialise B.
if isempty(model.B)
  model.B = repmat(1, numData, numOut);
end

model.g = zeros(numData, numOut);
model.nu = zeros(numData, numOut);
model.gamma = zeros(numData, numOut);
model = ppaEStep(model,options);









