function [ pos, DOPidx] = RSRG1_S(~, pos, S, ~, ~, DOPidx,DOPStrm)
    
    %% Random Selection, Random Groups
    % designed for the same input domain, also allows a different file to be
    % saved for easy figure analysis
    
    % S is a vector for RSRG (one of the few with a vector), S(1) = M, S(2) = B
    % within the functions we have B groups. Always set to M/5 because I am
    % lazy
    % If DOPidx is within a group, transition to the next one. Otherwise,
    % select the start of a new group
    % assume that S corresponds to M not B
    
    M = S(1);
    B = S(2);
    %% first check if the DOPidx is within a group (not divisible by B)
    if (mod(DOPidx,B))
        % just increment the index, shift to the next element in the group
        DOPidx = DOPidx + 1;
    else
        %% Generate a new index, making sure it is at the start of an old one
        newIdx = (randi(DOPStrm,M/B)-1)*B+1;
        while newIdx == DOPidx
            newIdx = (randi(DOPStrm,M/B)-1)*B+1;
        end
        DOPidx = newIdx;
    end
    
    
end