function fBarLike = ppaNewfBarLike(model, calcqfBar)

% PPANEWFBARLIKE A function that can be used to debug PPA
% FORMAT
% DESC A function that can be used to debug PPA
% ARG model : The current PPA model.
% ARG calcqfBar : Binary variable where we cna decide to update q(fBar).
% RETURN fBarLike : Calculate the likelihood of fBar.

% PPA


[invK, UK] = pdinv(model.kern.Kstore);


numData = size(model.y, 1);

B = model.B;

fBarLike=0;

for i = 1 : size(model.y,2)
    part1 = -0.5.*size(model.y,1)*log(2*pi) + 0.5.*size(model.y,1)*log(model.B(:,i)) ...
              -0.5.*model.B(:,i).*sum(model.expectations.ff(:,i)) ...
                + model.B(:,i).*model.expectations.f(:,i)'*model.expectations.fBar(:,i) ...
                   - 0.5 .* model.B(:,i) * sum(diag(model.expectations.fBarfBar(:,:,i)));
               
    part2 = -0.5.*size(model.y,1)*log(2*pi) - 0.5.*logdet(model.kern.Kstore,UK) ...
               - 0.5 .* trace(model.expectations.fBarfBar(:,:,i)*invK);
           
    part3 = -model.qExpectfBar;
    
    fBarLike = fBarLike + part1 + part2 + part3;
end
