function model = ppa(X, y, noiseType, kernelType);

% PPA Set up a probabilistic point assimilation model. 
 
% PPA 

model.type = 'ppa';
numData = size(X, 1);

model.X = X;
model.y = y;

%/~
% Set this for consistency with IVM code ... should not be needed.
%model.m = [];
%model.beta = [];
%model.varSigma = zeros(size(y));
%model.mu = zeros(size(y));
%~/

% Set up noise model gradient storage.
model.nu = zeros(size(y));
model.g = zeros(size(y));
model.gamma = zeros(size(y));

% Initate noise model
model.noise = noiseCreate(noiseType, y); 

% B
model.B = [];
% Kernels setup for K
model.kern = kernCreate(X, kernelType);
model.kern.Kstore = zeros(numData, numData);
model.kern.invKstore = zeros(numData, numData);


% Set up storage for the expectations
model.expectations.f = zeros(size(model.y));
model.expectations.ff = zeros(size(model.y));
model.expectations.fBar = zeros(size(model.y));
model.expectations.fBarfBar = zeros(numData, ...
                                    numData, ...
                                    size(model.y, 2));
