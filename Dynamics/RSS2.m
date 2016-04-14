function [ pos, DOPidx] = RSS2(DOP, pos, S, ~, iter, DOPidx)
    
    %% Random Selection, Scramble
    % designed for different input domain, also allows a different file to be
    % saved for easy figure analysis
    % we have persistent selection set

    persistent W;
    
    oldMin = DOP{DOPidx}.domain(1);
    oldMax = DOP{DOPidx}.domain(2);
    
    
    if isempty(W) || (iter == 1)
        W = ones(1,numel(DOP));
    end
    
    newIdx = rand*sum(W(1:S));
    
    dummyIdx = 1;
    dummy = 0;
    while(dummyIdx <= S)
        dummy = dummy + W(dummyIdx);
        if(dummy > newIdx)
            W(dummyIdx) = 0;
            break
        else
            dummyIdx = dummyIdx + 1;
        end
    end
    
    %% have we selected all of them now?
    if(sum(W(1:S)) == 0)
       W(1:S) = ones(1,S);
    end
    
    DOPidx = dummyIdx;
    
    newMin = DOP{DOPidx}.domain(1);
    newMax = DOP{DOPidx}.domain(2);
    
    %% Have to alter the position set to be scaled in the same range as the current problem
    if(newMin ~= oldMin) || (newMax ~= oldMax)
        pos = (pos-oldMin) .* (newMax-newMin)/(oldMax - oldMin) + newMin;
    end
    
end   
