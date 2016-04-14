function [ pos, DOPidx] = RSR2(DOP, pos, S, ~, ~, DOPidx)

%% This implements Random Selection (Random), different underlying Fitness functions
oldMin = DOP{DOPidx}.domain(1);
oldMax = DOP{DOPidx}.domain(2);

newIdx = randi(S);
while newIdx == DOPidx
    newIdx = randi(S);
end

DOPidx = newIdx;


newMin = DOP{DOPidx}.domain(1);
newMax = DOP{DOPidx}.domain(2);

%% Have to alter the position set to be scaled in the same range as the current problem
pos = (pos-oldMin) .* (newMax-newMin)/(oldMax - oldMin) + newMin;

end