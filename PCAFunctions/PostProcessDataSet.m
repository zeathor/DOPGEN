function [ dataSet, descriptorSet] = PostProcessDataSet(dataSet, descriptorSet,statsRemove)
    newDataSet = dataSet;
    newDescriptorSet = descriptorSet;
    

    %% some quick data cleaning, we need to get rid of the NaNs and zeros
    nanIdx = any(isnan(newDataSet),1);
    temp = newDataSet;
    index = true(size(temp, 2),1);
    index(nanIdx) = false;
    newDataSet = temp(:,index);
    % get rid of descriptors
    for i = length(nanIdx):-1:1
        newDescriptorSet(:,nanIdx(i)) = [];
    end
    
    %% get rid of zeros
    % first get the indices
    zeroIdx = find(~any(newDataSet,1));
    newDataSet( :, ~any(newDataSet,1) ) = [];
    % get rid of descriptors
    for i = length(zeroIdx):-1:1
        newDescriptorSet(:,zeroIdx(i)) = [];
    end
    
    
    
    %% Get the indices that match the removal set, then purge from data
    delArray = zeros(size(newDescriptorSet));
    for i = 1:numel(statsRemove)
        logicalArray = cellfun(@(x,y)~isempty(strfind(x,statsRemove{i})), newDescriptorSet);
        delArray = delArray | logicalArray;
    end
    
    
    dataSet = newDataSet(:,~delArray);
    newDescriptorSet(:,delArray) = [];
    descriptorSet = newDescriptorSet;
    
    
end

