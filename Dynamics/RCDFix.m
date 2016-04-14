function [ pos, DOPidx] = RCDFix(DOP, pos, S, dim, iter, DOPidx)

%% This implements the Positional Change Metric - RANDOM
%
persistent rotatedPos domCentre;

if (iter == 1) || (isempty(rotatedPos))
    rotatedPos = pos;
    domCentre =(DOP.domain(2) - (DOP.domain(2) - DOP.domain(1))/2);
end

%% currently this only works for 2 dimensions, but fuckit
%% execute the dynamic
for i  = 1:(dim-1)
    theta = S;
    rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    pos(:,i:i+1) = (pos(:,i:i+1) - domCentre)*rotMat+domCentre;
end


end