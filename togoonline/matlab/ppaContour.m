function h = ppaContour(X, Y, Z, lineWidth)

% PPACONTOUR Special contour plot showing decision boundary.
% FORMAT
% DESC Special contour plot showing decision boundary.
% ARG X : The X dimension meshgrid
% ARG Y : The Y dimension meshgrid
% ARG Z : The Z dimension meshgrid
% ARG lineWidth : The width of the lines 
% RETURN h : the figure handle.
% SEEALSO : ppaTwoDPlot

% PPA

% It's probably learnt something.
[void, clines1] =contour(X, Y, Z, [0.25 .75], 'b--');
[void, clines2] =contour(X, Y, Z, [0.5 0.5], 'r-');
h = [clines1; clines2];
set(h, 'linewidth', lineWidth)