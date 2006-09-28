function z=xlog2y(x, y)

% XLOGY z= x*log2(y) returns zero if x=y=0 xloy for log base 2
% FORMAT
% DESC z= x*log2(y) returns zero if x=y=0 xloy for log base 2.
% ARG x : The 1st variable.
% ARG y : The 2nd variable.
% RETURN z : The result.

% PPA

% If there is only one input argument x is assumed to equal y.
if nargin == 1
  y=x;
end
if any(x==0)
  z = zeros(size(x));
  indx = find(x);
  z(indx)= x(indx).*log(y(indx));
else
  z= x.*log(y);
end