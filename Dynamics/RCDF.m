function [ pos, DOPidx] = RCDF(DOP, pos, S, dim, iter, DOPidx)

%% This implements the Positional Change Metric - FUZZY
%
persistent domCentre;
if (iter == 1)
    domCentre =(DOP.domain(2) - (DOP.domain(2) - DOP.domain(1))/2);
end


%% execute the dynamic
%% loop through the required dimensions
for i  = 1:(dim-1)
    theta = S + S*(randn*2-1)/10;
    rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    pos(:,i:i+1) = (pos(:,i:i+1) - domCentre)*rotMat+domCentre;
end



end