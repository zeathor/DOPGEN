function [ pos, DOPidx] = SCL(DOP, pos, S, ~, ~, DOPidx)

%% This implements Step Change Large. 

DOP.stepChangeLarge(S);

end