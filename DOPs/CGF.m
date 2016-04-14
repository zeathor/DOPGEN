classdef CGF < handle
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    properties
        sidx;
        convergeS;
        stretchS;
        nFunc;
        funcRange = [5,15];
        funcDomain = [-100,100];
        domain = [-5,5];
        nDim;
        typeDOP = 'lt';
        funcRotMat;
        O;
        FMax;
        H;
        S;
        posO
        si;
        hExp;
        nPos;
        fHeight = [];
        alpha = 0.04;
        alphaMax = 0.1;
        amNum; amIdx; amMin; amMax;
        DeltaN; % environmental change index (only used for circular motion
        CS;
        tau;
    end
    
    methods
        
        function cgf = CGF(nFunc, hMin, hRange, ~, ~, nDim, nPos)
            if(nargin < 7)
                cgf.nFunc = 10;
                cgf.nDim = 2;
                cgf.fHeight(1) = 10;
                cgf.fHeight(2) = 100;          
                cgf.nPos = 5000*100;          
            else
                cgf.nFunc = nFunc;
                if cgf.nFunc > cgf.funcRange(2)
                    cgf.funcRange(2) = cgf.nFunc;
                elseif cgf.nFunc < cgf.funcRange(1)
                    cgf.funcRange(1) = cgf.nFunc;
                end          
                cgf.nDim = nDim;
                cgf.fHeight(1) = hMin;
                cgf.fHeight(2) = hMin+hRange;              
                if nPos < 100*100
                    cgf.nPos = 100*100;
                else
                    cgf.nPos = nPos;
                end
            end       
            %% terrible hack for cyclical problems
            if nargin == 1
                cgf.nPos = nFunc;
            end    
  
            cgf.stretchS = ones(1,cgf.funcRange(2))*(cgf.domain(2)-cgf.domain(1))/(cgf.funcDomain(2)-cgf.funcDomain(1));
            cgf.convergeS = ones(1,cgf.funcRange(2));
            cgf.funcRotMat = zeros(cgf.nDim, cgf.nDim,cgf.funcRange(2));
            cgf.setRotationMatrix;
            cgf.O = rand(cgf.funcRange(2),cgf.nDim)*10-5;
            
            for i = 1:cgf.funcRange(2)
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos ,1);
            end
            
            cgf.setFMax;
            cgf.H = rand(cgf.funcRange(2),1)*(cgf.fHeight(2)-cgf.fHeight(1))+cgf.fHeight(1);
            if nargin == 2
                % we are doing alternating modalites. Need to create AMnum
                % peaks significantly higher than the rest
                % pick the first amNum peaks
                cgf.amNum = hMin;
                cgf.amIdx = 1: cgf.amNum;
                cgf.amMax = cgf.fHeight(1) - 20;
                cgf.amMin = cgf.amMax - 30;
                cgf.H(cgf.amIdx) = cgf.amMin + rand(cgf.amNum,1)*(cgf.amMax-cgf.amMin);
            end
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);
            [~,cgf.sidx] = min(cgf.H(1:cgf.nFunc,1)); % locate the min peak out of the set peaks
            cgf.si = round(randi(2,1,cgf.nDim)*2-3); %randomly set the global optimum movement direction
            cgf.S = [];
            cgf.tau = [];
            cgf.CS = [];
            cgf.DeltaN = 0;
            
            
        end
        
        function reset(cgf)
            
            cgf.setRotationMatrix;
            cgf.O = rand(cgf.funcRange(2),cgf.nDim)*10-5;
            for i = 1:cgf.nFunc
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos,1);
            end
            cgf.H = rand(cgf.funcRange(2),1)*(cgf.fHeight(2) - cgf.fHeight(1))+cgf.fHeight(1);
            if (~isempty(cgf.amNum))
                cgf.H(cgf.amIdx) = cgf.amMin + rand(cgf.amNum,1)*(cgf.amMax-cgf.amMin);
            end
            
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);
            [~,cgf.sidx] = min(cgf.H); % locate the min peak
            cgf.si = round(randi(2,1,cgf.nDim)*2-3); %randomly set the global optimum movement direction
            cgf.S = [];
            cgf.tau = [];
            cgf.CS = [];
            cgf.DeltaN = 0;
            
            
        end
        
        function setOptCentre(cgf,pos)
            if size(pos,1) > cgf.funcRange(2)
                optIdxMax = cgf.funcRange(2);
            else
                optIdxMax = size(pos,1);
            end
            
            for i = 1:optIdxMax
                cgf.O(i,:) = pos(i,:);
            end
            
        end
        
        function fit = griewank(~, pos)
            s1=zeros(size(pos,1),1);s2=ones(size(pos,1),1);
            for i = 1:size(pos,2)
                s1 = s1+ (pos(:,i).^2)/4000;
                s2 = s2.*cos(pos(:,i)/sqrt(i));
            end
            fit = s1-s2+1;
        end
        
        function setFMax(cgf)
            fMax = ones(1, cgf.nDim)*cgf.funcDomain(2);
            cgf.FMax = zeros(1,cgf.funcRange(2));
            for i = 1:cgf.nFunc
                rotMax = fMax*cgf.funcRotMat(:,:,i);
                for j = 1:cgf.nDim
                    if (rotMax(1,j) > cgf.funcDomain(2))
                        rotMax(1,j) = cgf.funcDomain(2);
                    elseif (rotMax(1,j) < cgf.funcDomain(1))
                        rotMax(1,j) = cgf.funcDomain(1);
                    end
                end
                cgf.FMax(i) = cgf.griewank(rotMax*cgf.funcRotMat(:,:,i));
            end
            
        end
        
        function setRotationMatrix(cgf)
            d = randperm(cgf.nDim);
            for i = 1:cgf.funcRange(2)
                cgf.funcRotMat(:,:,i) = eye(cgf.nDim,cgf.nDim);
                for j = 1:2:(cgf.nDim-1)
                    theta = 2*pi*rand;
                    r = d(j);
                    c = d(j+1);
                    temp = eye(cgf.nDim);
                    temp([r c],[r c]) = [cos(theta) -sin(theta); sin(theta) cos(theta)];
                    if j == 1
                        cgf.funcRotMat(:,:,i) = temp;
                    else
                        cgf.funcRotMat(:,:,i) = cgf.funcRotMat(:,:,i) *temp;
                    end
                end
            end
            
        end
        
        function fitness = calc(cgf,pos)
            W = zeros(cgf.nFunc, size(pos,1));
            mFit = zeros(cgf.nFunc,size(pos,1));
            for i = 1:cgf.nFunc
                W(i,:) = sum((pos - cgf.posO(1:size(pos,1),:,i)).^2,2);
                
                if W(i,:)
                    W(i,:) = exp(-sqrt(W(i,:)/(2*cgf.nDim*(cgf.convergeS(i).^2))));
                end
            end
            
            for i = 1:cgf.nFunc
                
                tempPos = (pos-cgf.posO(1:size(pos,1),:,i))/cgf.stretchS(i);
                
                m = tempPos*cgf.funcRotMat(:,:,i);
                
                for j = 1:size(pos,1)
                    for k = 1:cgf.nDim
                        if (m(j,k) > cgf.funcDomain(2))
                            m(j,k) = cgf.funcDomain(2);
                        elseif (m(j,k) < cgf.funcDomain(1))
                            m(j,k) = cgf.funcDomain(1);
                        end
                    end
                end
                mFit(i,:) = cgf.griewank(m)*2000./abs(cgf.FMax(i))';
                
            end
            
            
            wmax = max(W);
            
            
            tempWmax = wmax(ones(cgf.nFunc, 1),:);
            W(W ~= tempWmax) = W(W ~= tempWmax).*(1-tempWmax(W ~= tempWmax).^10);
            
            sumW = sum(W);
            
            W = bsxfun(@rdivide,W,sumW);
            
            obj = sum(W.*(mFit+cgf.hExp(cgf.nFunc,size(pos,1))));
            
            fitness = obj';
        end
        
        function linearGOM(cgf, severity)
            if isempty(cgf.S)
                cgf.S(1,1:(cgf.nDim/2)) = severity;
                cgf.S(1,(cgf.nDim/2)+1:cgf.nDim) = rand(1,cgf.nDim/2)/2 * severity;
            end
            
            delta = cgf.O(cgf.sidx,:) + cgf.S.*cgf.si;
            %% find the dimensions too big
            idxBig = delta > cgf.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (cgf.domain(2) - cgf.O(cgf.sidx,idxBig))*2 - delta(idxBig) + 2*cgf.O(cgf.sidx,idxBig);
                cgf.si(idxBig) = cgf.si(idxBig)*-1;
            end
            %% find the dimensions too small
            idxSmall = delta < cgf.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (cgf.domain(1) -  cgf.O(cgf.sidx,idxSmall))*2 - delta(idxSmall) +2*cgf.O(cgf.sidx,idxSmall);
                % mpb.C(mpb.sidx,idxSmall)
                cgf.si(idxSmall) = cgf.si(idxSmall)*-1;
            end
            cgf.O(cgf.sidx,:) = delta;
            cgf.posO(:,:,cgf.sidx) = repmat(cgf.O(cgf.sidx,:),cgf.nPos,1);
            
            cgf.setFMax;    
        end
        
        function randomGOM(cgf, severity)
            delta = (rand(1,cgf.nDim)*2 -1)*(severity) * (cgf.domain(2)-cgf.domain(1))/100 + cgf.O(cgf.sidx,:);
            %% find the dimensions too big
            idxBig = delta > cgf.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (cgf.domain(2) - cgf.O(cgf.sidx,idxBig))*2 - delta(idxBig) + 2*cgf.O(cgf.sidx,idxBig);
            end
            %% find the dimensions too small
            idxSmall = delta < cgf.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (cgf.domain(1) -  cgf.O(cgf.sidx,idxSmall))*2 - delta(idxSmall) +2*cgf.O(cgf.sidx,idxSmall);
                
            end
            cgf.O(cgf.sidx,:) = delta;
            
            cgf.posO(:,:,cgf.sidx) = repmat(cgf.O(cgf.sidx,:),cgf.nPos,1);
            cgf.setFMax; 
        end
        
        function circularGOM(cgf, severity)
            if isempty(cgf.CS)
                SC = severity(1);
                Stau = severity(2);
                
                cgf.CS(1,1:(cgf.nDim/2)) = (cgf.domain(2)-cgf.domain(1))/100 * (5 - SC);
                cgf.CS(1,(cgf.nDim/2)+1:cgf.nDim) = (cgf.domain(2)-cgf.domain(1))/100 *5;
                cgf.tau(1,1:(cgf.nDim/2)) = 25;
                cgf.tau(1,(cgf.nDim/2)+1:cgf.nDim) = 25 - Stau;
            end
            cgf.DeltaN = cgf.DeltaN + 1;
            temp = cgf.O(cgf.sidx,:);
            delta = zeros(1,cgf.nDim);
            for i = 1:cgf.nDim
                if mod(i,2)
                    delta(i) = cgf.CS(i).*sin(2*pi.*cgf.DeltaN./(cgf.tau(i)));
                else
                    delta(i) = cgf.CS(i).*cos(2*pi.*cgf.DeltaN./(cgf.tau(i)));
                end
            end
            
            cgf.O(cgf.sidx,:) = temp + delta;
            cgf.posO(:,:,cgf.sidx) = repmat(cgf.O(cgf.sidx,:),cgf.nPos,1);
            
        end
        
        function alternateM(cgf,severity)
    
            delta = cgf.H(cgf.amIdx) + severity*randn(cgf.amNum,1)*2;
            
            delta(delta > cgf.amMax) = cgf.amMax;
            delta(delta < cgf.amMin) = cgf.amMin;
            
            cgf.H(cgf.amIdx) = delta;
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);
        end
        
        
        function stepChangeGradual(cgf,severity)
            s = severity/100;
            %% alter the optimum centres first
            deltaO = s*(rand(cgf.nFunc,cgf.nDim)*2-1)*(cgf.domain(2)-cgf.domain(1)) + cgf.O(1:cgf.nFunc,:);
            deltaO(deltaO > cgf.domain(2)) = 2*cgf.domain(2) - deltaO(deltaO > cgf.domain(2));
            deltaO(deltaO < cgf.domain(1)) = 2*cgf.domain(1) - deltaO(deltaO < cgf.domain(1));
            
            cgf.O(1:cgf.nFunc,:) = deltaO;
            for i = 1:cgf.nFunc
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos,1);
            end
              
            %% alter the heights second
            deltaH = s*(rand(cgf.nFunc,1)*2-1)*(cgf.fHeight(2)-cgf.fHeight(1)) + cgf.H(1:cgf.nFunc,:);
            deltaH(deltaH > (cgf.fHeight(2))) = 2*(cgf.fHeight(2)) - deltaH(deltaH > (cgf.fHeight(2)));
            deltaH(deltaH < cgf.fHeight(1)) = 2*cgf.fHeight(1) - deltaH(deltaH < cgf.fHeight(1));
            
            cgf.H(1:cgf.nFunc,:) = deltaH;
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);         
            cgf.setFMax;
        end
        
        function stepChangeRandom(cgf,severity)
            s = severity;
            
            %% do centres first
            deltaO = s*randn(cgf.nFunc, cgf.nDim)*(cgf.domain(2)-cgf.domain(1))/100+cgf.O(1:cgf.nFunc,:);
            
            deltaO(deltaO > cgf.domain(2)) = 2*cgf.domain(2) - deltaO(deltaO > cgf.domain(2)); 
            deltaO(deltaO < cgf.domain(1)) = 2*cgf.domain(1) - deltaO(deltaO < cgf.domain(1)); 
            
            cgf.O(1:cgf.nFunc,:) = deltaO;
            for i = 1:cgf.nFunc
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos,1);
            end
            
            %% do heights
            deltaH = s*randn(cgf.nFunc,1)*(cgf.fHeight(2)-cgf.fHeight(1))/100+cgf.H(1:cgf.nFunc,:);
            deltaH(deltaH > cgf.fHeight(2)) = 2*(cgf.fHeight(2)) - deltaH(deltaH > cgf.fHeight(2)); 
            deltaH(deltaH < cgf.fHeight(1)) = 2*(cgf.fHeight(1)) - deltaH(deltaH < cgf.fHeight(1)); 
            
            cgf.H(1:cgf.nFunc,:) = deltaH;
        end
        
        
        function stepChangeLarge(cgf, S)
            %% this function alters the heights and the optima positions
            oldO = cgf.O(1:cgf.nFunc,:);
            oldH = cgf.H(1:cgf.nFunc);
            
            %% Alter Centre
            deltaO = S*(cgf.alpha*sign(rand(cgf.nFunc,cgf.nDim)) + ...
                (cgf.alphaMax-cgf.alpha)*(rand(cgf.nFunc,cgf.nDim)*2-1))*(cgf.domain(2)-cgf.domain(1));
            deltaO = deltaO+oldO;
            
            deltaO(deltaO > (cgf.domain(2))) = 2*(cgf.domain(2)) - deltaO(deltaO > (cgf.domain(2)));
            deltaO(deltaO < cgf.domain(1)) = 2*cgf.domain(1) - deltaO(deltaO < cgf.domain(1));
            cgf.O(1:cgf.nFunc,:) = deltaO;
            
            for i = 1:cgf.nFunc
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos,1);
            end
            
            
            theRand = rand(cgf.nFunc,1);
            deltaH = oldH+S.*((cgf.alpha.*sign(theRand)) + (cgf.alphaMax-cgf.alpha).*theRand).*(cgf.fHeight(2)-cgf.fHeight(1));
            
            deltaH(deltaH > (cgf.fHeight(2))) = 2*(cgf.fHeight(2)) - deltaH(deltaH > (cgf.fHeight(2)));
            deltaH(deltaH < cgf.fHeight(1)) = 2*cgf.fHeight(1) - deltaH(deltaH < cgf.fHeight(1));
            cgf.H(1:cgf.nFunc) = deltaH;
            
        end
        
        
        
        
        function stepChangePeakFunction(cgf,severity)         
            prob = rand*2-1;
            if abs(prob) < severity/100
                cgf.nFunc = cgf.nFunc + sign(randi(2)*2-3);
            end
            
            if cgf.nFunc < cgf.funcRange(1)
                cgf.nFunc = cgf.funcRange(1)+1;
            elseif cgf.nFunc > cgf.funcRange(2)
                cgf.nFunc = cgf.funcRange(2)-1;
            end
        end
                
        function [x,y,fitness] = graphDOP(cgf)
            x = linspace(cgf.domain(1),cgf.domain(2),100);
            y = x;
            
            pos = [];
            for i = length(x):-1:1
                for j = length(y):-1:1
                    pos((i-1)*length(x)+(j),:) = [x(i) y(j)];
                end
            end
            
            fitness = cgf.calc(pos);  
        end

    end
end




