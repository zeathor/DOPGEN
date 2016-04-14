%% Saving tables
dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\SampleSize\';


%% State what MLMs to read
MLMSet = {'SF_S','FCCT_S','FEPC_S','FCSP_S','CC_S','SLHC_S'};
% MLMSet = {'SF_S'};
% MLMSet = {'FEPC_S'};

%% State the range of sample sizes
pSize = [50,100,200,500,1000,2000,5000,1e4,2e4,5e4,1e5,2e5,5e5,1e6];

%% State the dynamic
% dynamic = 'RSRG1_S';
dynamic = 'SCR_S';
% dynamic = 'TRCD_S';
% dynamic = 'RCDS_S';


%% State the DOP
% DOP = 'CGFS';
DOP = 'DF1S';
% DOP = 'MPBS';



MakeSamplingTable(MLMSet, pSize, dynamic, DOP, dirName);



