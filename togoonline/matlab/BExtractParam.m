function  params = BExtractParam(B)

% BEXTRACTPARAM A function that extracts the B beta matrix and returns
% the beta values in a params vector
% FORMAT
% DESC  A function that extracts the B beta matrix and returns
% the beta values in a params vector
% ARG B : The vector of beta values/value.
% RETURN params : The transformed beta values.

% PPA

fhandle = str2func(['negLogLogit' 'Transform']);
params =  [fhandle(B, 'xtoa')]';%to ensure a row vector
