function model = ppaInit(model, options)

% PPAINIT Initialise the probabilistic point assimilation model.
% FORMAT
% DESC Initialise the probabilistic point assimilation model.
% ARG model : The current PPA model.
% ARG options : The options for the PPA model.
% RETURN model : The updated PPA model.
% SEEALSO ppaEStep,ppaQExpectLike
 
% PPA 

% Get number of data.
numData = size(model.X, 1);
numOut = size(model.y, 2);

% Add information about whether we are using a single precison or not
model.options.scalarB=options.scalarB;

% Compute the full kernel matrix.
model.kern.Kstore=kernCompute(model.kern, model.X);
% Get its inverse.
model.kern.invKstore=pdinv(model.kern.Kstore);

% initialise B.
if isempty(model.B)
    if ~options.scalarB
        % if independent beta values then create a matrix
        model.B = repmat(1, numData, numOut);
    else
        % if scalar then store a single value
        model.B = repmat(1, 1, numOut);
    end    
end

model.g = zeros(numData, numOut);
model.nu = zeros(numData, numOut);
model.gamma = zeros(numData, numOut);

if options.doDebug
    % Set up debug matrix
    model.oldLogLike=0;
    model.updatediffs = [0,0,0,0,0,0,0,0,0,0,0,0];
end

if strcmp(model.noise.type,'gaussian')
        [model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,1);
else
    model.qExpectf = 1;
[model.qExpectfBar , model.qExpectf] = ppaQExpectLike(model,1,0);    
end

model = ppaEStep(model,options);

