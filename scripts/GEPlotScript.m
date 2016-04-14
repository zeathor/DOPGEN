%% this script grabs GE data from the file system, plots the GE efficiency on the graph


dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\';

% dynRange = {1:25,1:16,1:25};
% dynType = {'TCD','RCD','TRCD'};

% dynRange = 1:20;
% dynType = 'TCD';

% dynRange = [1 5 10 15 20 25];
% dynType = 'TRCD';

dynRange = [1:14 16];
dynType = 'RCD';
% 
% dynRange = 1:2:25;  
% dynType = 'SCR';

figure;
hold on;
cmap = paruly(length(dynRange));
ylim([0 1]);

for j = 1:length(dynRange)
    resultName = ['GE-DF1-' dynType '-' num2str(dynRange(j)) '-SF.mat'];
    output = load([dirName resultName]);
    plot(movingmean(output.data.E_W,30,2,[]),'-','color',cmap(j,:));
%     plot(movingmean(output.data.e_str,11,2,[]),':','color',cmap(j,:));
%     plot(movingmean(output.data.e_top,11,2,[]),'-.','color',cmap(j,:));
    clear output;
end