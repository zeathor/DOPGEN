function RunDOPFreq(DOP, MLM, dynamic, dynRange, nPos, dirName, DOPLength)
%% This function runs the DOP, including dynamic driver and the specific MLM
% Returns MLMStats which contains all the MLM information for the specific
% MLM
clear MLMstats;

MLMfunc = str2func(MLM);
dynFun = str2func(dynamic);

for i = 1:length(dynRange)
        %% Generate samples, based on the first problem
    if (numel(DOP) > 1)
        domMax = DOP{1}.domain(2);
        domMin = DOP{1}.domain(1);
    else
        domMax = DOP.domain(2);
        domMin = DOP.domain(1);
    end
    
    pos = rand(nPos,2)*(domMax - domMin) + domMin;
    disp(strcat('dynRange = ',num2str(dynRange(i))));
    MLMStats = MLMfunc(DOP, pos, dynRange(:,i), 2, dynFun,DOPLength);
    MLMStats.changeBase = MLMStats.base(2:end,:)-MLMStats.base(1:(end-1),:);

    
    theFile = strcat(dirName, class(DOP), '-', dynamic, '-', num2str(dynRange(i)), '-', MLM, '.mat');
    save(theFile,'MLMStats','MLM', 'dynamic', 'i','DOP','pos');

    %% Reset the DOP. If need be, reset multiple (only DOPs that have been used), oh who cares
    if numel(DOP) == 1
        DOP.reset;
    else
        for k = 1:numel(DOP)
            DOP{k}.reset;
        end
        % shuffle them up
        DOP = shuffle(DOP);
    end
end
end
