function g = ppaVarLikeBetaGradient(params,model)

% PPAVARLIKEBETAGRADIENT Calculate the variational gradient for beta
% FORMAT
% DESC Calculate the variational gradient for beta scalar
% ARG params : The current params matrix.
% ARG model : The current PPA model.
% RETURN g : The calculated value of the gradient.
 
% PPA 

model.B = BExpandParam(model.B,params);

g = ppaVarLikeBetaLogLikeGrad(model);

g = -g;