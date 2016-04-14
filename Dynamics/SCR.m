function [ pos, DOPidx] = SCR(DOP, pos, S, ~, ~, DOPidx)

%% This implements Step Change Random

DOP.stepChangeRandom(S);

end