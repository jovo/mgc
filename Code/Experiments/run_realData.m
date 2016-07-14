function run_realData(rep)
% run real data experiments
if nargin<1
    rep=10000;
end

%%% File path searching
fpath = mfilename('fullpath');
fpath=strrep(fpath,'\','/');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
strcat(rootDir,'Code/');
addpath(genpath(strcat(rootDir,'Code/')));

%%%
load(strcat(rootDir,'Data/Preprocessed/BrainHippoShape.mat'))
n=114;
y=squareform(pdist(Label));
% y=(y>0)+1;
y=y+1;
for i=1:n
    y(i,i)=0;
end
% y(y>0)=1;
CorrPermDistTest(LMLS,y,rep,'BrainLMLxY');
CorrPermDistTest(LMRS,y,rep, 'BrainLMRxY');
CorrPermDistTest(LMLS,LMRS,rep,'BrainLMLxLMR');


%
load(strcat(rootDir,'Data/Preprocessed/semipar.mat'))
n=109;
distCCI=squareform(pdist(cci));
CorrPermDistTest(distMigrain(ind,ind),distCCI(ind,ind),rep,'MigrainxCCI');
CorrPermDistTest(distM2g(ind,ind),distCCI(ind,ind),rep,'M2gxCCI');
CorrPermDistTest(distM2g(ind,ind),distMigrain(ind,ind),rep,'M2gxMigrain');