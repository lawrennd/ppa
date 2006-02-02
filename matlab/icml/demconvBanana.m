
% DEMCONVBANANA Script that runs the two different types of M step updates and plots results

% PPA

% Alternative data set the can not be solved linearly
X=load('../data/banana_train_data_1.asc');
y=load('../data/banana_train_labels_1.asc');


% Define the noise model to be used
noiseModel='probit';

% Define the kernel to be used
kernelType={'rbf','bias', 'white'};

options = ppaOptions;
options.display = 1; % display graphically as we go.
options.rememLoglikeVals = 1;
%model=ppa(X, y, noiseModel, kernelType);


% Do updates with KL correction
options.varKern=0;
model=ppa(X, y, noiseModel, kernelType);
[model, KLLogLike,cputime]=ppaOptimisePPA(model, options);
KLCPUAVE=mean(cputime);
numKLIters = model.numIters;
KLFinalLogLike = model.logLike;
KLCPU=cputime;
figure

ppaTwoDPlot(model, numKLIters, model.X, model.y);
title(['KL Corrected'],'color','w');

% save these details
save('KLsave',  'KLLogLike', 'numKLIters', 'KLFinalLogLike','cputime')

% Do updates with SV correction
options.varKern=1;

model=ppa(X, y, noiseModel, kernelType);


[model, SVLogLike,cputime]=ppaOptimisePPA(model, options);
numSVIters = model.numIters;
SVFinalLogLike = model.logLike;
SVCPUAVE=mean(cputime);
SVCPU=cputime;
figure 
ppaTwoDPlot(model, numSVIters, model.X, model.y);
title(['Standard Variational'],'color','w');
% save these details
save('SVsave',  'SVLogLike', 'numSVIters', 'SVFinalLogLike','cputime')


% Plot convergence figure
figure
semilogx([1:numKLIters+1],KLLogLike,'-r')
hold on;
semilogx([1:numSVIters+1],SVLogLike,':g')
STRING1 = ['KL Corrected ~ CPU Time = ', num2str(KLCPUAVE)];
STRING2 = ['Standard Variational ~ CPU Time = ', num2str(SVCPUAVE)];
legend(STRING1,STRING2,'Location','SouthEast');
plot(numKLIters,KLFinalLogLike,'xr');
plot(numSVIters,SVFinalLogLike,'xg');
grid on;
title(['Convergence Speed for Banana data set'],'color','w');
xlabel('log likelihood','color','w');
ylabel('Iteration number','color','w');

% Plot cpu figure
figure
semilogx([1:numKLIters+1],KLCPU,'-r')
hold on;
semilogx([1:numSVIters+1],SVCPU,':g')
STRING1 = ['KL Corrected'];
STRING2 = ['Standard Variational'];
legend(STRING1,STRING2,'Location','SouthWest');
grid on;
title(['Cpu time for Banana data set'],'color','w');
xlabel('log likelihood','color','w');
ylabel('Iteration number','color','w');
