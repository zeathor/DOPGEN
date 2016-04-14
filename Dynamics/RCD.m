function [ pos, DOPidx] = RCD(DOP, pos, S, dim, iter, DOPidx)

%% This implements the Positional Change Metric - RANDOM
%
persistent rotatedPos domCentre;

if (iter == 1) || (isempty(rotatedPos))
    rotatedPos = pos;
    domCentre =(DOP.domain(2) - (DOP.domain(2) - DOP.domain(1))/2);
end

%% execute the dynamic
%% Ahaha, this is hilariously bad, go through each dimension and rotate the points

for i  = 1:(dim-1)
    theta = S * (rand*2-1);
    rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    pos(:,i:i+1) = (pos(:,i:i+1) - domCentre)*rotMat+domCentre;
end

end

