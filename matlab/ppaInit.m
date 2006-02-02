function model = ppaInit(model, options)

% PPAINIT Initialise the probabilistic point assimilation model.

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

% Set up debug matrix
model.oldLogLike=0;

if options.doDebug
    model.kern.Kstore = eye(size(model.kern.Kstore));
    
    model.expectations.f = ones(size(model.y));
    [oldfBarLike,model] = ppaNewfBarLike(model, 1);
    
    for i = 1 : size(model.y,2)
        model.ninvC(:,:,i) = pdinv(model.kern.Kstore) + model.B.*eye(size(model.kern.Kstore));
    end

    model.updatediffs = [0,0,0,0];
end
model = ppaEStep(model,options);









