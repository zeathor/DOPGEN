function [ pos, DOPidx] = FP1(~, pos, S, ~, ~, DOPidx)

%% This implements Fixed Period problem, all the same underlying fitness function

DOPidx = DOPidx+1;
if(DOPidx > S)
   DOPidx = 1; 
end

end
