classdef MPB < handle
    %% Moving Peaks Benchmark - Class version
    % max and min are [0,100]
    %mpb = MPB(50, 30, 40, 1, 11,2,nPos);
    properties
        C;
        H;
        W;
        nCones;
        sidx; % global optimum index
        si; % global optimum movement direction
        typeDOP = 'gt'
        domain = [0,100];
        nPos; % for optimisation purposes only
        posC;
        pHeight = [];
        pWidth = [];
        nDim;
        LS; % change severity - Linear
        DeltaN; % environmental change index (only used for circular motion
        CS;
        tau;
        alpha = 0.04; alphaMax = 0.1;
        conesRange = [40,60]
        amIdx; amMin; amMax; amNum;
    end
    
    methods
        
        
        function mpb = MPB(nCones, hMin, hRange, wMin, WRange, nDim, nPos)
            %% constructor
            if(nargin < 5)
                mpb.nCones = 50;
                mpb.pHeight(1) = 30;    mpb.pHeight(2) = 70;
                mpb.pWidth(1) = 1;      mpb.pWidth(2) = 12;
                mpb.nDim = 2;
                mpb.nPos = 500*100;
            else
                mpb.nCones = nCones;
                mpb.pHeight(1) = hMin;  mpb.pHeight(2) = hMin+hRange;
                mpb.pWidth(1) = wMin;   mpb.pWidth(2) = wMin+WRange;
                mpb.nDim = nDim;
                mpb.nPos = nPos;
            end           
            %% do we only have 1 argument? if so, we are stating how many positions to store
            if nargin == 1
                mpb.nPos = nCones;
            end           
            mpb.C = rand(mpb.conesRange(2),mpb.nDim)*100;
            mpb.H = mpb.pHeight(1)+rand(mpb.conesRange(2),1)*(mpb.pHeight(2) - mpb.pHeight(1));
            mpb.W = mpb.pWidth(1)+rand(mpb.conesRange(2),1)*(mpb.pWidth(2) - mpb.pWidth(1));
            
            if nargin == 2
                % we are doing alternating modalites. Need to create AMnum
                % peaks significantly higher than the rest
                % pick the first amNum peaks
                mpb.amNum = hMin;
                mpb.amIdx = 1: mpb.amNum;
                mpb.amMin = mpb.pHeight(2) + 20;
                mpb.amMax = mpb.amMin + 30;
                
                
                %% YO, CHANGE THIS LATER
                mpb.H(mpb.amIdx) = mpb.amMin + rand(mpb.amNum,1)*(mpb.amMax-mpb.amMin);
            end
                
            [~,mpb.sidx] = max(mpb.H); % locate the max peak
            % relocate max peak to at least somewhere in the centre half
            mpb.C(mpb.sidx,:) = rand(1,mpb.nDim)*((mpb.domain(2)-mpb.domain(1))/2) + ((mpb.domain(2)-mpb.domain(1))/4);
            mpb.si = round(randi(2,1,mpb.nDim)*2-3); %randomly set the global optimum movement direction
            mpb.LS = [];
            mpb.CS = [];
   
            for i = 1:mpb.conesRange(2)
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            mpb.DeltaN = 0;
        end
        
        function reset(mpb)
            mpb.C = rand(mpb.conesRange(2),mpb.nDim)*max(mpb.domain);
            mpb.C(mpb.sidx,:) = rand(1,mpb.nDim)*((mpb.domain(2)-mpb.domain(1))/2) + ((mpb.domain(2)-mpb.domain(1))/4);
            mpb.H = mpb.pHeight(1) + rand(mpb.conesRange(2),1)*(mpb.pHeight(2) - mpb.pHeight(1));
            mpb.W = mpb.pWidth(1) + rand(mpb.conesRange(2),1)*(mpb.pWidth(2) - mpb.pWidth(2));
            
            if (~isempty(mpb.amNum))
                mpb.H(mpb.amIdx) = mpb.amMin + rand(mpb.amNum,1)*(mpb.amMax-mpb.amMin);
            end
            
            for i = 1:mpb.conesRange(2)
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            mpb.LS = [];
            mpb.tau = [];
            mpb.CS = [];
            mpb.DeltaN = 0;
        end
        
        function fitness = calc(mpb,pos)
            for i = mpb.nCones:-1:1
                dummy(:,i) = mpb.H(i) - mpb.W(i).*(sum((pos-mpb.posC(1:size(pos,1),:,i)).^2,2));
            end
            fitness = max(dummy,[],2);
            %             fitness(fitness < -500) = -500;
        end
        
        function fitness = calcF1(mpb,pos)
            for i = mpb.nCones:-1:1
                dummy(:,i) = mpb.H(i)./(1 + mpb.W(i).*(sum((pos - mpb.posC(1:size(pos,1),:,i)).^2,2)));
            end
            fitness  = max(dummy,[],2);
        end
        
        function fitness = calcCone(mpb,pos)
            for i = mpb.nCones:-1:1
                dummy(:,i) = mpb.H(i) - mpb.W(i).*sqrt(sum((pos-mpb.posC(1:size(pos,1),:,i)).^2,2));
            end
            fitness = max(dummy,[],2);
            fitness(fitness < 10) = 10;
        end
        
        function [x,y,fitness] = graphDOP(mpb)
            x = linspace(mpb.domain(1),mpb.domain(2),100);
            y = x;
            for i = 1:length(x)
                for j = 1:length(y)
                    fitness(i,j) = mpb.calc([x(i) y(j)]);
                end
            end
        end
        
        function alternateM(mpb,severity)
            
            delta = mpb.H(mpb.amIdx) + severity*randn(mpb.amNum,1);
            
            delta(delta > mpb.amMax) = mpb.amMax;
            delta(delta < mpb.amMin) = mpb.amMin;
            
            mpb.H(mpb.amIdx) = delta;
            
        end
        
        function linearGOM(mpb, severity)
            if isempty(mpb.LS)
                mpb.LS(1,1:(mpb.nDim/2)) = severity;
                mpb.LS(1,(mpb.nDim/2)+1:mpb.nDim) = rand(1,mpb.nDim/2)/2 * severity;
            end
            temp = mpb.C(mpb.sidx,:);
            delta = mpb.C(mpb.sidx,:) + mpb.LS.*mpb.si;
            %% find the dimensions too big
            idxBig = delta > mpb.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (mpb.domain(2) - mpb.C(mpb.sidx,idxBig))*2 - delta(idxBig) + 2*mpb.C(mpb.sidx,idxBig);
                mpb.si(idxBig) = mpb.si(idxBig)*-1;
            end
            %% find the dimensions too small
            idxSmall = delta < mpb.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (mpb.domain(1) -  mpb.C(mpb.sidx,idxSmall))*2 - delta(idxSmall) +2*mpb.C(mpb.sidx,idxSmall);
                % mpb.C(mpb.sidx,idxSmall)
                mpb.si(idxSmall) = mpb.si(idxSmall)*-1;
            end
            mpb.C(mpb.sidx,:) = delta;
            
            mpb.posC(:,:,mpb.sidx) = repmat(mpb.C(mpb.sidx,:),mpb.nPos,1);
        end
        
        function randomGOM(mpb, severity)
            delta = (rand(1,mpb.nDim)*2 -1)*(severity) * (mpb.domain(2)-mpb.domain(1))/100 + mpb.C(mpb.sidx,:);
            %% find the dimensions too big
            idxBig = delta > mpb.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (mpb.domain(2) - mpb.C(mpb.sidx,idxBig))*2 - delta(idxBig) + 2*mpb.C(mpb.sidx,idxBig);
            end
            %% find the dimensions too small
            idxSmall = delta < mpb.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (mpb.domain(1) -  mpb.C(mpb.sidx,idxSmall))*2 - delta(idxSmall) +2*mpb.C(mpb.sidx,idxSmall);
            end
            mpb.C(mpb.sidx,:) = delta;
            
            mpb.posC(:,:,mpb.sidx) = repmat(mpb.C(mpb.sidx,:),mpb.nPos,1);
        end
        
        function circularGOM(mpb, severity)
            if isempty(mpb.CS)
                SC = severity(1);
                Stau = severity(2);
                
                mpb.CS(1,1:(mpb.nDim/2)) = (mpb.domain(2)-mpb.domain(1))/100 * (5 - SC);
                mpb.CS(1,(mpb.nDim/2)+1:mpb.nDim) = (mpb.domain(2)-mpb.domain(1))/100 *5;
                mpb.tau(1,1:(mpb.nDim/2)) = 25;
                mpb.tau(1,(mpb.nDim/2)+1:mpb.nDim) = 25 - Stau;
            end
            mpb.DeltaN = mpb.DeltaN + 1;
            temp = mpb.C(mpb.sidx,:);
            delta = zeros(1,mpb.nDim);
            for i = 1:mpb.nDim
                if mod(i,2)
                    delta(i) = mpb.CS(i).*sin(2*pi.*mpb.DeltaN./(mpb.tau(i)));
                else
                    delta(i) = mpb.CS(i).*cos(2*pi.*mpb.DeltaN./(mpb.tau(i)));
                end
            end
            
            mpb.C(mpb.sidx,:) = temp + delta;
            mpb.posC(:,:,mpb.sidx) = repmat(mpb.C(mpb.sidx,:),mpb.nPos,1);
            
        end
        
        function stepChangeGradual(mpb,severity)
            s = severity/100;
            %% alter the optimum centres first
            deltaC = s*(rand(mpb.nCones,mpb.nDim)*2-1)*(mpb.domain(2)-mpb.domain(1)) + mpb.C(1:mpb.nCones,:);
            deltaC(deltaC > mpb.domain(2)) = 2*mpb.domain(2) - deltaC(deltaC > mpb.domain(2));
            deltaC(deltaC < mpb.domain(1)) = 2*mpb.domain(1) - deltaC(deltaC < mpb.domain(1));
            
            mpb.C(1:mpb.nCones,:) = deltaC;
            for i = 1:mpb.conesRange(2)
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            %% alter the heights second
            deltaH = s*(rand(mpb.nCones,1)*2-1)*(mpb.pHeight(2)-mpb.pHeight(1)) + mpb.H(1:mpb.nCones);
            deltaH(deltaH > (mpb.pHeight(2))) = 2*(mpb.pHeight(2)) - deltaH(deltaH > (mpb.pHeight(2)));
            deltaH(deltaH < mpb.pHeight(1)) = 2*mpb.pHeight(1) - deltaH(deltaH < mpb.pHeight(1));
            
            mpb.H(1:mpb.nCones) = deltaH;
            
            deltaW = s*(rand(mpb.nCones,1)*2-1)*(mpb.pWidth(2)-mpb.pWidth(1)) + mpb.W(1:mpb.nCones);
            
            deltaW(deltaW > mpb.pWidth(2)) = 2*(mpb.pWidth(2)) - deltaW(deltaW > mpb.pWidth(2));
            deltaW(deltaW < mpb.pWidth(1)) = 2*(mpb.pWidth(1)) - deltaW(deltaW < mpb.pWidth(1));
            
            mpb.W(1:mpb.nCones) = deltaW;
        end
        
        function stepChangeRandom(mpb,severity)
            s = severity;
            
            %% do centres first
            deltaC = s*randn(mpb.nCones, mpb.nDim)*(mpb.domain(2)-mpb.domain(1))/100+mpb.C(1:mpb.nCones,:);
            
            deltaC(deltaC > mpb.domain(2)) = 2*mpb.domain(2) - deltaC(deltaC > mpb.domain(2));
            deltaC(deltaC < mpb.domain(1)) = 2*mpb.domain(1) - deltaC(deltaC < mpb.domain(1));
            
            mpb.C(1:mpb.nCones,:) = deltaC;
            for i = 1:mpb.conesRange(2)
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            %% do heights
            deltaH = s*randn(mpb.nCones,1)*(mpb.pHeight(2)-mpb.pHeight(1))/100+mpb.H(1:mpb.nCones);
            
            deltaH(deltaH > mpb.pHeight(2)) = 2*(mpb.pHeight(2)) - deltaH(deltaH > mpb.pHeight(2));
            deltaH(deltaH < mpb.pHeight(1)) = 2*(mpb.pHeight(1)) - deltaH(deltaH < mpb.pHeight(1));
            
            mpb.H(1:mpb.nCones) = deltaH;
            
            
            %% do widths
            deltaW = s*randn(mpb.nCones,1)*(mpb.pWidth(2)-mpb.pWidth(1))/100+mpb.W(1:mpb.nCones);
            
            deltaW(deltaW > mpb.pWidth(2)) = 2*(mpb.pWidth(2)) - deltaW(deltaW > mpb.pWidth(2));
            deltaW(deltaW < mpb.pWidth(1)) = 2*(mpb.pWidth(1)) - deltaW(deltaW < mpb.pWidth(1));
            
            mpb.W(1:mpb.nCones) = deltaW;
        end
        
        function stepChangeLarge(mpb, S)
            %% this function alters the heights, widths and the optima positions
            
            oldC = mpb.C(1:mpb.nCones,:);
            oldW = mpb.W(1:mpb.nCones);
            oldH = mpb.H(1:mpb.nCones);
            
            %% Alter Centre
            deltaC = S*(mpb.alpha*sign(rand(mpb.nCones,mpb.nDim)) + ...
                (mpb.alphaMax-mpb.alpha)*(rand(mpb.nCones,mpb.nDim)*2-1))*(mpb.domain(2)-mpb.domain(1));
            deltaC = deltaC+oldC;
            
            deltaC(deltaC > (mpb.domain(2))) = 2*(mpb.domain(2)) - deltaC(deltaC > (mpb.domain(2)));
            deltaC(deltaC < mpb.domain(1)) = 2*mpb.domain(1) - deltaC(deltaC < mpb.domain(1));
            mpb.C(1:mpb.nCones,:) = deltaC;
            
            for i = 1:mpb.conesRange(2)
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            %% Alter Height
            deltaH = S*(mpb.alpha*sign(rand(mpb.nCones,1)) + ...
                (mpb.alphaMax-mpb.alpha)*(rand(mpb.nCones,1)*2-1))*(mpb.pHeight(2)-mpb.pHeight(1));
            deltaH = deltaH+oldH;
            
            deltaH(deltaH > (mpb.pHeight(2))) = 2*(mpb.pHeight(2)) - deltaH(deltaH > (mpb.pHeight(2)));
            deltaH(deltaH < mpb.pHeight(1)) = 2*mpb.pHeight(1) - deltaH(deltaH < mpb.pHeight(1));
            mpb.H(1:mpb.nCones) = deltaH;
            
            %% Alter Width
            deltaW = S*(mpb.alpha*sign(rand(mpb.nCones,1)) + ...
                (mpb.alphaMax-mpb.alpha)*(rand(mpb.nCones,1)*2-1))*(mpb.pWidth(2)-mpb.pWidth(1));
            deltaW = deltaW+oldW;
            
            deltaW(deltaW > (mpb.pWidth(2))) = 2*(mpb.pWidth(2)) - deltaW(deltaW > (mpb.pWidth(2)));
            deltaW(deltaW < mpb.pWidth(1)) = 2*mpb.pWidth(1) - deltaW(deltaW < mpb.pWidth(1));
            mpb.W(1:mpb.nCones) = deltaW;
            
        end
        
        function stepChangePeakFunction(mpb,severity)
            prob = rand;
            if prob < severity/100
                mpb.nCones = mpb.nCones+ sign(rand*2-1);
            end
            
            if mpb.nCones < mpb.conesRange(1)
                mpb.nCones = mpb.conesRange(1)+1;
            elseif mpb.nCones > mpb.conesRange(2)
                mpb.nCones = mpb.conesRange(2)-1;
            end
        end
        
        
    end
    
end

