function [F,Q,Cl,Cos2,d2,t,l,Ress_L,PRess_L,Q2,W,Ress_ell,PRess_ell] =...
               BigPcaPress(Xori,drapeau);
%USAGE function [F,Q,Cl,Cos2,d2,t,l,Ress,PRess,Q2,W,Rl,Pl] = PcaPress(X,'flag'); 
% Principal Component Analysis of X
% flag is a string could be 'cov' or 'cor' (default)
%      if fals==cov  center the data but do not normalize
% use the svd of X=P*D*Q with P'*P=Q'*Q=I
% F    Matrix of the coordinates (rows)
%        F =P*Delta
% Q         Column eigenvectors (loadings as eigenvectors)
% Cl        Contributions of the row to the inertia
% Cos2  Squared cosine row vectors and factor
% d2       Squared distance to the origin
% t           Percentage of inertia
% l           Eigenvalues
% Ress   Residual sum of squares
% PRess Predicted residual sum of squares
% Q2 = 1 - PRess(ell)/Ress(ell-1)
%     with Ress(0)=Inertia of the Table 
% (i.e.  with 0 cpts PCA explains nothing)
% W is Eastment & Krzanowski (1982) index
%   => Keep cpt if W > 1
% NB Q2 and W can take weird values when 
% the number of columns is larger than the number of rows
% => keep only the values for the rank of X
%
% Work in progress.  Version: April 17 2009. Herve Abdi
% This program implements PCA as described in:
% Abdi, H., & Williams, L.J. (2010). 
% Principal component analysis. 
% Wiley Interdisciplinary Reviews: Computational Statistics, 2.
%.
% Herve Abdi.
% herve@utdallas.edu www.utdallas.edu/~herve
%
% This function is the same as PcaPress 
% but does not compute correlation between columns & factors
%


if exist('drapeau')==0;drapeau='cor';end
zscores_a=1;
% when zscore = 1
% we Z normalize
% this is the default
if exist('drapeau')==0;drapeau='zscores';end 
if lower(drapeau(1:3))=='cov'
        zscores_a=0;
end

[nI,nJ]=size(Xori);
% 1. go for the eigendecomposition
moy=mean(Xori);
X=Xori- repmat(moy,nI,1);
if zscores_a==1;
    ec=std(Xori)*sqrt(nI-1);
    X=X./repmat(ec,nI,1);
end

[P,delta,Q]=paq(X,rank(X));
lambda=delta.^2;
tau=lambda./sum(lambda);
F=P*diag(delta);
nL=length(delta);
% Go for Ress
Inertia=sum(lambda);
Ress_ell=Inertia-lambda;
Ress_L=Inertia-cumsum(lambda);

[ni,nf]=size(P);
[nj,nff]=size(Q);

% compute the coordinates
  % F= P*diag(delta)
   F=P.*repmat(delta',ni,1);
   l=delta.^2;
   t=l./(sum(l));
% correlations  
%   R=corrcoef([F,X]);
%   R=R(nf+1:nf+nj,1:nf);
% Row Contributions    
   signe=2*(F>0)-1;
   F2=F.^2;
   MF2=(1/ni)*F2;
   V=sum(MF2);
   Cl=(MF2)*diag(ones(1,nf)./V).*signe;
% d2 to center of space   
   d2=sum(MF2,2);
% Cosine
   Cos2=MF2./(d2*ones(1,nf));

% Now go for Press
% Try PRESS
% No alternative. Need to used a (ugly) loop 
PRess_ell=zeros(nL,1);
PRess_L=zeros(nL,1);
% ugly loop
for i=1:nI;
    Xori_i=Xori;
    Xori_i(i,:)=[];
    moy=mean(Xori_i);
    Xi=Xori_i-repmat(moy,nI-1,1);
      if zscores_a==1;
        ec_i=std(Xori_i)*sqrt(nI-2);
        Xi=Xi./repmat(ec_i,nI-1,1);
      end
    % Real random Model
    % assumes that Population mean and std are not known
    xi=Xori(i,:)-moy;
      if zscores_a==1;
       xi=xi./ec_i;
      end
    [Pi,deltai,Qi]=paq(Xi,nL);
    nLi=length(deltai);
    % isup_rec=repmat((xi*Qi)',1,nLi).*Qi' % old version
    isup_rec=repmat((xi*Qi)',1,nLi)*Qi';
    % build back the ith row for the nL eigenvector
    % i_rec is a L*J matrix
    % where the ellth row is the ellth reconstitution
    % of i
    isup_dev=isup_rec-repmat(xi,nLi,1);
    %
    PRess_ell=PRess_ell+...
        padzerosafter(sum( (isup_dev).^2,2),nL);
    % 
    % PRESS_L here
    isup_rec_L=zeros(nL,nJ);
    proj_xi=xi*Qi;
    for ell=1:nLi;
        isup_rec_ell=proj_xi(1:ell)*(Qi(:,[1:ell])' );
        isup_rec_L(ell,:)=isup_rec_ell;
    end
    isup_dev_L=isup_rec_L-repmat(xi,nL,1);
    PRess_L=PRess_L+...
        sum( (isup_dev_L).^2,2);
    %
end

% Compute Q2 
Q2=1- PRess_L./[Inertia; Ress_L(1:nL-1)] ;

% Compute W
W1= ( ([Inertia; PRess_L(1:nL-1)] - PRess_L )./PRess_L)';
Wnum=nI+nJ-2*[1:nL] ;
Wden= nJ*(nI-1)*ones(1,nL) - [1:nL].*(  (nJ+nI-1)*ones(1,nL) - [1:nL]);
W=( W1.*(Wnum./Wden))';
if isinf(W(nL));W=W(1:nL);end;


% function here
function ypad=padzerosafter(y,ns)
% USAGE ypad=padzeroafter(y,size)
% pad vector y with zeros after such that
% its size is equal to ns
[ni,nj]=size(y);
if (ni~=1)&(nj~=1)
 error('works with vector only')
end
if ni==1; % row vector
   ypad=[y zeros(1,ns-nj)];
end
if nj==1; % row vector
   ypad=[y ;zeros(1,ns-ni)];
end
function [P,a,Q]=paq(X,k);
%USAGE [P,a,Q]=paq(X,k);
% k-Singular value decomposition of the I by J matrix X
%if k is not present then k=min{I,J}
%if k is larger larger than min{I,J} then k= min
%if k is larger than K=the actual number 
%        of singular values, then k=K
% the singular vectors and values are ordered
% in decreasing order
% P are the eigenvectors of X'X
% Q are the eigenvector of XX'
% a is the vector of the SINGULAR values
% NOTE that a = sqrt(lambda)
% where lambda are the eigenvalues of both X'X and XX'
% % Herve Abdi. 1990 / October 2004 (revised version)
% 
   epsilon=2*eps;
%  tolerance to be considered 0 for an eigenvalue
[I,J]=size(X);
m=min(I,J); 
if nargin==1, k=m;
        else if k > m, k=m;end;
     end;
flip=0; 
if I < J, X=X';flip=1;end;
% Incorporate eigen routine here %%%%%
  [Q,l]=eig(X'*X);
  l=diag(l);
  [l,k2]=sort(l);
  n=length(k2);
  l=l((n+1)-(1:n));
  Q=Q(:,k2((n+1)-(1:n)));
% keep the non-zero eigen value only (tolerance=epsilon)
  pos=find(any([l';l'] > epsilon ));
  l=l(pos);
  Q=Q(1:n,pos);
 %%%%%% End of Eigen %%%%%%%%%%%%%%%%%
ll= max(size(l)); if k > ll, k=length(l);end;
Q=Q(:,1:k);
l=l(1:k);
a=sqrt(l);
[niq,njq]=size(Q);
P=X*(Q.*repmat((1./a)',niq,1));
if flip==1,X=X';
bidon=Q;Q=P;P=bidon;end;
% and that should be it !
