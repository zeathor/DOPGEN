function [ pos, DOPidx] = SCPF(DOP, pos, S, ~, ~, DOPidx)

%% This implements Step Change Peak/Function

DOP.stepChangePeakFunction(S);
DOP.stepChangeGradual(5);

end