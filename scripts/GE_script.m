%% this script runs the DOP and generates the GE

dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\TimeSeries\';
dynRange = 1:2:25;
% dynType = {'SCR','SCG'};
% DOPType = {'DF1','CGF'};
dynType = {'SCG'};
DOPType = {'CGF'};
MLM = 'SF';

for i = 1:numel(dynType)
    for j = 1:length(dynRange)
        DOP = str2func(DOPType{i});
        %% Run the DOP
        theDOP = DOP();
        RunDOPFreq(theDOP, MLM, dynType{i}, dynRange(j), 100, dirName,5e4);
        
        %% Run GE
        signalName = [DOPType{i} '-' dynType{i} '-' num2str(dynRange(j)) '-' MLM '.mat'];
        output = load([dirName signalName]);
        disp(['Running ' output.dynamic ', setting ' num2str(dynRange(j))]);
        data = GlobalEfficiency(output.MLMStats.base);
        resultName = ['GE-' DOPType{i} '-' dynType{i} '-' num2str(dynRange(j)) '-SF.mat'];
        save([dirName resultName],'data');
        clear output data DOP theDOP;
    end
end



