function model = ppaInit(model, d)

% PPAINIT Initialise the probabilistic point assimilation model.

% PPA

% Get number of data.
numData = size(model.X, 1);
numOut = size(model.y, 2);

% Initialise the kernel.
model.kern = kernParamInit(model.kern);

% Compute the full kernel matrix.
model.kern.Kstore=kernCompute(model.kern, model.X);
% Get its inverse.
model.kern.invKstore=pdinv(model.kern.Kstore);

% initialise B.
model.B = repmat(1, numData, numOut);

%/~
% NATREMINDER may need to be diag(model.kernB.B)'
%model.varSigma = repmat(diag(model.kernB.Kstore), 1, numOut);
%model.mu = zeros(numData,numOut);
%~/

model.g = zeros(numData, numOut);
model.nu = zeros(numData, numOut);
model.gamma = zeros(numData, numOut);
model = ppaEStep(model);









