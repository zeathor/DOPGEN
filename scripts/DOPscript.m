%% This script runs the DOP, including dynamic driver and the specific MLM
clear DOP;
filename = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\Temporary\';

%% Normal run?
spec = 0;
%% Are we doing the spectrogram fitnesses?
% spec = 1;
%% stationary problem?
% spec = 2;

%% How many dimensions?
dim = 2;
% dim = 10;

%% SELECT NUMBER OF SAMPLING POINTS
% nPos = 500;
% nPos = 100;
% nPos = 500;
nPos = 1000;
% nPos = 5000;

%% NUMBER OF ITERATIONS
% nIter = 1;
% nIter = 5;
% nIter = 10;
% nIter = 15;
nIter = 20;
% nIter = 25;
% nIter = 50;
% nIter =100;

%% SELECT THE MID LEVEL METRIC
% MLM = 'SF';
% MLM = 'SLHC';
% MLM = 'FCCT';
MLM = 'FEPC';
% MLM = 'FCSP';
% MLM = 'CC';

%% SELECT THE PARTICULAR DYNAMIC
% dynamic = 'TCD'
% dynamic = 'RCD'
% dynamic = 'RCDF'
% dynamic = 'TRCD'
% dynamic = 'LGOM'
% dynamic = 'RGOM'
% dynamic = 'FP1'
% dynamic = 'FP2'
% dynamic = 'RSR1'
% dynamic = 'RSR2'
% dynamic = 'RSRG1'
% dynamic = 'RSRG2'
% dynamic = 'RSQR1'
% dynamic = 'RSQR2'
% dynamic = 'RSS1'
% dynamic = 'RSS2'
% dynamic = 'RSG1'
% dynamic = 'RSG2'
dynamic = 'AM'
% dynamic = 'SCG'
% dynamic = 'SCR'
% dynamic = 'SCL'
% dynamic = 'SCA';
% dynamic = 'SCPF'
% dynamic = 'CGOM'
% dynamic = 'SOP' % Stationary Optimisation Problem

%% SELECT THE DYNAMIC RANGE
% dynRange = 1:25;                %TCD, RGOM, LGOM, SCR, SCG, TRCD
% dynRange = 25;
% dynRange = pi/16:pi/16:pi;      %RCD, RCDF, RCDFix
% dynRange = [5:5:50; 1:0.5:5.5];       % RSG      
% dynRange = [10:5:50;2:1:10];         % RSRG
% dynRange = 6:4:50;                  % RSQR, RSS
% dynRange = 5:5:50;                  % RSR, FP
% dynRange = 5:5:100;                   % SCPF
dynRange = 0.5:0.5:5;            % AM
% dynRange = 1;                   % SCA/SDOP
% dynRange = 0.001;                   % SCR SMALL
% dynRange = 0.5:0.5:10;              % SCL
% dynRange = [0.5 2.5 5 7.5 10];
% dynRange = [0.5:0.5:4.5; zeros(1,length(0.5:0.5:4.5))]; % CGOM Elliptical
% dynRange = [zeros(1,length([4 5 8 10 12 15 16 20 24])); [4 5 8 10 12 15 16 20 24]]; % CGOM Harmonic
% dynRange = [1 5 10 15 20 25];       % SC for Spectrograms
% dynRange = [pi/16, pi/8, pi/4, pi/2, pi]; %RC for spectrograms

%% Dynamic List
% DynList = {'TCD','RCD','RCDF','RCDFix','TRCD','LGOM','RGOM','SCG','SCL','SCR','FP1','FP2','RSR1','RSR2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSG1','RSG2'};
% DynList = {'SCR','SCG'};
% DynList = {'FP1','FP2','RSR1','RSR2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSG1','RSG2'}
% DynList = {'RSG1','RSG2'};
% DynList = {'FP1','FP2'};
% DynList = {'FP2'};
% DynList = {'TRCD'};
% DynList = {'RCDFix'}
% DynList = {'SCG'};
% DynList = {'SCL'};
% DynList = {'LGOM'};
% DynList = {'RGOM'};
% DynList = {'RSRG1'};
% DynList = {'RSS1'};
% DynList = {'TCD','TRCD'};
% DynList = {'RCDF','RCDFix', 'RCD'};
% DynList = {'SCR'};
% DynList = {'SCPF'};

%% SELECT THE DOP
% DOP = DS(dim,nPos);
% DOP = DF1(20, 1, 19, 8, 12, 2, nPos*nPoints);
% DOP = DF1(20, 1, 19, 40, 60, 2, nPos*nPoints); %% USE THIS ONE
% DOP = MPB(50, 30, 40, 1, 11, 2, nPos*nPoints);
% DOP = CGF(10, 10, 90, [], [], 2, nPoints*nPos);
% DOP = CF4(0, 100, 2,nPoints*nPos);
% DOP = DF1();
% DOP = CF4();
% DOP = CGF();
% DOP = MPB();
% DOP = DS(dim,5000*100);
% DOP = DF1(nPos);
% DOP = MPB(nPos);
% DOP = CGF(nPos);
% DOP = CF4(nPos);
%% only for Alternating Modality
% DOP = DF1(20, 1, 19, 40, 60, 2, nPos*nPoints, i);\
% DOP = MPB(nPos,2);
% DOPList = {'DF1','MPB','CGF','CF4'};
% DOPList = {'DF1'};
% DOPList = {'MPB'};
% DOPList = {'CGF'};
% DOPList = {'CF4'};
% DOPList = {'MPB','CGF','CF4'};


%% CYCLICAL DOPS, F1
% for i = 50:-1:1
%     DOP{1,i} = CGF(500);
% end

% for i = 50:-1:1
%     DOP{1,i} = MPB(500);
% end

% CYCLICAL DOPS, F2
% randDOP = randi(4,1,50);
% for i = 50:-1:1
%     switch randDOP(i)
%         case 1
%             DOP{1,i} = MPB();
%         case 2
%             DOP{1,i} = DF1();
%         case 3
%             DOP{1,i} = CGF();
%         case 4
%             DOP{1,i} = CF4();
%     end
% end

%% Individual DOP/METRIC/DYNAMIC RUN
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');

%% FULL DOP/DYNAMIC RUN
% MLM = 'SF';
% nPos = 1000;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% nPos = 1000;
% MLM = 'FCCT'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% nPos = 1000;
% MLM = 'FEPC'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'FCSP'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'CC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'SLHC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');

%% FULL DYNAMIC LIST RUN
% dynSettings = setDynamicArrays(DynList{:});
% for i = 1:numel(dynSettings)
%     if numel(dynSettings(1,i).DOP) > 1
%         for j = numel(dynSettings(1,i).DOP):-1:1
%             DOP{j} = dynSettings(1,i).DOP{j}();
%         end
%     else
%         DOP = dynSettings(1,i).DOP();
%     end
%     dynRange = dynSettings(1,i).dynRange;
%     dynamic = DynList{i}
%     MLM = 'SF';
%     nPos = 100;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'TS.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     nPos = 5000;
%     MLM = 'FCCT'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FEPC'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FCSP'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'CC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'SLHC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     clear DOP;
% end

%% DOP LIST RUN
% for i = 1:numel(DOPList)
%     theDOP = str2func(DOPList{i});
%     DOP = theDOP();
%     MLM = 'SF';
%     nPos = 10000;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     nPos = 10000;
%     MLM = 'FCCT'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FEPC'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FCSP'
%     nPos = 5000;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'CC'
%     nPos = 5000;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'SLHC'
%     nPos = 5000;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '1.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     clear DOP;
% end

%% DYNAMIC LIST RUN
% for i = 1:numel(DynList)
%     dynamic = (DynList{i})
%     MLM = 'SF';
%     nPos = 100;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     nPos = 1000;
%     MLM = 'FCCT'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FEPC'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FCSP'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'CC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'SLHC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% end

%% UNIQUE FILENAME RUNS - CGOM ELLIPTICAL AND CGOM CHM 
% ELLIPTICAL
% dynRange = [0.5:0.5:4.5; zeros(1,length(0.5:0.5:4.5))]; 
% MLM = 'SF';
% nPos = 1000;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip','.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% nPos = 1000;
% MLM = 'FCCT'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'FEPC'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'FCSP'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'CC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'SLHC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-Ellip', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');

% CHM
% dynRange = [zeros(1,length([4 5 8 10 12 15 16 20 24])); [4 5 8 10 12 15 16 20 24]];
% MLM = 'SF';
% nPos = 5000;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM','.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% nPos = 1000;
% MLM = 'FCCT'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'FEPC'
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'FCSP'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'CC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
% MLM = 'SLHC'
% nPos = 500;
% [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
% save(strcat(filename, class(DOP), '-', dynamic, '-', MLM, '-CHM', '.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');

%% Alternating Modality runs
for i = 2:6
%     DOP = MPB([],i);
    DOP = CGF([],i);
    
%     MLM = 'SF';
%     nPos = 1000;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     nPos = 1000;
%     MLM = 'FCCT'
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
    nPos = 50000;
    MLM = 'FEPC'
    [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
    save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'FCSP'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'CC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
%     MLM = 'SLHC'
%     nPos = 500;
%     [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos, nIter, spec, dim);
%     save(strcat(filename, class(DOP), '-', dynamic, '-', MLM,'-',num2str(i),'.mat'),'trackedMLM', 'otherMLM', 'MLM', 'dynRange', 'dynamic');
    clear DOP;
end






