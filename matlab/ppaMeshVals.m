function [X, Y, Z, varZ] = ppaMeshVals(model, limx, limy, number)

% PPAMESHVALS Give the output of the PPA for contour plot display.

% PPA

x = linspace(limx(1), limx(2), number);
y = linspace(limy(1), limy(2), number);
[X, Y] = meshgrid(x, y);

[Z, varZ] = ppaPosteriorMeanVar(model, [X(:) Y(:)]);
Z = reshape(Z, size(X));
varZ = reshape(varZ, size(X));