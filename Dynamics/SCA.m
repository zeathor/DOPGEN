function [ pos, DOPidx] = SCA(DOP, pos, ~, ~, ~, DOPidx)

%% This implements Step Change Abrupt. Very simple, reset the function entirely

DOP.reset;

end