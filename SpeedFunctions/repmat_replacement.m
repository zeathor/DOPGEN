function [ newMatrix ] = repmat_replacement( theMatrix, theRows, theColumns)
%% This function is NOT supposed to be used, code is only supposed to be placed inline

%% Repmat with One-Dimensional Arrays
% WHEN m is 1
newMatrix = theMatrix(:, ones(theRows, theColumns));

% WHEN n is 1 
idx = [1 : size(theMatrix,1)]';
newMatrix = theMatrix(idx(:, ones(theRows, 1)), :);
% or this one - PREFERABLE!!!!
newMatrix = theMatrix(ones(1,theRows),:);

%% Repmat with multi-dimensional arrays
rowIdx = (1 : size(theMatrix,1))';
colIdx = (1 : size(theMatrix,2))';
newMatrix = theMatrix(rowIdx(:, ones(theRows,1)), colIdx(:, ones(theColumns,1)));



end

