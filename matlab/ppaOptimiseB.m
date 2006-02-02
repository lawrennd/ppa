function model = ppaOptimiseB(model,display,iters,scalarB)

% PPAOPTIMISEB - A function that optimises the beta variable using standard varaitional formulation

% PPA

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
    model = optimiseParams('B','scg','ppaBetaScalObjective','ppaBetaScalGradient',options,model);
end
