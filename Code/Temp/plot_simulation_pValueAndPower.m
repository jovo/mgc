function []=plot_simulation_pValueAndPower(type,n,dim)
% Compare p-value heatmap with power heatmap 
if nargin<1
    type=13;
end
if nargin<2
    n=100;
end
if nargin<3
    dim=1;
end
rep=1000;
fontSize=20;

%%% File path searching
fpath = mfilename('fullpath');
fpath=strrep(fpath,'\','/');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
strcat(rootDir,'Code/');
addpath(genpath(strcat(rootDir,'Code/')));
pre1=strcat(rootDir,'Data/Results/'); % The folder to locate data
pre2=strcat(rootDir,'Figures/Fig');% The folder to save figures

%% Set colors
map2 = brewermap(128,'GnBu'); % brewmap

% 1-d or h-d
if dim>1
    filename=strcat(pre1,'CorrIndTestDimType',num2str(type),'N100Dim.mat');
    n=100;
    nd=dim;
    [x, y]=CorrSampleGenerator(type,n,dim,1, 0);
else
    filename=strcat(pre1,'CorrIndTestType',num2str(type),'N100Dim1.mat');
    dim=1;
    nd=n;
    [x, y]=CorrSampleGenerator(type,n,dim,1, 1);
end

% For p-value: 
% Get distance matrix
C=squareform(pdist(x));
D=squareform(pdist(y));

% Calculate permutation p-value
tA=LocalCorr(C,D,2);
tN=zeros(rep,n,n);
pAll=zeros(n,n);
for r=1:rep;
    per=randperm(n);
    tmp=LocalCorr(C,D(per,per),2);
    tN(r,:,:)=tmp;
    if r==1
        pAll=(tmp<tA)/rep;
    else
        pAll=pAll+(tmp<tA)/rep;
    end
end
pAll=1-pAll;

h=figure(type);
set(h,'units','normalized','position',[0 0 1 1]);
ax=subplot(1,2,1);
ph=pAll(2:end,2:end)';
ph(ph<=eps)=0.0005;
imagesc(log(ph)); %log(ph)-min(log(ph(:))));
axis('square')
set(gca,'FontSize',fontSize)
set(gca,'YDir','normal')
cmap=map2;
colormap(ax,flipud(cmap));
% caxis([0 1]);
cticks=[0.001, 0.01, 0.1, 0.5];
h=colorbar('Ticks',log(cticks),'TickLabels',cticks);%,'location','westoutside');
set(h,'FontSize',fontSize);
set(gca,'XTick',[1,round(n/2)-1,n-1],'YTick',[1,round(n/2)-1,n-1],'XTickLabel',[2,round(n/2),n],'YTickLabel',[2,round(n/2),n],'FontSize',16);
%xlabel('# of Neighbors for X','FontSize',16)
%ylabel('# of Neighbors for Y','FontSize',16) %,'Rotation',0,'position',[-7,20]);
xlim([1 n-1]);
ylim([1 n-1]);
title('Multiscale P-value Map')

% For Power
load(filename);
if dim>1
    numRange=dimRange;
end
ind=find(numRange>=nd,1,'first');
if lim==21 && ind>1
    ind=ind-1;
end
kmin=2;
if dim==1
    ph=power2All(kmin:numRange(ind),kmin:numRange(ind),ind)';
else
    ph=power2All(kmin:n,kmin:n,ind)';
end
ax=subplot(1,2,2);
imagesc(ph);
axis('square')
set(gca,'YDir','normal')
colormap(map2)
caxis([0 1])
cticks=[0,0.5,1];
h=colorbar('Ticks',cticks);%,'location','westoutside');
set(gca,'FontSize',fontSize);
nn=size(ph,1)+1;
set(gca,'XTick',[1,round(nn/2)-1,nn-1],'XTickLabel',[2,round(nn/2),nn]); % Remove x axis ticks
set(gca,'YTick',[1,round(nn/2)-1,nn-1],'YTickLabel',[2,round(nn/2),nn]); % Remove x axis ticks
xlim([1 nn-1]);
ylim([1 nn-1]);
title('Multiscale Power Map')
h=suptitle(CorrSimuTitle(type));
set(h,'FontSize',32);% for 1-Dimensional Simulations'));

%% 
F.fname=strcat(rootDir, 'Code/Temp/',num2str(type),'_n', num2str(n),'_d', num2str(dim));
F.wh=[8 5]*2;
print_fig(gcf,F)