function [ pos, DOPidx] = LGOM(DOP, pos, S, ~, ~, DOPidx)

%% This implements Linear Global Optimum Movement

DOP.linearGOM(S);

end

