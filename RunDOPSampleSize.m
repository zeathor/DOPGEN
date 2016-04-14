function [trackedMLM, otherMLM] = RunDOPSampleSize(theDOP, MLM, dynamic, dynRange,nIter,sampTech, nPoints)
    %% This function runs the DOP and varies the sample set size
    % before each DOP instance is run, the random seed is reset
    dim = 2;
    
    clear MLMstats;
    trackedMLM = zeros(length(dynRange),16,nIter);
    otherMLM = [];
    MLMfunc = str2func(MLM);
    dynFun = str2func(dynamic);
    sampFun = str2func(sampTech);
    
    %% Loop over each dynamic setting
    for dynIdx = 1:length(dynRange)
        % Create a new random number stream, specifically for the DOPs
        % all other random numbers (position set, metrics) can use the overall
        % randomstream, we really don't care about that. As long as the
        % problem stays the same.
        disp(strcat('dynRange = ',num2str(dynRange(:,dynIdx))));
        DOPStrm = RandStream('mt19937ar','Seed',0);
        if strcmp(dynamic,'RSRG1_S')
            for i = 50:-1:1
                DOP{1,i} = CGFS(DOPStrm,nPoints);
            end
        else
            switch MLM
                case 'CC_S'
                    DOP = theDOP(DOPStrm,nPoints*10);
                case 'SLHC_S'
                    DOP = theDOP(DOPStrm,nPoints*100);
                case 'FCSP_S'
                    DOP = theDOP(DOPStrm,nPoints*50);
                otherwise
                    DOP = theDOP(DOPStrm,nPoints);
            end
        end
        tic
        %% loop over the required iterations
        for iterIdx = 1:nIter
            disp(strcat('nIter = ',num2str(iterIdx), ', '));
            
            if numel(DOP) > 1
                domMin = DOP{1}.domain(1); domMax = DOP{1}.domain(2);
            else
                domMin = DOP.domain(1); domMax = DOP.domain(2);
            end
            % Create the position set according to pSize
            pos = sampFun(dim,domMin,domMax,nPoints);
            MLMStats = MLMfunc(DOP, pos, dynRange(:,dynIdx), 2, dynFun,250,DOPStrm);
            switch MLM
                case 'SLHC_S'
                    otherMLM.nExemp(dynIdx,:,iterIdx) = statsBox(MLMStats.nExemp);
                    otherMLM.optDist(dynIdx,:,iterIdx) = statsBox(MLMStats.optDist);
                    otherMLM.optDistDelta(dynIdx,:,iterIdx) = statsBox(MLMStats.optDist(:,2:end)- MLMStats.optDist(:,1:(end-1)));
                case 'FEPC_S'
                    otherMLM.closeIdx(dynIdx,:,iterIdx) = statsBox(MLMStats.closeIdx);
                    otherMLM.closeIdxList(dynIdx,:,iterIdx) = MLMStats.closeIdx;
                case 'FCSP_S'
                    otherMLM.range(dynIdx,:,iterIdx) = statsBox(MLMStats.range);
                case 'CC_S'
                    otherMLM.std(dynIdx,:,iterIdx) = statsBox(MLMStats.std);
                    otherMLM.range(dynIdx,:,iterIdx) = statsBox(MLMStats.range);
            end
            [temp ] = statsBox(MLMStats.base);
            trackedMLM(dynIdx,:,iterIdx) = temp;
            %% Reset the DOP
            if numel(DOP) > 1
                for k = 1:numel(DOP)
                    DOP{k}.reset;
                end
                % shuffle them up
                DOP = shuffle(DOP);
            else
                DOP.reset;
            end
        end
        toc
    end
end
