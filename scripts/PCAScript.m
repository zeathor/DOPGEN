%% This script is solely for PCA stuff
clear GroupName;

%% type of analysis - ind, all, normind, normall
% 'norm' refers to normalising the mean metrics (only) before passing to
% PCA. This has the effect of clumping different dynamics together
% Options: 'ind','all','norm', 'zscore'
settings.analType = 'zscore';

%% Statistics to remove - goes through and removes all statistics corresponding to the type
% Options: '','Kurt','Skew'
settings.statsRemove = {'Kurt','Skew'};
% settings.statsRemove ={''};
% settings.groupName = [dynamicSet{:} settings.statsRemove{:}];

%% Individual DOPs
% DOPSet = {'MPB'};
% DOPSet = {'DF1'};
% DOPSet = {'DS'};
% DOPSet = {'CGF'};
% DOPSet = {'CF4'};
% DOPSet = {'cell'};

%% Groups of DOPs
% DOPSet = {'DF1','DS','MPB'};
% DOPSet = {'DF1','MPB'};
% DOPSet = {'CGF','MPB','DF1','CF4'};
% DOPSet = {'CGF','MPB'};
DOPSet = {'cell'};

%% Foundational Set - save as 'Dyn-All'
% dynamicSet = {'TCD','RCD','RCDFix','RCDF','TRCD','LGOM','RGOM','SCG','SCPF','SCR','SCA'};
% dynamicSet = {'LGOM','RGOM','SCPF','SCG','SCR','SCA','SCL'};
% dynamicSet = {'TCD','TRCD','LGOM','RGOM'};
% settings.groupName = [DOPSet{:} '-Dyn-All'];

%% PC set - save as 'PC-All'
% dynamicSet = {'RCDFix','RCDF','RCD'};
% dynamicSet = {'RCDF','RCD'}
% dynamicSet = {'TCD','RCDFix','RCDF','RCD','TRCD'};
% settings.groupName = 'PC-All';

%% RC Set - save as 'RCD-All'
% dynamicSet = {'RCDR','RCDS','RCDF'};
% settings.groupName = 'RCD-All';

%% Cyclic Set - save as 'Cyc-All'
% dynamicSet = {'FP1','FP2','RSR1','RSR2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSG1','RSG2'};
% settings.groupName = 'Cyc-All';

%% Step Change Set - save as 'Step-All'
% dynamicSet = {'SOP','SCR','SCG','SCA','SCL'};
% settings.groupName = 'Step-All';

%% Fixed Period Set - save as 'FP-All'
% dynamicSet = {'MPB','CGF','FP2'};
% settings.groupName = 'FP-All';

%% Random Selection Set1 - save as 'RS1-All'
% dynamicSet = {'RSR1','RSRG1','RSQR1','RSS1','RSG1'};
% settings.groupName = [DOPSet{:} '-RS1-All'];

%% Random Selection Set2 - save as 'RS2-All'
dynamicSet = {'RSR2','RSRG2','RSQR2','RSS2','RSG2'};
settings.groupName = 'RS2-Kurt-Skew';

%% individual dynamics
%% NOTE TO SELF, CHECK SC ALL (SCR), FEPC AND SLHC ARE KINDA FUCKED
% dynamicSet = {'SCA'};
% dynamicSet = {'SCR'};
% dynamicSet = {'SCR'};
% dynamicSet = {'TRCD'};
% dynamicSet = {'RCDF'};
% dynamicSet = {'SCA'};
% dynamicSet = {'TRCD'};
% settings.groupName = [dynamicSet{:} '-All'];

% MLMSet = {'SF','FCSP','FCCT','FEPC','SLHC','CC'};
% MLMSet = {'SF','FCSP','FCCT','FEPC','SLHC'};
% MLMSet = {'SF','FCSP','FCCT','FEPC','CC'};
% MLMSet = {'SF','FCSP','FCCT','SLHC','CC'};
% MLMSet = {'SF','FCSP','FEPC','SLHC','CC'};
% MLMSet = {'SF','FCCT','FEPC','SLHC','CC'};
% MLMSet = {'FCSP','FCCT','FEPC','SLHC','CC'};
MLMSet = {'FEPC'};
% MLMSet = {'SF'}
% MLMSet = {'SLHC'};
% MLMSet = {'FCCT'};
% MLMSet = {'FCSP'};
% MLMSet = {'CC'};
% settings.groupName = [dynamicSet{:} '-' MLMSet{:}];

[ PCASet, dataRaw, dataClean ] = CreatePCA(dynamicSet, DOPSet, MLMSet, settings);