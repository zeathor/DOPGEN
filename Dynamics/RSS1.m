function [ pos, DOPidx] = RSS1(DOP, pos, S, ~, iter, ~)
    
    %% Random Selection, Scramble
    % designed for the same input domain, also allows a different file to be
    % saved for easy figure analysis
    % we have persistent selection set

    persistent W;
    
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
    
end   


