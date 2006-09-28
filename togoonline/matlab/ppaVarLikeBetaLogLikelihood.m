function L = ppaVarLikeBetaLogLikelihood(model)

% PPAVARLIKEBETALOGLIKELIHOOD Calculate the variational log-likelihood for
% beta.
% FORMAT
% DESC Calculate the variational log-likelihood for beta scalar.
% ARG model : The current PPA model.
% RETURN L : The calculated value of the variational likelihood.
 
% PPA 

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

L = 0;
for j = 1:size(fBarfBar,3)
    L = L + 0.5.*logdet(diag(B(:,j)))-0.5.*sum(B(:,j).*(ff(:,j)-2.*f(:,j).*fBar(:,j)+diag(fBarfBar(:,:,j))));
end