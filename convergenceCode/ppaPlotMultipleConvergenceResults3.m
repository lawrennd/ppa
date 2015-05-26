function ppaPlotMultipleConvergenceResults3(dataNum)

% PPAPLOTMULTIPLECONVERGENCERESULTS3 A function that plots the comparisons between the KL likelihood and the
% standard variational likelihood for the heart and diabetis datasets and
% then saves the results in EPS.

% PPA

% Load the given dataset
HOME = getenv('HOME');

%My desktop
%HOME='h:\'

% my laptop home
HOME='d:\work'

% my pascal cluster home
%HOME = '/home/nk3';

% Set up base directory
fs = filesep;
baseDir = [HOME filesep 'mlprojects' filesep 'data' filesep];


% Data Sets to plot together
dataSet1 = 'heart';
dataSet2 = 'diabetis'

% Plot the converegence figure
figure

% Load the first dataset
load([baseDir  dataSet1 filesep 'ICMLconv' filesep dataSet1 'convergence_' num2str(dataNum) '.mat']);

% Plot the first data set
semilogx([1:numKLIters+1],KLLogLike,'-r','linewidth',2) % Plot KL convergence results
hold on;
semilogx([1:numSVIters+1],SVLogLike,'-.g','linewidth',2) % Plot SV convergence results
plot(numKLIters+1,KLFinalLogLike,'xr','linewidth',2,'markersize', 12); % Plot final KL Likelihood
plot(numSVIters+1,SVFinalLogLike,'xg','linewidth',2,'markersize', 12); % Plot final SV Likelihood

% Load the second data set
load([baseDir  dataSet2 filesep 'ICMLconv' filesep dataSet2 'convergence_' num2str(dataNum) '.mat']);

% Plot the second data set
semilogx([1:numKLIters+1],KLLogLike,'-r','linewidth',2) % Plot KL convergence results
hold on;
semilogx([1:numSVIters+1],SVLogLike,'-.g','linewidth',2) % Plot SV convergence results
plot(numKLIters+1,KLFinalLogLike,'xr','linewidth',2,'markersize', 12); % Plot final KL Likelihood
plot(numSVIters+1,SVFinalLogLike,'xg','linewidth',2,'markersize', 12); % Plot final SV Likelihood

% Annotate the axis
grid on;
set(gca,'fontname', 'times');
set(gca,'fontsize',20);
set(gca,'XTick',[10^0,10^1,10^2,10^3,10^4,10^5]);
set(gca,'YTick',[-800 -700 -600 -500 -400 -300 -200 -100 0]);
ylabel('log likelihood','color','w');
xlabel('Iteration number (log scale)','color','w');

% Print figure
FILENAME = [baseDir  'ICMLconv' filesep 'heart_diabetis_1_convFig.eps'];
print(gcf,'-deps',FILENAME);
