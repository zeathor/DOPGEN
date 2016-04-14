function [ pos, DOPidx] = SCG(DOP, pos, S, ~, ~, DOPidx)

%% This implements Linear Global Optimum Movement

DOP.stepChangeGradual(S);

end