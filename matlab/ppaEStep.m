function model= ppaEStep(model, options)

% PPAESTEP Perform the expectation step in the EM optimisation.

% PPA

numData = size(model.X, 1);
% Compute G and nu
[model.g, model.nu] = noiseUpdateNuG(model.noise, ...
                                     model.expectations.fBar, ...
                                     1./model.B, ...
                                     model.y);
%/~
%for index = 1:numData  
%    [model.g(index, :), model.nu(index, :)] = ...
%                                             noiseUpdateNuG(model.noise, ...
%                                             model.expectations.fBar(index,:), model.kernB.invKstore(index,index), ...
%                                             model.y(index, :));              
%end
%~/

model.gamma = (((model.g).^2)-model.nu)/2;

model = ppaExpectf(model); % these are expectations under q(f)
model = ppaExpectff(model);

model = ppaExpectfBar(model); % these are expectations under q(fBar)
model = ppaExpectfBarfBar(model);