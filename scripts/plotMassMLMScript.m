
resultPath = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\';
% clear dynRange;
% dynSet = {'TCD','RCDF','RCDFix','RCD','TRCD'};
% dynSet = {'RCDF','RCDFix','RCD'};
dynSet = {'AM'};
% dynSet = {'LGOM','RGOM'};
% dynSet = {'SCR','SCG','SCL'}
% dynSet = {'SCPF'};
% dynSet = {'SCL'};

% dynSet = {'RCD','SCR','SCG','SCL','RGOM','LGOM','TRCD'};
% dynSet = {'TRCD'};
% dynSet = {'LGOM'};
% dynSet = {'FP2'};
% dynSet = {'RCDF','RCDFix'}
% dynSet = {'RSG1','RSG2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSR1','RSR2','FP1','FP2'};

% dynSet = {'CGOMCHM'}'
% dynSet = {'CGOMEllip', 'CGOMCHM'};
% dynSet = {'RSRG1_S'}

% probSet = {'DS','DF1','MPB','CGF','CF4','cell'};
% probSet = {'DF1','MPB','CGF','CF4'};
probSet = {'CGF','CF4'};
% probSet = {'cell'};
% probSet = {'CF4'};

% MLMSet = {'SF','SLHC','FEPC','FCSP','FCCT','CC'};
MLMSet = {'FEPC','FCSP','FCCT','CC'};


dynRange = [];
% dynRange = 1:25;
% dynRange = 5:5:100;

%% we are going to loop through every(!) dynamic and underlying benchmark, generate the graphs and save the files
for i = 1:numel(dynSet)
    %% loop through the benchmarks
    for j = 1:numel(probSet)
        %% loop through the metrics
        for k = 1:numel(MLMSet)
            %% construct the file name/path, check if it exists and run statPlottingMod
            fileName = [probSet{j} '-' dynSet{i} '-' MLMSet{k} '.mat'];
            filePath = [resultPath fileName];
            if strcmp(dynSet{i},'AM')
                StatsPlottingAM(fileName(1:end-4),MLMSet{k},probSet{j})
            elseif(exist(filePath, 'file'))
                
                StatsPlottingAll(filePath, probSet{j},MLMSet{k}, dynSet{i},dynRange);
            end
        end
    end
end