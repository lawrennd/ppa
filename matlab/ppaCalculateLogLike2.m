function loglike = ppaCalculateLogLike2(model)

% PPACALCULATELOGLIKE2 Compute the log likelihood of the data.

% PPA

invK=model.kern.invKstore;
loglike = 0;
logdetK = logdet(model.kern.Kstore);
numData = size(model.y, 1);
for i = 1:size(model.y, 2)
  invV = diag(model.B(:, i)) + invK;
  [V, UV] = pdinv(invV);
  mu = V*diag(model.B(:, i))*model.expectations.f(:, i);
  m = model.expectations.fBar(:, i);
  % in parts which are the equations
  
  part1 = -0.5.*logdetK-0.5.*logdet(invV, UV);
  part2 = -0.5.*trace(model.expectations.fBarfBar(:, :, i)*diag(model.B(:, i)))...
          -0.5.*trace(model.expectations.fBarfBar(:, :, i)*invK);

  part3 = 0.5.*trace(model.expectations.fBarfBar(:, :, i)*invV);
  part4 = model.expectations.fBar(:, i)'*diag(model.B(:, i))* ...
          model.expectations.f(:, i);
  part5 = -model.expectations.f(:, i)'*diag(model.B(:, i))*m + 0.5.*m'* ...
          diag(model.B(:, i))*m;
  part6 = -model.expectations.fBar(:, i)'*invV*mu+0.5.*mu'*invV*mu;
  part7 = 0;
  % Loop over the data points
  for j=1:numData
    % Calculate the c value from paper for log Z
    c = model.y(j, i)./sqrt(model.noise.sigma2+1./model.B(j,i));
    % Calculate the u value from paper for log Z
    u = c.*(m(j)+ model.noise.bias);
    % Calculate part6 for a current point then add to total
    part7=part7+lnCumGaussian(u);
    % Or its this
    % part6=part6+cumGaussian(u)*lnCumGaussian(u);
  end
  loglike = loglike + part1+part2+part3+part4+part5+part6+part7;
end