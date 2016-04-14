function [ pos, DOPidx] = RSRG2(DOP, pos, S, ~, ~, DOPidx)
    
    %% This implements Random Selection (Random), different underlying Fitness functions
    oldMin = DOP{DOPidx}.domain(1);
    oldMax = DOP{DOPidx}.domain(2);
    
    M = S(1);
    B = S(2);
    %% first check if the DOPidx is within a group (not divisible by B)
    if (mod(DOPidx,B))
        % just increment the index, shift to the next element in the group
        DOPidx = DOPidx + 1;
    else
        %% Generate a new index, making sure it is at the start of an old one
        newIdx = (randi(M/B)-1)*B+1;
        while newIdx == DOPidx
            newIdx = (randi(M/B)-1)*B+1;
        end
        DOPidx = newIdx;
    end
    
    
    newMin = DOP{DOPidx}.domain(1);
    newMax = DOP{DOPidx}.domain(2);
    
    %% Have to alter the position set to be scaled in the same range as the current problem
    if(newMin ~= oldMin) || (newMax ~= oldMax)
        pos = (pos-oldMin) .* (newMax-newMin)/(oldMax - oldMin) + newMin;
    end
end