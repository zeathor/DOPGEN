function [ pos, DOPidx] = FP2(DOP, pos, S, ~, ~, DOPidx)

%% This implements Fixed Period problem, different underlying Fitness functions
oldMin = DOP{DOPidx}.domain(1);
oldMax = DOP{DOPidx}.domain(2);
newPos = pos;
DOPidx = DOPidx+1;
if(DOPidx > S)
   DOPidx = 1; 
end

newMin = DOP{DOPidx}.domain(1);
newMax = DOP{DOPidx}.domain(2);

%% Have to alter the position set to be scaled in the same range as the current problem
if(newMax ~= oldMax) && (newMin ~= oldMin)
    newPos = (pos-oldMin) .* ((newMax-newMin)/(oldMax - oldMin)) + newMin;
end

pos = newPos;

end
