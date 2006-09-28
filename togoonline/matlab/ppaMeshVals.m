function [X, Y, Z, varZ] = ppaMeshVals(model, limx, limy, number)

% PPAMESHVALS Give the output of the PPA for contour plot.
% FORMAT
% DESC Give the output of the PPA for contour plot.
% ARG model : The current PPA model.
% ARG limx : limits of x dimension.
% ARG limy : limits of y dimension.
% ARG number : number of grid points.
% RETURN X : The X dimensional meshgrid.
% RETURN Y : The Y dimensional meshgrid.
% RETURN Z : The Z dimensional meshgrid.
% RETURN varZ : The varZ meshgrid elements.
% SEEALSO : ppaTwoDPlot, ppaContour, ppaPosteriorMeanVar

% PPA

x = linspace(limx(1), limx(2), number);
y = linspace(limy(1), limy(2), number);
[X, Y] = meshgrid(x, y);

[Z, varZ] = ppaPosteriorMeanVar(model, [X(:) Y(:)]);
Z = reshape(Z, size(X));
varZ = reshape(varZ, size(X));