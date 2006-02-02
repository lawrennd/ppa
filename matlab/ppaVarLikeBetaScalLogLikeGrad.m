function g = ppaVarLikeBetaScalLogLikeGrad(model)

% PPAVARLIKEBETASCALLOGLIKEGRAD - Calculate the variational log-likelihood Gradient

f = model.expectations.f;
ff = model.expectations.ff;
fBar = model.expectations.fBar;
fBarfBar = model.expectations.fBarfBar;

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    numData = size(model.X, 1);
    numOut = size(model.y, 2);
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    

g = 0;


for j = 1:size(fBarfBar,3)
    g = g + sum(B(:,j).^-1) -sum(ff(:,j)-2.*f(:,j).*fBar(:,j)+diag(fBarfBar(:,:,j)));
end



g = 0.5*g;