function [ pos, DOPidx] = TRCD(DOP, pos, S, dim, nIter, DOPidx)

%% This implements the Translational/Rotational Change Dynamic
persistent posOffset maxOff minOff origPos domCentre theta ;

if ( nIter  == 1) || (isempty(posOffset))
    origPos = pos;
    posOffset = zeros(1,dim);
    theta = zeros(1,dim-1);
    maxOff = (DOP.domain(2) - DOP.domain(1))/2;
    minOff = -maxOff;
    domCentre =(DOP.domain(2) - (DOP.domain(2) - DOP.domain(1))/2);
end

%% currently this only works for 2 dimensions, but fuckit
% also note that the angle of rotation varies with translation
% assume that S is a percentage [0,25]
% transform S to theta by mapping [0,25] -> [0,pi]
Stheta = S/25*pi;


%% execute the dynamic
% rotate first, then translate. The offset is persistent. Regenerate the position matrix anew each change
theta = theta + Stheta*(rand(1,dim-1)*2-1);
posRotated = pos;
for i  = 1:(dim-1)
    rotMat = [cos(theta(i)) -sin(theta(i)); sin(theta(i)) cos(theta(i))];
    posRotated(:,i:i+1) = (origPos(:,i:i+1) - domCentre)*rotMat+domCentre;
end


delta = (DOP.domain(2) - DOP.domain(1))/100 * S * (rand(1,dim)*2-1);
for j = 1:dim
    if((posOffset(j) + delta(j)) > maxOff)
        posOffset(j) = 2*(maxOff - posOffset(j)) - delta(j) + posOffset(j);
    elseif((posOffset(j) + delta(j)) < minOff)
        posOffset(j) = 2*(minOff - posOffset(j)) - delta(j) + posOffset(j);
    else
        posOffset(j) = posOffset(j) + delta(j);
    end
end
pos = bsxfun(@plus,posRotated,posOffset);


end