function model = ppaVarLikeOptimiseB(model,display,iters,scalarB,optAlg)

% PPAVARLIKEOPTIMISEB A function that optimises the beta variable using
% standard varaitional formulation
% FORMAT
% DESC Optimise the kernel parameters.
% ARG model : The current PPA model.
% ARG display : Option to display kernel optimisation information.
% ARG iters : The number of optimisation iterations.
% RETURN model : The updated PPA model.
% SEEALSO ppaVarLikeBetaObjective, ppaVarLikeBetaGradient
 
% PPA 
if nargin < 5
    optAlg = 'scg';
end


if nargin < 4
    scalarB = 1;
    if nargin < 3
        iters = 500;
        if nargin < 2
            display = 1;
        end
    end
end
options = defaultOptions;
if display
  options(1) = 1;
  options(9)= 1;
end
options(14) = iters;


if ~scalarB
    % Optimise where we have individual beta values
    model = optimiseParams('B',optAlg,'ppaVarLikeBetaObjective','ppaVarLikeBetaGradient',options,model);
else
    % Optimise where we have a universal beta
    model = optimiseParams('B','scg','ppaVarLikeBetaScalObjective','ppaVarLikeBetaScalGradient',options,model);
end

    