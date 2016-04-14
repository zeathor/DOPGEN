function [ pos, DOPidx] = CGOM(DOP, pos, S, ~, ~,DOPidx)

%% This implements Linear Global Optimum Movement

DOP.circularGOM(S);

end
