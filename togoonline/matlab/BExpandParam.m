function  B = BExpandParam(B,params)%B,params)

% BEXPANDPARAM A function that puts the params into the models B beta matrix
% FORMAT
% DESC A function that puts the params into the models B beta matrix.
% ARG B : The vector of beta values/value.
% ARG params : The transformed beta values.
% RETURN B : The re-transformed beta values.

% PPA

fhandle = str2func(['negLogLogit' 'Transform']);
B = fhandle(params', 'atox');%to ensure colum vector

