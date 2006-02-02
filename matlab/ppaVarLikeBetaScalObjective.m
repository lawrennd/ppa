function f = ppaVarLikeBetaScalObjective(params,model)

% PPAVARLIKEBETASCALOBJECTIVE - Objective function for the scalar beta scg standar variational update

% PPA

model.B = BExpandParam(model.B,params);
f = ppaVarLikeBetaScalLogLikelihood(model);
f = -f;