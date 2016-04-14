%% This script runs the DOP, including dynamic driver and the specific MLM
clear DOP;
filename = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\SampleSize\';

%% NUMBER OF ITERATIONS
% nIter = 1;
% nIter = 5;
% nIter = 10;
% nIter = 15;
nIter = 5;
% nIter = 10;
% nIter = 50;

%% Dynamic List
% DynList = {'RCDF_S','TRCD_S','SCR_S'};
% DynList = {'SCR_S'};
DynList = {'RCDF_S'};
% DynList = {'TRCD_S'};
% DynList = {'RSRG1_S'};

%% Sampling Technique List
SampList = {'RSHS','URS','EDS','JGS'};
% SampList = {'EDS','JGS'};
% SampList = {'URS','EDS','JGS'};
% SampList = {'RSHS'};
% SampList = {'URS'};
% SampList = {'EDS'};
% SampList = {'JGS'};


%% Point size
% pSize = [50,100,200,500,1000,2000,5000,1e4,2e4,5e4,1e5,2e5,5e5,1e6];
% pSize = [50,100,200,500,1000, 2000];
% pSize = [1e4,2e4,5e4,1e5];
% pSize = [50,1000, 10000];
pSize = 1e5;
%% FULL DYNAMIC LIST RUN
dynSettings = setDynamicArrays(DynList{:});
for i = 1:numel(dynSettings)
    for j = 1:numel(SampList)
        for k = 1:length(pSize)
            nPoints = pSize(k)
            dynRange = dynSettings(1,i).dynRange;
            dynamic = DynList{i}
            sampTech = SampList{j}
            DOP = dynSettings(1,i).DOP;
          
%             MLM = 'SF_S';
%             [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints);
%             save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
%             MLM = 'FCCT_S'
%             [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints);
%             save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
%             MLM = 'FEPC_S'
%             [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints);
%             save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
%             MLM = 'FCSP_S'
%             [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints);
%             save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
%             MLM = 'CC_S'
%             [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints);
%             save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
            MLM = 'SLHC_S'
            [trackedMLM, otherMLM] = RunDOPSampleSize(DOP, MLM, dynamic, dynRange,nIter,sampTech,nPoints/100);
            save([filename, func2str(DOP), '-', dynamic, '-', MLM, '-', sampTech, '-', num2str(nPoints),'.mat'],'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic','sampTech','nPoints');
        end
    end
end








