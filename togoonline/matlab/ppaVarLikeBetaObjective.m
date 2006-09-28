function f = ppaVarLikeBetaObjective(params,model)

% PPAVARLIKEBETAOBJECTIVE Objective function for the scalar beta standard variational update.
% FORMAT
% DESC Objective function for the scalar beta standard variational update.
% ARG params : A vector of the current param values.
% ARG model : The current PPA model.
% RETURN f : The calculated value of the variational Beta objective.
 
% PPA 

model.B = BExpandParam(model.B,params);
f = ppaVarLikeBetaLogLikelihood(model);
f = -f;