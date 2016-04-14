function [ pos, DOPidx] = TRCD_S(DOP, pos, S, dim, nIter, DOPidx,DOPStrm)

%% This implements the Translational/Rotational Change Dynamic
persistent posOffset maxOff minOff origPos domCentre theta ;

if ( nIter  == 1) || (isempty(posOffset))
    origPos = pos;
    posOffset = zeros(1,min(size(pos)));
  
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
theta = Stheta*(rand(DOPStrm)*2-1);
rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
posRotated = (origPos - domCentre)*rotMat+domCentre;

delta = (DOP.domain(2) - DOP.domain(1))/100 * S * (rand(DOPStrm,1,dim)*2-1);
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