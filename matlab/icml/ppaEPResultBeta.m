function ppaEPResultBeta(dataSet)

% For desktop
HOME = 'h:\';

% Laptop
HOME = 'd:\work';

% Cluster
HOME = '/home/nk3';
fs = filesep;

kernelType={'rbf','whitefixed'};

% Create Z matrix stores
ZMLength = zeros(10,1);
ZInfo = zeros(10,1);
ZClass = zeros(10,1);



% Setup 
for dataSetNum = 1:10
    % load data correct data file
    
    modelDat = load([HOME filesep 'mlprojects' filesep 'data'  filesep dataSet filesep 'EPResults' filesep 'ppa' dataSet 'Beta' '_' num2str(dataSetNum) '_' kernelType{1}]);
    if isnan(modelDat.aveM)
        noNumAveM =  dataSetNum
    else
        ZMLength(dataSetNum) = modelDat.aveM;
    end
    
    if isnan(modelDat.aveInfoVal)
        noNumAveInfoVal =  dataSetNum
    else
    ZInfo(dataSetNum) = modelDat.aveInfoVal;
    end
    
    if isnan(modelDat.classError)
        noNumClass =  dataSetNum
    else
        ZClass(dataSetNum) = modelDat.classError;  
    end
    
    
    
    
end

mLengthAv = mean(ZMLength)
infoAv = mean(ZInfo)
classAv = mean(ZClass)

     
if isdir([HOME filesep 'mlprojects' filesep 'data' filesep 'EPCompareResults'])~=1
    mkdir([HOME filesep 'mlprojects' filesep 'data' filesep],'EPCompareResults');
end

save([HOME filesep 'mlprojects' filesep 'data' filesep 'EPCompareResults' filesep dataSet 'Beta' kernelType{1} 'Results'], 'mLengthAv', ...
    'infoAv', 'classAv');     








