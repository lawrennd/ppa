function [model,options]= ppaEStep(model, options)

% PPAESTEP Perform the expectation step in the EM optimisation.

% PPA


numData = size(model.X, 1);
numOut = size(model.y, 2);

if ~model.options.scalarB
    % if independent beta values then create a matrix
    B = model.B;
else
    % if scalar then store a single value
    B = repmat(model.B, numData, 1);
end    
    

if ~options.varKern
    [currentLogLike]=ppaCalculateLogLike(model);
end

if options.doDebug
    % Do E step check
    [oldfBarLike,model] = ppaNewfBarLike(model, 0);
    oldmodel = model;
end
    
    model = ppaExpectfBar(model); % these are expectations under q(fBar)
    model = ppaExpectfBarfBar(model);

if options.doDebug
    diff = ppadiffFBar(model,oldmodel) 
    [newfBarLike,model] = ppaNewfBarLike(model, 1);
    
    for i = 1 : size(model.y,2)
        model.ninvC(:,:,i) = pdinv(model.kern.Kstore) + model.B(:,i);
    end

    model.updatediffs(3) = newfBarLike-oldfBarLike;
end

% Compute G and nu
 [model.g, model.nu] = noiseUpdateNuG(model.noise, ...
                                      model.expectations.fBar, ...
                                      1./B, ...
                                      model.y);

% Compute gamma
model.gamma = (((model.g).^2)-model.nu)/2;
    

model = ppaExpectf(model); % these are expectations under q(f)

model = ppaExpectff(model);
