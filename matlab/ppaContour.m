function ppaContour(X, Y, Z, lineWidth)

% PPACONTOUR Special contour plot showing decision boundary.

% PPA

% It's probably learnt something.
[void, clines] =contour(X, Y, Z, [0.25 .75], 'b--');
set(clines, 'linewidth', lineWidth)
[void, clines] =contour(X, Y, Z, [0.5 0.5], 'r-');
set(clines, 'linewidth', lineWidth);
