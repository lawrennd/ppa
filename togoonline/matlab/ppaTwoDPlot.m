function ppaTwoDPlot(model, iter, X, y)

% PPATWODPLOT MAKES A 2-D PLOT OF THE PPA
% FORMAT
% DESC Make a 2-D plot of the PPA.
% ARG model : The current ppa model.
% ARG iter : The iteration number.
% ARG X : Input data matrix.
% ARG y : Output labels.
% SEEALSO : ppaContour, ppaMeshVals

% PPA

if nargin < 4
  X = model.X;
  y = model.y;
end
clf
markerSize = 10;
lineWidth = 2;
title(['Iteration ' num2str(iter)])
if strcmp(model.noise.type,'probit')
pointsNeg = plot(X(find(y(:, 1)==-1), 1), ...
		 X(find(y(:, 1)==-1), 2), ...
		 'gx', 'erasemode', 'xor', ...
		 'markersize', markerSize+2, ...
		 'linewidth', lineWidth);
hold on
pointsPos = plot(X(find(y(:, 1)==1), 1), ...
		 X(find(y(:, 1)==1), 2), 'ro', ...
		 'erasemode', 'xor', ...
		 'markersize', markerSize, ...
		 'linewidth', lineWidth);

pointUn = plot(X(find(isnan(y(:, 1))), 1), ...
	       X(find(isnan(y(:, 1))), 2), 'm.', ...
	       'erasemode', 'xor', 'markersize', 8);
else  
h1 = noisePointPlot(model.noise, X, y, 'times', 20, 10, lineWidth);
end
hold on;
set(gca, 'fontname', 'times')
set(gca, 'fontsize', 20);

% It's probably learnt something.
xlim = get(gca, 'xlim');
ylim = get(gca, 'ylim');

[CX, CY, CZ, CZVar] = ppaMeshVals(model, xlim, ylim, 30);

noise3dPlot(model.noise, 'ppaContour', CX, CY, CZ, CZVar, lineWidth);   

drawnow