function [trackedMLM, otherMLM] = RunDOP(DOP, MLM, dynamic, dynRange, nPos,nIter,domType,dim)
    %% This function runs the DOP, including dynamic driver and the specific MLM
    % Returns MLMStats which contains all the MLM information for the specific
    % MLM
    
    dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\TimeSeries\';
    
    clear MLMstats;
    if nIter > 1
        trackedMLM = zeros(length(dynRange),16,nIter);
        %         trackedMLMDelta = zeros(length(dynRange),16,nIter);
        otherMLM = [];
    else
        trackedMLM = zeros(length(dynRange),16);
        %         trackedMLMDelta = zeros(length(dynRange),32);
        otherMLM = [];
    end
    MLMfunc = str2func(MLM);
    dynFun = str2func(dynamic);
    
    %% Generate samples, based on the first problem
    for i = 1:length(dynRange)
        disp(strcat('dynRange = ',num2str(dynRange(:,i))));
        iterTic = tic;
        for j = 1:nIter

            
            disp(strcat('nIter = ',num2str(j)));
            if (numel(DOP) > 1)
                domMax = DOP{1}.domain(2);
                domMin = DOP{1}.domain(1);
            else
                domMax = DOP.domain(2); 
                domMin = DOP.domain(1);
            end
            if isempty(dim)
                pos = rand(nPos,2)*(domMax - domMin) + domMin;
                dim = 2;
            else
                pos = rand(nPos,dim)*(domMax - domMin) + domMin;
            end
            if(strcmp(MLM,'SF') && (domType == 1))
                MLMStats = MLMfunc(DOP, pos, dynRange(:,i), dim, dynFun,1e5);
            elseif (domType == 2)
                MLMStats = MLMfunc(DOP, pos, dynRange(:,i), dim, dynFun,25);
            else
                MLMStats = MLMfunc(DOP, pos, dynRange(:,i), dim, dynFun,250);
            end
            
            %             MLMStats.changeBase = MLMStats.base(2:end,:)-MLMStats.base(1:(end-1),:);
            switch MLM
                case 'SLHC'
                    otherMLM.nExemp(i,:,j) = statsBox(MLMStats.nExemp);
                    otherMLM.optDist(i,:,j) = statsBox(MLMStats.optDist);
                    otherMLM.optDistDelta(i,:,j) = statsBox(MLMStats.optDist(:,2:end)- MLMStats.optDist(:,1:(end-1)));
                case 'FEPC'
                    otherMLM.closeIdx(i,:,j) = statsBox(MLMStats.closeIdx);
                    otherMLM.closeIdxList(i,:,j) = MLMStats.closeIdx;
                case 'FCSP'
                    otherMLM.range(i,:,j) = statsBox(MLMStats.range);
                case 'CC'
                    otherMLM.std(i,:,j) = statsBox(MLMStats.std);
                    otherMLM.range(i,:,j) = statsBox(MLMStats.range);
                case 'SF'
                    if ((j == 1) && (domType == 1))
                        theFile = [dirName, 'TS-', class(DOP), '-', dynamic, '-'];
                        if size(dynRange,1) > 1
                            theFile = [theFile, num2str(dynRange(1,i)), '-', num2str(dynRange(2,i))];
                        else
                            theFile = [theFile, num2str(dynRange(i))];
                        end
                        theFile = [theFile, '-', MLM, '.mat'];
                        save(theFile,'MLMStats','MLM', 'dynamic', 'i','DOP','pos','dynRange');
                    end
            end
            
            [temp ] = statsBox(MLMStats.base);
            trackedMLM(i,:,j) = temp;
            
            
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
        toc(iterTic)
    end
    
end
