function ppaPlotConvergenceResults(dataSet,dataNum)

% PPAPLOTCONVERGENCERESULTS A function that plots the comparisons between the KL likelihood and the
% standard variational likelihood then saves the resulting figures in the EPS format

% PPA

% Load the given dataset
HOME = getenv('HOME');

%My desktop
%HOME='h:\'

% my laptop home
HOME='d:\work'

% my pascal cluster home
%HOME = '/home/nk3';

fs = filesep;
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep dataSet filesep];

% save these details
load([baseDir  'ICMLconv' filesep dataSet 'convergence_' num2str(dataNum) '.mat']);

% Plot the converegence figure
figure

semilogx([1:numKLIters+1],KLLogLike,'-r','linewidth',2) % Plot KL convergence results
hold on;
semilogx([1:numSVIters+1],SVLogLike,'-.g','linewidth',2) % Plot SV convergence results


plot(numKLIters+1,KLFinalLogLike,'xr','linewidth',2,'markersize', 12); % Plot final KL Likelihood
plot(numSVIters+1,SVFinalLogLike,'xg','linewidth',2,'markersize', 12); % Plot final SV Likelihood
grid on; 

set(gca,'fontname', 'times');
set(gca,'fontsize',20);
set(gca,'XTick',[0, 10^0,10^1,10^2,10^3,10^4,10^5])
ylabel('log likelihood','color','w');
xlabel('Iteration number (log scale)','color','w');

% Save  
% Print the figure
FILENAME = [baseDir  'ICMLconv' filesep dataSet '_' num2str(dataNum) '_' 'convFig.eps'];
print(gcf,'-deps',FILENAME);

% Plot the CPU times figure
figure

semilogx([1:numKLIters+1],KLCPU,'-r','linewidth',2)
hold on;
semilogx([1:numSVIters+1],SVCPU,'-.g','linewidth',2)

grid on;

set(gca,'fontname', 'times');
set(gca,'fontsize',20);

ylabel('CPU timings in seconds','color','w');
xlabel('Iteration number (log scale)','color','w');

% Save  
% Print the figure
FILENAME = [baseDir  'ICMLconv' filesep dataSet '_' num2str(dataNum) '_' 'cpuFig.eps'];
print(gcf,'-deps',FILENAME);

% Calculate relevent convergence information
KLTotal = max(cumsum(KLCPU));
SVTotal = max(cumsum(SVCPU));
diffCpu = SVTotal -KLTotal;
diffIters = numSVIters  - numKLIters;

% Display convergence information
fprintf('KL classification = %2.7f and SV classification = %2.7f\n', KLClass, SVClass);
fprintf('KL loglike = %2.7f and SV loglike = %2.7f\n',KLFinalLogLike, SVFinalLogLike);
fprintf('KL total number of iterations = %2.7f, SV total number of iterations = %2.7f\n',numKLIters,numSVIters);
fprintf('The difference between the iteration numbers (SV - KL) = %2.7f\n',diffIters);
fprintf('KL total CPU time = %2.7f and SV total CPU time = %2.7f\n',KLTotal,SVTotal);
fprintf('The difference between the CPU times (SV - KL) = %2.7f\n',diffCpu);

