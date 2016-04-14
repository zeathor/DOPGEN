function [MLM] = FEPC(DOP, pos, dynSettings, dim, dynamic,DOPLength)
    %% This is the MLM for Fitness Error of Previous Cycles
    DOPidx = 1;
    basic = zeros(250,length(pos));
    runningMean = zeros(1,250);
    runningStd = zeros(1,250);
    count = 0;
    classDOP = class(DOP);
    for i = 1:DOPLength 
        if(numel(DOP) > 1)
            basic(i,:) = DOP{DOPidx}.calc(pos);
        else
            basic(i,:) = DOP.calc(pos);
        end
        
        runningMean(i) = mean(basic(i,:));
        runningStd(i) = std(basic(i,:));
        
        % note we can only do this after at least one generated landscape
        if(i > 1)

            fprintf(1, repmat('\b',1,count)); %delete line before
            count = fprintf('%s: FEPC iter %3.2f%%',classDOP,i/DOPLength*100);

            %% Rank by MEAN, determine closest
            [~,idx] = sort(floor(runningMean(1:i)*10));
            [~,curIdx] = max(idx);
            
            % get the surrounding vectors
            
            
            % do we have enough elements to even get 4?
            if(size(idx,2) < 6)
                surIdx = idx;
            elseif(curIdx < 4)
                % are we at the start of the array?
                % just get the first 5 elements
                surIdx = idx(1,1:5);
                % are we at the end of the array?
            elseif(curIdx > (size(idx,2)-3))
                % just get the last 5 elements
                surIdx = idx(1,(end-4:end));
            else
                surIdx = idx(1,curIdx-2:curIdx+2);
            end
            % get the current index again from the subset
            [~,curIdx] = max(surIdx);
            % remove this column from the matrix
            surIdx(curIdx) = [];
            tempBasic = basic(i,:);
            refFit = tempBasic(ones(1,size(surIdx,2)),:);
            
            
            %% GENERATE THE MEAN ERROR
            % note that we only grab the first 100 points, assuming points are randomly generated
            % this will need to be changed for non-random/sorted points
            if(size(idx,2) > 1)
                compFit = basic(surIdx,:);               
                errMean = floor(sum(abs(compFit-refFit),2));
                %% do a quick rounding
                [minMeanErr, ~] = min(errMean);
                minMeanIdx = i - surIdx(find(errMean == minMeanErr,1,'last'));
            end
            
            %% Rank by STD, determine closest
            [~,idx] = sort(floor(runningStd(1:i)*10));
            [~,curIdx] = max(idx);
            
            % get the surrounding vectors
            
            % do we have enough elements to even get 4?
            if(size(idx,2) < 6)
                surIdx = idx;
            elseif(curIdx < 4)
                % are we at the start of the array?
                % just get the first 5 elements
                surIdx = idx(1,1:5);
                % are we at the end of the array?
            elseif(curIdx > (size(idx,2)-3))
                % just get the last 5 elements
                surIdx = idx(1,(end-4:end));
            else
                surIdx = idx(1,curIdx-2:curIdx+2);
            end
            % get the current index again from the subset
            [~,curIdx] = max(surIdx);
            % remove this column from the matrix
            surIdx(curIdx) = [];
            
            %% GENERATE THE STD ERROR
            % note that we only grab the first 100 points, assuming points are randomly generated
            % this will need to be changed for non-random/sorted points
            if(size(idx,2) > 1)
                compFit = basic(surIdx,:);
                
                errStd = floor(sum(abs(compFit-refFit),2));
                [minStdErr, ~] = min(errStd);
                minStdIdx = i - surIdx(find(errStd == minStdErr,1,'last'));
            end
                
            %% goddamn I am sick of this, just check the most recent 4 as well
            if i <= 5
                compFit = basic(1:(i-1),:);
            else
                compFit = basic((i-4):(i-1),:);
            end
            
            errClosest = floor(sum(abs(compFit-refFit),2));
            [minClosestErr, ~] = min(errClosest);
            minClosestIdx = find(errClosest == minClosestErr,1,'last');
            minClosestIdx = (length(errClosest)+1-minClosestIdx);
            
            
            
            if(minMeanErr <= minStdErr)
                MLM.base(i-1) = minMeanErr;
                MLM.closeIdx(i-1) = minMeanIdx;
            else
                MLM.base(i-1) = minStdErr;
                MLM.closeIdx(i-1) = minStdIdx;
            end
                      
            if(MLM.closeIdx(i-1) ~= 1) && (minClosestErr < MLM.base(i-1))
                MLM.closeIdx(i-1) = minClosestIdx;
                MLM.base(i-1) = minClosestErr;
            end
                               
        end;
           
        %% sometimes you need to modify the position matrix
        [pos, DOPidx] = dynamic(DOP, pos, dynSettings, dim,i, DOPidx);
    end
    fprintf('');
    MLM.base= MLM.base./length(pos);
%     max(MLM.closeIdx)
end