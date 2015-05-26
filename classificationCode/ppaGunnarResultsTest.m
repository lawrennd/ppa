function ppaGunnarResultsTest(dataSet);

% PPAGUNNARRESULTSTEST Helper script for collating results on Gunnar's benchmarks.

% PPA

% Load the given data set
load(['ppa' dataSet 'Rbf']);
b = beta;

% Iterate over the first 10 folds
for dataNum = 1:10
  er(dataNum) = ppaGunnarTest(dataSet, dataNum, {'rbf', 'white', 'bias'}, ...
                                kernParam, noiseParam, b);
end

% Save the class errors of the datasets
save(dataSet, 'er');
