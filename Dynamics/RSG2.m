function [ pos, DOPidx] = RSG2(DOP, pos, S, ~, ~, DOPidx)
    
    %% Random Selection, Gaussian
    % designed for different input domain, also allows a different file to be
    % saved for easy figure analysis
    
    oldMin = DOP{DOPidx}.domain(1);
    oldMax = DOP{DOPidx}.domain(2);
    
    
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
    
    
    newMin = DOP{DOPidx}.domain(1);
    newMax = DOP{DOPidx}.domain(2);
    
    %% Have to alter the position set to be scaled in the same range as the current problem
    if(newMin ~= oldMin) || (newMax ~= oldMax)
        pos = (pos-oldMin) .* (newMax-newMin)/(oldMax - oldMin) + newMin;
    end
    
end   
