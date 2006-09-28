function model = ppa(X, y, noiseType, kernelType,betaTransform);

% PPA Set up a probabilistic point assimilation model. 
% FORMAT
% DESC Set up a probabilistic point assimilation model. 
% ARG X : The input data X.
% ARG Y : The output labels Y.
% ARG noiseType : The noise model type.
% ARG kernelType : The kernel function type. 
% ARG betaTransform : The type of transform for the beta values.
% RETURN model : The newly created ppa model.

% PPA 

if nargin < 5
    betaTransform = 'negLogLogit';
end

model.type = 'ppa';
numData = size(X, 1);

model.X = X;
model.y = y;
%pause

model.betaTransform = betaTransform;


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
model.expectations.f =  ones(size(model.y));%model.y;%
model.expectations.ff = ones(size(model.y));
model.expectations.fBar =ones(size(model.y));
model.expectations.fBarfBar = ones(numData, ...
                                    numData, ...
                                    size(model.y, 2));
