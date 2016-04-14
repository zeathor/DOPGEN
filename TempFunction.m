function [ bill ] = TempFunction(fuckit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
persistent temp;

if isempty(temp)
    temp = 1;
end
temp = temp +2+fuckit;
bill = temp;
end

