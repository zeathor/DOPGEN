function [MLM] = CC(DOP, pos, dynSettings, dim, dynamic,DOPLength)
    %% This is the MLM for Clustered Chains.
    if(size(pos,1)<500)
        nChains = size(pos,1);
    else
        nChains = 500;
    end
    pChains = 10;
    DOPidx = 1;
    MLM.base = zeros(DOPLength,nChains);
    MLM.std = zeros(DOPLength,nChains);
    MLM.range = zeros(DOPLength,nChains);
    
    
    %% Generate the chain
    if(numel(DOP) > 1)
        minDist = (DOP{DOPidx}.domain(2)-DOP{DOPidx}.domain(1))/10;
    else
        minDist = (DOP.domain(2)-DOP.domain(1))/10;
    end
    
    
    chainA = randi(length(pos),nChains,1);
    chainB = randi(length(pos),nChains,1);
    
    distC = sqrt(sum((pos(chainA,:)-pos(chainB,:)).^2,2));
    
    while(sum(distC < minDist))
        idx = distC < minDist;
        chainR = randi(length(pos),sum(idx),1);
        % so I am lazy, just modify chainA
        chainA(idx) = chainR;
        distC(idx) = sqrt(sum((pos(chainA(idx),:)-pos(chainB(idx),:)).^2,2));
    end
    
    off = randn(pChains-2,dim);
    %% pregenerate the chains
    if(numel(DOP) > 1)
        posC = NaN(10*nChains,dim,dynSettings);
        for j = 1:nChains
            
            posA = pos(chainA(j),:);
            posB = pos(chainB(j),:);
            stepSize = (posB-posA)/(pChains-1);
            tempChain = stepSize(ones(1,pChains),:);
            tempChain(1,:) = posA;
            tempChain = cumsum(tempChain);
            offC = bsxfun(@times,off,(posB-posA)/20);
            tempChain(2:end-1,:) = tempChain(2:end-1,:)+offC;
            posC(1+(j-1)*pChains:j*pChains,:,DOPidx) = (tempChain);
        end
        
    else
        posC = zeros(10*nChains,dim);
        for j = 1:nChains
            posA = pos(chainA(j),:);
            posB = pos(chainB(j),:);
            stepSize = (posB-posA)/(pChains-1);
            tempChain = stepSize(ones(1,pChains),:);
            tempChain(1,:) = posA;
            tempChain = cumsum(tempChain);
            offC = bsxfun(@times,off,(posB-posA)/20);
            tempChain(2:end-1,:) = tempChain(2:end-1,:)+offC;
            posC(1+(j-1)*pChains:j*pChains,:) = (tempChain);
        end
    end
    
    count = 0;
    classDOP = class(DOP);
    for iter = 1:DOPLength
        

        %% Check if we are dealing with a cyclical problem and it is not the first iteration
        if (iter > 1)
            fprintf(1, repmat('\b',1,count)); %delete line before
            count = fprintf('%s: CC iter %3.2f%%',classDOP,iter/DOPLength*100);
            
            if (numel(DOP) > 1)
                newDist = (DOP{DOPidx}.domain(2)-DOP{DOPidx}.domain(1))/10;
                
                %% do we have a wholly new problem?
                if (isnan(posC(1,1,DOPidx)))
                    % are we in a completely new domain?
                    if newDist ~= minDist
                        minDist = newDist;
                        for j = 1:nChains
                            posA = pos(chainA(j),:);
                            posB = pos(chainB(j),:);
                            stepSize = (posB-posA)/(pChains-1);
                            tempChain = stepSize(ones(1,pChains),:);
                            tempChain(1,:) = posA;
                            tempChain = cumsum(tempChain);
                            offC = bsxfun(@times,off,(posB-posA)/20);
                            tempChain(2:end-1,:) = tempChain(2:end-1,:)+offC;
                            posC(1+(j-1)*pChains:j*pChains,:,DOPidx) = (tempChain);
                        end
                    else
                        %% we have the same problem domain (but different DOPidx), copy across the chain positions
                        posC(:,:,DOPidx) = posC(:,:,oldDOPidx);
                        
                    end
                end
            end
        end
        
        %% loop through each chain
        
        if(numel(DOP) > 1)
            fitness = DOP{DOPidx}.calc(posC(:,:,DOPidx));
        else
            fitness = DOP.calc(posC);
        end
        
        for j = 1:nChains
            theChain = fitness(1+(j-1)*pChains:j*pChains);
            theMean = sum(theChain)/pChains;
            MLM.base(iter,j) = theMean;
            MLM.std(iter,j) = 1/(pChains-1)*sqrt(sum((theChain-theMean).^2));
            MLM.range(iter,j) = max(theChain)-min(theChain);
        end
        oldDOPidx = DOPidx;
        %% sometimes you need to modify the position matrix
        if(isequal(dynamic, @TCD) || isequal(dynamic,@RCD) || isequal(dynamic,@TRCD) || isequal(dynamic,@RCDF) || isequal(dynamic,@RCDFix))
            [posC, DOPidx] = dynamic(DOP, posC, dynSettings, dim,iter, DOPidx);
        else    
            [pos, DOPidx] = dynamic(DOP, pos, dynSettings, dim,iter, DOPidx);
        end
        
    end
    fprintf('');
end
