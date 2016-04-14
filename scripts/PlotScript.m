%% Saving graphs
resultName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\';

MLMSet = {'SF','SLHC','FEPC','FCSP','FCCT','CC'};
% MLMSet = {'SF'};
% MLMSet = {'SLHC'};
% MLMSet = {'FEPC'};
% MLMSet = {'FCSP'};
% MLMSet = {'FCCT'};
% MLMSet = {'CC'};


% dynSet = {'RCD','SCR','SCG','SCL','RGOM','LGOM','TRCD'};
% dynSet = {'TRCD'};
% dynSet = {'LGOM'};
% dynSet = {'FP2'};
% dynSet = {'RCDF','RCDFix'}
% dynSet = {'RSG1','RSG2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSR1','RSR2','FP1','FP2'};
% dynSet = {'TCD','RCD','RCDF','RCDFix','TRCD','LGOM','RGOM','CGOMEllip','CGOMCHM','SCG','SCL','SCR','SCA','SCPF'};
% dynSet = {'SCL','SCR','SCA','SCPF'};
% dynSet = {'SCPF'};
% dynSet = {'SCA'};
% dynSet = {'SCL'};
% dynSet = {'FP1'};
% dynSet = {'AM'};
% dynSet = {'CGOMCHM'}'
dynSet = {'CGOMEllip', 'CGOMCHM'};
% dynSet = {'RSRG1_S'}

% probSet = {'DF1','MPB','MPB','MPB','DF1','CGF','DF1','MPB','MPB','CGF','CF4','DF1','meh','CF4'};
% probSet = {'MPB','DF1','CGF','CF4','DF1', 'MPB', 'DF1'};
% probSet = {'RSG1','RSG2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSR1','RSR2'};
% probSet = {'cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell'};
% probSet = {'cell'};
% probSet = {'DF1'};
% probSet = {'CGF'};
% probSet = {'MPB','MPB'}
% probSet = {'who cares?'};

[dynSettings] = setDynamicArrays(dynSet{:});
for i = numel(dynSettings):-1:1
    if numel(dynSettings(1,i).DOP) > 1
        probSet{i} = 'cell';
    else
        probSet{i} = func2str(dynSettings(1,i).DOP);
    end
end

for j = 1:numel(dynSet)
    for i = 1:numel(MLMSet)
        switch dynSet{j}
            case 'SCA'
                tempName = [resultName, 'DF1-SCA-', MLMSet{i}];
                if exist([tempName '.mat'],'file')
                    StatsPlottingMod(resultName, probSet{j},MLMSet{i}, dynSet{j}, dynSettings(j).dynRange);
                else
                    disp(['File ' resultName,' does not exist']);
                end
            case 'AM'
                
                fileName = [resultName probSet{j} '-' dynSet{j} '-' MLMSet{i}];
                StatsPlottingAM(fileName,MLMSet{i});
                
            case {'CGOMEllip','CGOMCHM'}
                fileName = [resultName probSet{j} '-' dynSet{j}(1:4) '-' MLMSet{i} '-' dynSet{j}(5:end)];
                if(strcmp(dynSet{j},'CGOMEllip'))
                    tempDyn = dynSettings(j).dynRange(1,:);
                else
                    tempDyn = dynSettings(j).dynRange(2,:);
                end
                
                StatsPlottingMod(fileName, probSet{j},MLMSet{i}, dynSet{j}, tempDyn);
                
            otherwise
                fileName = [resultName probSet{j} '-' dynSet{j} '-' MLMSet{i}];
                disp([dynSet{j} ' ' probSet{j} ' ' MLMSet{i}]);
                if exist([fileName '.mat'],'file')
                    StatsPlottingMod(fileName, probSet{j},MLMSet{i}, dynSet{j}, dynSettings(j).dynRange);
                else
                    disp(['File ' fileName,' does not exist']);
                end
        end
    end
end
