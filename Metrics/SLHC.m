function [MLM] = SLHC(DOP, pos, dynSettings, dim, dynamic, DOPLength)
    %% Stochastic Local Hill Climber
    % does 100 optimisations of the landscape per position
    DOPidx = 1;
    
    
    
    if(numel(DOP) > 1)
        theRange = (DOP{DOPidx}.domain(2)-DOP{DOPidx}.domain(1))/20;
    else
        theRange = (DOP.domain(2)-DOP.domain(1))/20;
    end
    
    
    
    if(numel(DOP) > 1)
        optimise = str2func(DOP{DOPidx}.typeDOP);
    else
        optimise = str2func(DOP.typeDOP);
    end
    
    classDOP = class(DOP);
    
    iter = 100*size(pos,1);
    
    MLM.base = zeros(250,size(pos,1));
    MLM.optDist = zeros(250,size(pos,1));
    MLM.nExemp = zeros(250,1);
    tic
    count = 0;
    for i = 1:DOPLength
        if i > 1
            fprintf(1, repmat('\b',1,count)); %delete line before
            count = fprintf('%s: SLHC iter %3.2f%%',classDOP,i/DOPLength*100);
        end
        %     figure;
        %     scatter(pos(:,1),pos(:,2));
        if(numel(DOP) > 1)
            origFitness = DOP{DOPidx}.calc(pos);
        else
            origFitness = DOP.calc(pos);
        end
        %     scatter(pos(:,1),pos(:,2));
        %     hold all;
        dir = randi(2,size(pos,1),dim)*2 -3 ;
        optFitness = origFitness;
        t = 0;
        optPos = pos;
        %% optimisation loop
        while t < iter
            % pick random dimension
            startPos = optPos;
            k = zeros(size(pos,1),dim);
            k(:,2) = 1;
            k = shake(k,2);
            
            % create random vector to add
            delta = randn(size(pos,1),dim)*theRange;
            add = sign(delta).*delta.*dir.*k;
            
            tempAddPos = startPos+add;
   
            if(numel(DOP) > 1)
                tempAddFitness = DOP{DOPidx}.calc(tempAddPos);
            else
                tempAddFitness = DOP.calc(tempAddPos);
            end
    
            
            %% get indices of improved fitnesses
            i1Idx = optimise(tempAddFitness,optFitness);
            % set the associated fitnesses and positions
            optFitness(i1Idx) = tempAddFitness(i1Idx);
            optPos(i1Idx,:) = tempAddPos(i1Idx,:);
            
            %% now do the remainders that didn't improve
            subtract = sign(delta(~i1Idx,:)).*delta(~i1Idx,:).*-dir(~i1Idx,:).*k(~i1Idx,:);
            tempPos = startPos(~i1Idx,:);
            tempSubPos = tempPos + subtract;
            tempDir = dir(~i1Idx,:);
            tempK = k(~i1Idx,:);
            tempFitness = optFitness(~i1Idx);
            % get subset of positions and change directions
            
            if(numel(DOP) > 1)
                tempSubFitness = DOP{DOPidx}.calc(tempSubPos);
            else
                tempSubFitness = DOP.calc(tempSubPos);
            end
   
            i2Idx = optimise(tempSubFitness,tempFitness);
            tempDir(i2Idx,:) = tempDir(i2Idx,:).*(~tempK(i2Idx,:)*2-1);
            dir(~i1Idx,:) = tempDir;
            tempPos(i2Idx,:) = tempSubPos(i2Idx,:);
            optPos(~i1Idx,:) = tempPos;
            tempFitness(i2Idx) = tempSubFitness(i2Idx);
            optFitness(~i1Idx) = tempFitness;
            
            t = size(pos,1)+sum(~i1Idx)+t;
            
        end
        MLM.base(i,:) = optFitness;
        MLM.optDist(i,:) = sqrt(sum((optPos-pos).^2,2));
        MLM.nExemp(i,1) = max(dbscan2(optPos, theRange,1));
        
        %% execute dynamic
        [pos, DOPidx] = dynamic(DOP, pos, dynSettings, dim,i, DOPidx);
    end
    fprintf('');
    toc
end

