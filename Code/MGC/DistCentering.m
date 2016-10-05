function [A]=DistCentering(X,option)
% An auxiliary function that properly centers the distance matrix X,
% depending on the choice of global corr.
n=size(X,1);

% centering for distance correlation / modified distance correlation /
% Mantel coefficient
switch option
    case 'dcor' % single centering of dcor
        EX=repmat(mean(X,1),n,1); % column centering
    case 'mcor' % single centering of mcor
        EX=repmat(sum(X,1)/n,n,1);
        EX=EX+X/n;
    case 'mantel'
        EX=sum(sum(X))/n/(n-1);
    case 'dcorDouble' % original double centering of dcor
       EX=repmat(mean(X,1),n,1)+repmat(mean(X,2),1,n)-mean(mean(X)); 
    case 'mcorDouble' % original double centering of mcor
        EX=repmat(mean(X,1),n,1)+repmat(mean(X,2),1,n)-mean(mean(X)); 
        EX=EX+X/n;
end
A=X-EX;

% for mcor or Mantel, exclude the diagonal entries.
% This is a simpler diagonal modification than the original mcor
if strcmp(option,'mcor') || strcmp(option,'mantel') || strcmp(option,'mcorDouble')
    %%% meanX=sum(sum(X))/n^2;
    for j=1:n
        A(j,j)=0;
        %%% A(j,j)=sqrt(2/(n-2))*(mean(X(:,j))-meanX)*1i;  % the original diagonal modification of mcorr
    end
end