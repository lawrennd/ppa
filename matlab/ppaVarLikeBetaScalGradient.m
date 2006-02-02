function g = ppaVarLikeBetaScalGradient(params,model)

% PPAVARLIKEBETASCALGRADIENT - Calculate the variational gradient for beta scalar

% PPA

model.B = BExpandParam(model.B,params);

g = ppaVarLikeBetaScalLogLikeGrad(model);

g = -g;