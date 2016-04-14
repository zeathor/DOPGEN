function [ xy ] = CoordinateShift(xy,theta, offset)
%This function rotates a position by the prescribed angle theta and
%translates i

%--- define Euler z-rotation matrix Rz
th=theta*pi/180; %angle of rotation;
% this step creates a new position matrix of xyz without modifying the z
% axis
Rz=[cos(th) -sin(th) 0;sin(th) cos(th) 0;0 0 1];



end

