function ppaGunnarResults

% PPAGUNNARRESULTS A function that loads up the multiple training datasets and
% chooses the model parameters for the model that best meets the Gunnar Raetsch
% conditions

% PPA

% Define the data sets to use
dataSets = {'banana', 'breast-cancer', 'diabetis','german','heart','titanic','twonorm','waveform'};

invWidths = [0.1 1 10];
for i = 1:length(dataSets)
  for dataNum = 1:5
    for j = 1:length(invWidths);
      invWidth = invWidths(j);
      invWidthStr = num2str(invWidth);
      invWidthStr(find(invWidthStr==46))='p';
      fileName = ['ppa' dataSets{i} num2str(dataNum) 'rbf_' ...
                  invWidthStr];
        load(fileName);
      llRes(i, dataNum, j) = ll;
      classErrorRes(i, dataNum, j) = classError;
      numItersRes(i, dataNum, j) = numIters;
      noiseParamRes{i, dataNum, j} = noiseParam;      
      kernParamRes{i, dataNum, j} = kernParam;
      betaRes(i, dataNum, j) = beta;
    end
  end
end
clear noiseParam kernParam
[ll, index] = max(llRes, [], 3);
for i = 1:length(dataSets)
  for j = 1:5
    classError(i, j) = classErrorRes(i, j, index(i, j));
    numIters(i, j) = numItersRes(i, j, index(i, j));
    noiseParam{i}(j, :) = noiseParamRes{i, j, index(i, j)};
    kernParam{i}(j, :) = kernParamRes{i, j, index(i, j)};
    beta(i, j) = betaRes(i, j, index(i, j));
  end
end
for i = 1:length(dataSets)
  [void, ind] = sort(kernParam{1}(:, 1));
  kernVals{i} = kernParam{i}(ind(3), :);
  noiseVals{i} = noiseParam{i}(ind(3), :);
  betaVal(i) = beta(i, ind(3));
end

for i = 1:length(dataSets)
  kernParam = kernVals{i};
  noiseParam = noiseVals{i};
  beta = betaVal(i);
  here=1
  fileName = ['ppa' dataSets{i} 'Rbf'];
  save(fileName, 'kernParam', 'noiseParam', 'beta');
end