function [MLM] = FCSP_S(DOP, pos, dynSettings, dim, dynamic,DOPLength,DOPStrm)
    %% This is the MLM for Fitness Correlation of Surrounding Points.
    % polls a hypersphere around a random sample of points
    nPoints = 50;
    DOPidx = 1;
    
    MLM.base = zeros(DOPLength,length(pos));
    MLM.range = zeros(DOPLength,length(pos));
    
    if(numel(DOP) > 1)
        domain = DOP{DOPidx}.domain;
    else
        domain = DOP.domain;
    end
    
    
    oldFitness = zeros(length(pos)*nPoints,1);
    
    %% generate the same fitness sphere to be used for each particle, mainly because we are super lazy
    sphereR = (domain(2) - domain(1))/200;
    randV = randn(nPoints,dim);
    distV = sqrt(sum(randV.^2,2))./sphereR;
    tempOff = bsxfun(@rdivide,randV,distV);
    
    %% Generate a bigger position set to begin with
    bigPos = zeros(nPoints*size(pos,1),dim);
    for j = 1:length(pos)
        rowIdx = (1 : size(pos(j,:),1))';
        colIdx = (1 : size(pos(j,:),2))';
        temp = pos(j,:);
        temp = temp(rowIdx(:, ones(nPoints,1)), colIdx(:, ones(1,1)));
        bigPos(1+(j-1)*nPoints:j*nPoints,:) = temp+tempOff;
    end
    
    count = 0;
    classDOP = class(DOP);
    for i = 1:DOPLength
        %% first attempt at this, we are going to loop through each particle
        % Terrible attempt, lets fix this fucker
        if i > 1
            fprintf(1, repmat('\b',1,count)); %delete line before
            count = fprintf('%s: FCSP iter %3.2f%%',classDOP,i/DOPLength*100);
        end
        
        if(numel(DOP) > 1)
            tempFit = DOP{DOPidx}.calc(bigPos);
        else
            tempFit = DOP.calc(bigPos);
        end
        
        for j = 1:length(pos)
            MLM.range(i,j) = max(tempFit(1+(j-1)*nPoints:j*nPoints,1))-min(tempFit(1+(j-1)*nPoints:j*nPoints,1));
            
            if(i > 1)
                MLM.base((i-1),j) = corr2(tempFit(1+(j-1)*nPoints:j*nPoints,1), oldFitness(1+nPoints*(j-1):nPoints*j,1));
            end;
        end
        oldFitness = tempFit;
        
        %% sometimes you need to modify the position matrix
        [bigPos, DOPidx] = dynamic(DOP, bigPos, dynSettings, dim,i, DOPidx,DOPStrm);
    end
    fprintf('');
end