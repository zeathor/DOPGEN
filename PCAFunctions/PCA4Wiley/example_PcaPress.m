%
% This is an example of how to call 
% the matlab functions PcaPress & BigPcaPress
% 
% The example is the "Food and Social Class" example
%         described in 
% Abdi, H., & Williams, L.J. (in press, 2010). 
% Principal component analysis. 
% Wiley Interdisciplinary Reviews: Computational Statistics, 2.
% This example calls PcaPress BigPcaPress and plotxyha
%
% October 2009.
% Herve Abdi.
% herve@utdallas.edu www.utdallas.edu/~herve
%


% firt clean the workspace
clear



Xori=...
[89.821  59.760  68.502  48.099  56.296  95.478  71.116  95.701
 97.599  88.842  95.203  71.796  97.880 113.122  72.172  92.310
 91.043  79.551 104.336  55.900 107.807  91.229  60.906  97.735
 30.015  22.517  60.330  21.886  53.049  23.127  12.067  37.204
 37.438  38.294  50.967  29.938  60.807  31.974  17.472  35.718
 83.442  48.037  59.176  47.027  43.554  84.609  67.567  81.807
 71.200  47.990  86.850  35.600  86.857  57.643  38.631  67.779
 37.969  15.468  33.195  12.294  32.042  25.887  27.050  37.339
 34.604  68.132  63.888  48.687  86.538  63.560  35.904  40.778
 74.856  36.043  61.235  37.381  53.980  64.714  48.673  73.166];


% nomt(1,1)={' '};
nn=0;
nn=nn+1;nomt(nn,1)={' L!'};  
nn=nn+1;nomt(nn,1)={' L2'}; 
nn=nn+1;nomt(nn,1)={' L3'}; 
nn=nn+1;nomt(nn,1)={' L4'}; 
nn=nn+1;nomt(nn,1)={' L5'}; 
nn=nn+1;nomt(nn,1)={' L6'}; 
nn=nn+1;nomt(nn,1)={' L7'}; 
nn=nn+1;nomt(nn,1)={' L8'}; 
nn=nn+1;nomt(nn,1)={' L9'}; 
nn=nn+1;nomt(nn,1)={' L!0'}; 
[ni,nj]=size(Xori);


% here we want a "covariance" PCA analysis
% so we use the flag option "cov"
drapeau='cov';
[F,R,Q,Cl,Cos2,d2,t,l,Ress_L,PRess_L,Q2,Ress_ell,PRess_ell] =...
               PcaPress(Xori,drapeau);

% example of call to BigPcaPress
% identical but does not compute
% correlation between columns and factors
% because this requires too much memory 
% when the number of columns of X is too large
drapeau='cov';
[F,Q,Cl,Cos2,d2,t,l,Ress_L,PRess_L,Q2,Ress_ell,PRess_ell] =...
               BigPcaPress(Xori,drapeau);


% plot the rows
nfig=0;
nfig=nfig+1;figure(nfig);clf

plotxyha(F,1,2,'PCA Example: CSP. Row factor scores',nomt)

nfig=nfig+1;figure(nfig);clf

plotxyha(Q,1,2,'PCA Example: CSP. Columns loadings ',nomt)

disp(['PCA Done'])