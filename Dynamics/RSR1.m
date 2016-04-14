function [ pos, DOPidx] = RSR1(~, pos, S, ~, ~, DOPidx)

%% Random Selection, Random
% designed for the same input domain, also allows a different file to be
% saved

newIdx = randi(S);
while newIdx == DOPidx
    newIdx = randi(S);
end

DOPidx = newIdx;

end