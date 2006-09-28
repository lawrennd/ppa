function f = ppaVarLikeBetaScalObjective(params,model)

% PPAVARLIKEBETASCALOBJECTIVE Objective function for the scalar beta standard variational update.
% FORMAT
% DESC Objective function for the scalar beta standard variational update.
% ARG params : A vector of the current param values.
% ARG model : The current PPA model.
% RETURN f : The calculated value of the variational Beta objective.
 
% PPA 

model.B = BExpandParam(model.B,params);
f = ppaVarLikeBetaScalLogLikelihood(model);
f = -f;