function [ pos, DOPidx] = RSQR1(DOP, pos, S, ~, iter, DOPidx)
    
    %% Random Selection, Quasi Random
    % designed for the same input domain, also allows a different file to be
    % saved for easy figure analysis
    % we have a persistent weighting variable that is regularly reset.
    
    persistent W;
    
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
    
    
end