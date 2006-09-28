function [h1, h2] = ppaRegressPlot(model, plotType, iter, X, y)

% PPAREGRESSPLOT Make a 3-D or contour plot of the PPA for a regression
% data set.
% FORMAT
% DESC Make a 3-D or contour plot of the PPA for a regression
% data set.
% ARG model : The current ppa model.
% ARG plotType : The type of plot.
% ARG iter : The iteration number.
% ARG X : Input data matrix.
% ARG y : Output labels.
% RETURN h1 : handle to the points plot.
% RETURN h2 : handle to the 3d mesh plot.
% SEEALSO : ppaContour, ppaMeshVals

% PPA

h2 = [];
lineWidth = 2;
if nargin < 5
  X = model.X;
  y = model.y;
end
clf
h1 = noisePointPlot(model.noise, X, y, 'times', 20, 10, lineWidth);
title(['Iteration ' num2str(iter)])

xlim = get(gca, 'xlim');
ylim = get(gca, 'ylim');
[CX, CY, CZ, CZVar] = ppaMeshVals(model, xlim, ylim, 60);
%threeDargs = cell(1);
%threeDargs{1} = 2;
threeDargs = cell(0);
h2 =noise3dPlot(model.noise, plotType, CX, CY, CZ, CZVar, threeDargs{:});   %
drawnow