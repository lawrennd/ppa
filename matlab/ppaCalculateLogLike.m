function loglike = ppaCalculateLogLike(model)

% PPACALCULATELOGLIKE Compute the log likelihood of the data.

% PPA

invK=model.kern.invKstore;
[invK, UK] = pdinv(model.kern.Kstore);
loglike = 0;
logdetK = logdet(model.kern.Kstore,UK);
numData = size(model.y, 1);
for i = 1:size(model.y, 2)
  invV = diag(model.B(:, i)) + invK;
  [V, UV] = pdinv(invV);
  mu = V*diag(model.B(:, i))*model.expectations.f(:, i);
  m = model.expectations.fBar(:, i);
  
  % in parts which are the equations
  part1 = -0.5.*logdetK-0.5.*logdet(invV, UV);
  
  part2 = model.expectations.fBar(:, i)'*diag(model.B(:, i))* ...
      model.expectations.f(:, i);
  
  part3 = -model.expectations.f(:, i)'*diag(model.B(:, i))*m + 0.5.*m'* ...
      diag(model.B(:, i))*m;
  
  part4 = -model.expectations.fBar(:, i)'*invV*mu+0.5.*mu'*invV*mu;

  loglike = loglike + part1+part2+part3+part4;
end
loglike = loglike + noiseLogLikelihood(model.noise, model.expectations.fBar, 1./model.B, model.y);
loglike = loglike + kernPriorLogProb(model.kern);