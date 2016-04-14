function plotMassSpecScript()
dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\TimeSeries\';


probSet = {'DF1','DS','MPB','CGF','CF4','cell'};
% dynSet = {'SCG','SCL','SCR'};   
% dynSet = {'RCDR','RCDF','RCDS'};
dynSet = {'FP1','FP2','RSRG1','RSRG2'}

close all;

for i = 1:numel(probSet)
    for j = 1:numel(dynSet)
        dynSettings = setDynamicArrays(dynSet{j});
        for k = 1:length(dynSettings.dynRange)
            fileName = ['TS-' probSet{i} '-' dynSet{j} '-' num2str(dynSettings.dynRange(1,k)) '-SF.mat'];
            if(exist([dirName fileName],'file'))
                output = load([dirName fileName]);
                plotChanSpectrogram(output.dynamic, dynSettings.dynRange(1,k), output.MLMStats.base,probSet{i});
                clear output;
            end
        end      
    end
end
    
    