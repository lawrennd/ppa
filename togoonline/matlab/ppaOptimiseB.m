function model = ppaOptimiseB(model,display,iters,scalarB,optAlg)

% PPAOPTIMISEB A function that optimises the beta variable using KL formulation
% FORMAT
% DESC  A function that optimises the beta variable using KL formulation
% ARG model : The current PPA model.
% ARG display : Option to display kernel optimisation information.
% ARG iters : The number of optimisation iterations.
% ARG scalerB : Option for choice of form for beta.
% RETURN model : The updated PPA model.
% SEEALSO ppaBetaScalObjective, ppaBetaScalGradient
 
% PPA 

%if nargin < 5
    optAlg = 'scg';
%end

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
       model = optimiseParams('B','scg','ppaBetaObjective','ppaBetaGradient',options,model);
else
    % Optimise where we have a universal beta
    model = optimiseParams('B',optAlg,'ppaBetaScalObjective','ppaBetaScalGradient',options,model);
end
