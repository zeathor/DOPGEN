%% This script runs the DOP, including dynamic driver and the specific MLM
clear DOP;
filename = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\';

% nPoints = 1;
nPoints = 50;

% nPos = 500;
nPos = 1000;
% nPos = 10000;

% nIter = 1;
% nIter = 25;
% nIter = 5;
% nIter = 20;
% nIter = 25;

%% SELECT THE MID LEVEL METRIC
% MLM = 'SF';
% MLM = 'SLHC';
% MLM = 'FCCT';
% MLM = 'FEPC';
% MLM = 'FCSP';
% MLM = 'CC';

%% SELECT THE PARTICULAR DYNAMIC
% dynamic = 'FP1';
% dynamic = 'FP2';
% dynamic = 'RSR1';
% dynamic = 'RSR2'; %% done
% dynamic = 'RSRG1';
% dynamic = 'RSRG2';
% dynamic = 'RSQR1';
% dynamic = 'RSQR2';
% dynamic = 'RSS1';
% dynamic = 'RSS2';


%% SELECT THE DYNAMIC RANGE
% dynRange = 5:5:50;              % All cyclical problems FP, RSR, RSRG 
dynRange = zeros(2,10);         % Random groups and Gaussian random
dynRange(1,:) = 5:5:50; 
dynRange(2,:) = 0.5:0.5:5;

%% cyclical problems
for i = 1:max(dynRange,[],2)  
    DOP{i} = MPB(50, 30, 40, 1, 11, 2, nPos*nPoints);
end
% 
% 
% dynamic = 'RSRG1';
% dynRange = zeros(2,9);
% dynRange(1,:) = 10:5:50; 
% dynRange(2,:) = 2:1:10;
% nIter = 100;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc
% 
% dynRange = 5:5:50; 
% dynamic = 'RSQR1';
% nIter = 100;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc
% 
% dynamic = 'RSS1';
% nIter = 100;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc

dynamic = 'RSG1';
nIter = 100;
tic
MLM = 'FEPC'
[trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
toc


dynRange = zeros(2,10);
dynRange(1,:) = 5:5:50; 
dynRange(2,:) = 0.5:0.5:5;
% FP2 mix
clear DOP
for i = 1:max(dynRange,[],2)
    newDOP = randi(4);
    switch(newDOP)
        case 1
            DOP{i} = DS(2,nPos*nPoints);
        case 2
            DOP{i} = DF1(20, 1, 19, 8, 12, 2, nPos*nPoints);
        case 3
            DOP{i} = MPB(50, 30, 40, 1, 11, 2, nPos*nPoints);
        case 4
            DOP{i} = CGF(10,10,100,[],[],2,nPoints*nPos);
    end
end

% 
% dynamic = 'RSRG2';
% nIter = 50;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc
% 
% dynamic = 'RSQR2';
% nIter = 50;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc
% 
% dynamic = 'RSS2';
% nIter = 50;
% tic
% MLM = 'FEPC'
% [trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
% save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% toc


dynamic = 'RSG2';
nIter = 50;
tic
MLM = 'FEPC'
[trackedMLM,trackedMLMDelta, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter); 
save(strcat(filename, dynamic, '-', dynamic, '-', MLM,'.mat'),'trackedMLM','trackedMLMDelta', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
toc

