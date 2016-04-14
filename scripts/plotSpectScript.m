function plotSpectScript()
dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\TimeSeries\';

% for i = 1:2:25
%     clear output;
%     fileName = 'DF1-TCD-'; 
%     output = load(strcat(dirName,fileName,num2str(i),'-SF.mat'));
%     plotChanSpectrum(output.dynamic, i, output.MLMStats.base);
% 
% end

probSet = {'cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell'}
% probSet = {'CGF'}%,'DF1','DF1','MPB'}
% dynSet = {'SCG'};
% dynSet = {'FP1','FP1','RSS1','RSS2','RSR1','RSR2','RSQR1','RSQR2','RSRG1','RSRG2','RSG1','RSG2'};
dynSet = {'FP2'}
dynSettings = setDynamicArrays(dynSet{:});



for i = 1:numel(dynSet)
    for j = 1:length(dynSettings(i).dynRange)
        fileName = ['TS-' probSet{i} '-' dynSet{i} '-' num2str(dynSettings(i).dynRange(1,j)) '-SF.mat'];
        output = load([dirName fileName]);
        plotChanSpectrogram(output.dynamic, dynSettings(i).dynRange(1,j), output.MLMStats.base,probSet{i});
    end
end
end

% for i = 1:2:25
%     fileName = 'DF1-TRCD-'; 
%     output = load(strcat(dirName,fileName,num2str(i),'-SF.mat'));
%     plotChanSpectrum(output.dynamic, i, output.MLMStats.base);
% 
% end
% 
% for i = 1:16
%     fileName = 'DF1-RCD-'; 
%     output = load(strcat(dirName,fileName,num2str(i),'-SF-Fixed-S.mat'));
%     plotChanSpectrum(output.dynamic, i, output.MLMStats.base);
% 
% end