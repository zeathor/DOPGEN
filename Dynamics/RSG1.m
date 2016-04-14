function [ pos, DOPidx] = RSG1(~, pos, S, ~, ~, DOPidx)
    
    %% Random Selection, Gaussian
    % designed for the same input domain, also allows a different file to be
    % saved for easy figure analysis
    % we have persistent selection set
    % two variables, DOP elements M, severity S_g
    
    M = S(1);
    Sg = S(2);
    

    newIdx = randn*Sg;
    
    if newIdx > 0
       newIdx = mod(floor(newIdx) + 1 + DOPidx,M);
    else
        newIdx = mod(ceil(newIdx) - 1 + DOPidx,M);
    end

    if(newIdx ==0)
        newIdx = M; 
    end
    DOPidx = newIdx;
    
end   


