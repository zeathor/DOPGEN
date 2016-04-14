function [ pos, DOPidx] = SCR_S(DOP, pos, S, ~, ~, DOPidx,~)

%% This implements Step Change Random

DOP.stepChangeRandom(S);

end