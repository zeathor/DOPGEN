function [ pos, DOPidx] = RSQR2(DOP, pos, S, ~, iter, DOPidx)
    
    %% Random Selection, Quasi Random
    % designed for the same input domain, also allows a different file to be
    % saved for easy figure analysis
    % we have a persistent weighting variable that is regularly reset.
    persistent W;
    
    oldMin = DOP{DOPidx}.domain(1);
    oldMax = DOP{DOPidx}.domain(2);
    
    
    if isempty(W) || (iter == 1)
        W = ones(1,numel(DOP));
    end
    
    
    
    newIdx = DOPidx;

    while newIdx == DOPidx
        dummyIdx = 1;
        dummy = 0;
        newIdxProb = rand*sum(W(1:S));
        while(dummyIdx <= S)
            dummy = dummy + W(dummyIdx);
            if(dummy > newIdxProb)
                newIdx = dummyIdx;
                break
            else
                dummyIdx = dummyIdx + 1;
            end
        end
    end
    
    
    W(dummyIdx) = W(dummyIdx)/2;
    
    if(mod(iter,(S*5)) == 0)
        W(1:S) = W(1:S).*(2^5);
    end
    
    
    DOPidx = dummyIdx;
    
    
    newMin = DOP{DOPidx}.domain(1);
    newMax = DOP{DOPidx}.domain(2);
    
    %% Have to alter the position set to be scaled in the same range as the current problem
    if(newMin ~= oldMin) || (newMax ~= oldMax)
        pos = (pos-oldMin) .* (newMax-newMin)/(oldMax - oldMin) + newMin;
    end
    
    
end