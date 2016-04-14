function [ pos, DOPidx] = RCDF_S(DOP, pos, S, ~, iter, DOPidx, DOPStrm)

%% This implements the Positional Change Metric - FUZZY
%
persistent domCentre;

if (iter == 1)
    domCentre =(DOP.domain(2) - (DOP.domain(2) - DOP.domain(1))/2);
end

%% currently this only works for 2 dimensions, but fuckit
%% execute the dynamic
theta = S + S*(randn(DOPStrm)*2-1)/10;
rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
pos = (pos - domCentre)*rotMat+domCentre;


end