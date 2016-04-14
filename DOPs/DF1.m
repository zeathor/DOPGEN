classdef DF1 < handle
    %% Field of Cones - Class version
    
    %df1 = DF1(10, 3, 3, 2, 5, 2,101*101);
    
    properties
        nCones;
        C;
        H;
        W;
        nDim;
        domain = [-1,1];
        typeDOP = 'gt'; % just to let us know this is a maximisation problem
        posC = []; % for optimisation only
        nPos;   % same reason as above
        pHeight = [];
        pWidth = [];
        sidx;
        amNum = [];
        amIdx = [];
        amMax, amMin;
        alpha = 0.04;
        alphaMax = 0.1;
        si;
        LS;
        DeltaN; % environmental change index (only used for circular motion
        CS;
        tau;
        conesRange = [10,30];
    end
    
    methods
        
        function df1 = DF1(nCones, hMin, hRange, rMin, rRange, nDim, nPos, amNum)
            %% constructor    
            if(nargin < 7)
                df1.pHeight(1) = 1; df1.pHeight(2) = 20;
                df1.pWidth(1) = 40; df1.pWidth(2) = 100;
                df1.nDim = 2;
                df1.nCones = 20;
                df1.nPos = 5000*100;
            else
                df1.pHeight(1) = hMin; df1.pHeight(2) = hMin+hRange;
                df1.pWidth(1) = rMin; df1.pWidth(2) = rMin+rRange;
                df1.nDim = nDim;
                df1.nCones = nCones;
                df1.nPos = nPos;
            end
            %% if we only give 1 input argument
            if(nargin == 1)
                df1.nPos = nCones;
            end
            
            
            df1.C = rand(df1.conesRange(2),df1.nDim)*2 -1;
            df1.H = df1.pHeight(1)+rand(df1.conesRange(2),1)*(df1.pHeight(2) - df1.pHeight(1));
            df1.W = df1.pWidth(1)+rand(df1.conesRange(2),1)*(df1.pWidth(2) - df1.pWidth(1));
            [~,df1.sidx] = max(df1.H); % locate the max peak
            % relocate max peak to at least somewhere in the centre half
            df1.C(df1.sidx,:) = rand(1,df1.nDim)*((df1.domain(2)-df1.domain(1))/2) + ((df1.domain(2)-df1.domain(1))/4);
            df1.si = round(randi(2,1,df1.nDim)*2-3); %randomly set the global optimum movement direction
            df1.LS = [];
            df1.CS = [];
            df1.tau = [];
                 
            if(nargin == 8)
                % we are doing alternating modalites. Need to create AMnum
                % peaks significantly higher than the rest
                % pick the first amNum peaks
                df1.amIdx = 1:amNum;
                df1.amMin = hMin+hRange + 10;
                df1.amMax = df1.amMin + 20;
                df1.amNum = amNum;
                
                %% YO, CHANGE THIS LATER
                df1.W(df1.amIdx) = 100;
                df1.H(df1.amIdx) = df1.amMin + rand(df1.amNum,1)*(df1.amMax-df1.amMin);
            else
                [~,df1.sidx] = max(df1.H); % locate the max peak
                % relocate max peak to at least somewhere in the centre half
                df1.C(df1.sidx,:) = rand(1,df1.nDim)*((df1.domain(2)-df1.domain(1))/2) + ((df1.domain(2)-df1.domain(1))/4)+df1.domain(1);
            end
            
            for i = 1:df1.conesRange(2)
                thePos = df1.C(i,:);
                df1.posC(:,:,i) = thePos(ones(1,df1.nPos ),:);
            end
            df1.DeltaN = 0;
            
        end
        
        function reset(df1)
            df1.C(1:df1.nCones,:) = rand(df1.nCones,df1.nDim)*2 -1;
            df1.H(1:df1.nCones,:) = df1.pHeight(1)+rand(df1.nCones,1)*(df1.pHeight(2)-df1.pHeight(1));
            df1.W(1:df1.nCones,:) = df1.pWidth(1)+rand(df1.nCones,1)*(df1.pWidth(2)-df1.pWidth(1));
            
            
            if (~isempty(df1.amNum))
                df1.W(df1.amIdx) = 100;
                df1.H(df1.amIdx) = df1.amMin + rand(df1.amNum,1)*(df1.amMax-df1.amMin);
                
            else
                [~,df1.sidx] = max(df1.H); % locate the max peak
                % relocate max peak to at least somewhere in the centre half
                df1.C(df1.sidx,:) = rand(1,df1.nDim)*((df1.domain(2)-df1.domain(1))/2) + ((df1.domain(2)-df1.domain(1))/4)+df1.domain(1);
            end
            
            for i = 1:df1.conesRange(2)
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
            
            df1.LS = [];
            df1.tau = [];
            df1.CS = [];
            df1.DeltaN = 0;
            
        end
        
        function fitness = calc(df1,pos)
            for i = df1.nCones:-1:1
                dummy(:,i) = df1.H(i) - df1.W(i).*sqrt(sum((pos-df1.posC(1:size(pos,1),:,i)).^2,2));
            end
            fitness = max(dummy,[],2);
        end
              
        function randomGOM(df1, severity)
            delta = (rand(1,df1.nDim)*2 -1)*(severity) * (df1.domain(2)-df1.domain(1))/100 + df1.C(df1.sidx,:);
            %% find the dimensions too big
            idxBig = delta > df1.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (df1.domain(2) - df1.C(df1.sidx,idxBig))*2 - delta(idxBig) + 2*df1.C(df1.sidx,idxBig);
            end
            %% find the dimensions too small
            idxSmall = delta < df1.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (df1.domain(1) -  df1.C(df1.sidx,idxSmall))*2 - delta(idxSmall) +2*df1.C(df1.sidx,idxSmall);           
            end
            df1.C(df1.sidx,:) = delta;
            
            df1.posC(:,:,df1.sidx) = repmat(df1.C(df1.sidx,:),df1.nPos,1);
        end
        
        function linearGOM(df1, severity)
            if isempty(df1.LS)
                df1.LS(1,1:(df1.nDim/2)) = severity;
                df1.LS(1,(df1.nDim/2)+1:df1.nDim) = rand(1,df1.nDim/2)/2 * severity; 
            end
            temp = df1.C(df1.sidx,:);
            delta = df1.C(df1.sidx,:) + df1.LS.*df1.si;
            %% find the dimensions too big
            idxBig = delta > df1.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (df1.domain(2) - df1.C(df1.sidx,idxBig))*2 - delta(idxBig) + 2*df1.C(df1.sidx,idxBig);
                df1.si(idxBig) = df1.si(idxBig)*-1;
            end
            %% find the dimensions too small
            idxSmall = delta < df1.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (df1.domain(1) -  df1.C(df1.sidx,idxSmall))*2 - delta(idxSmall) +2*df1.C(df1.sidx,idxSmall);
                % mpb.C(mpb.sidx,idxSmall)
                df1.si(idxSmall) = df1.si(idxSmall)*-1;
            end
            df1.C(df1.sidx,:) = delta;
            
            df1.posC(:,:,df1.sidx) = repmat(df1.C(df1.sidx,:),df1.nPos,1);
            
        end
        
        function circularGOM(df1, severity)
            if isempty(df1.CS)
                SC = severity(1);
                Stau = severity(2);
                
                df1.CS(1,1:(df1.nDim/2)) = (df1.domain(2)-df1.domain(1))/100 * (5 - SC);
                df1.CS(1,(df1.nDim/2)+1:df1.nDim) = (df1.domain(2)-df1.domain(1))/100 *5;
                df1.tau(1,1:(df1.nDim/2)) = 25;
                df1.tau(1,(df1.nDim/2)+1:df1.nDim) = 25 - Stau;
            end
            df1.DeltaN = df1.DeltaN + 1;
            temp = df1.C(df1.sidx,:);
            delta = zeros(1,df1.nDim);
            for i = 1:df1.nDim
                if mod(i,2)
                    delta(i) = df1.CS(i).*sin(2*pi.*df1.DeltaN./(df1.tau(i)));
                else
                    delta(i) = df1.CS(i).*cos(2*pi.*df1.DeltaN./(df1.tau(i)));
                end
            end
            
            df1.C(df1.sidx,:) = temp + delta;
            df1.posC(:,:,df1.sidx) = repmat(df1.C(df1.sidx,:),df1.nPos,1);
            
        end
        
        
        
        function alternateM(df1,severity)
            
            delta = df1.H(df1.amIdx) + severity*randn(df1.amNum,1);
            
            delta(delta > df1.amMax) = df1.amMax;
            delta(delta < df1.amMin) = df1.amMin;
            
            df1.H(df1.amIdx) = delta;
            
        end
        
        function [x,y,fitness] = graphDOP(df1)
            x = linspace(df1.domain(1),df1.domain(2),100);
            y = x;
            fitness = zeros(100);
            for i = 1:length(x)
                for j = 1:length(y)
                    fitness(i,j) = df1.calc([x(i) y(j)]);
                end
            end
            figure
            contour(x,y,fitness);
            figure
            surf(x,y,fitness);         
        end
        
        function stepChangeGradual(df1,severity)
            s = severity/100;
            %% alter the optimum centres first
            deltaC = s*(rand(df1.nCones,df1.nDim)*2-1)*(df1.domain(2)-df1.domain(1)) + df1.C(1:df1.nCones,:);
            deltaC(deltaC > df1.domain(2)) = 2*df1.domain(2) - deltaC(deltaC > df1.domain(2));
            deltaC(deltaC < df1.domain(1)) = 2*df1.domain(1) - deltaC(deltaC < df1.domain(1));
            
            df1.C(1:df1.nCones,:) = deltaC;
            for i = 1:df1.conesRange(2)
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
              
            %% alter the heights second
            deltaH = s*(rand(df1.nCones,1)*2-1)*(df1.pHeight(2)-df1.pHeight(1)) + df1.H(1:df1.nCones,:);
            deltaH(deltaH > (df1.pHeight(2))) = 2*(df1.pHeight(2)) - deltaH(deltaH > (df1.pHeight(2)));
            deltaH(deltaH < df1.pHeight(1)) = 2*df1.pHeight(1) - deltaH(deltaH < df1.pHeight(1));
            
            df1.H(1:df1.nCones,:) = deltaH;
            
            deltaW = s*(rand(df1.nCones,1)*2-1)*(df1.pWidth(2)-df1.pWidth(1)) + df1.W(1:df1.nCones,:);
            
            deltaW(deltaW > df1.pWidth(2)) = 2*(df1.pWidth(2)) - deltaW(deltaW > df1.pWidth(2)); 
            deltaW(deltaW < df1.pWidth(1)) = 2*(df1.pWidth(1)) - deltaW(deltaW < df1.pWidth(1)); 
            
            df1.W(1:df1.nCones,:) = deltaW; 
                       
        end
                    
        function stepChangeRandom(df1,severity)
            s = severity;
            
            %% do centres first
            deltaC = s*randn(df1.nCones, df1.nDim)*(df1.domain(2)-df1.domain(1))/100+df1.C(1:df1.nCones,:);
            
            deltaC(deltaC > df1.domain(2)) = 2*df1.domain(2) - deltaC(deltaC > df1.domain(2)); 
            deltaC(deltaC < df1.domain(1)) = 2*df1.domain(1) - deltaC(deltaC < df1.domain(1)); 
            
            df1.C(1:df1.nCones,:) = deltaC;
            for i = 1:df1.conesRange(2)
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
            
            %% do heights
            deltaH = s*randn(df1.nCones,1)*(df1.pHeight(2)-df1.pHeight(1))/100+df1.H(df1.nCones,:);
            
            deltaH(deltaH > df1.pHeight(2)) = 2*(df1.pHeight(2)) - deltaH(deltaH > df1.pHeight(2)); 
            deltaH(deltaH < df1.pHeight(1)) = 2*(df1.pHeight(1)) - deltaH(deltaH < df1.pHeight(1)); 
            
            df1.H(1:df1.nCones,:) = deltaH;
            
            
            %% do widths
            deltaW = s*randn(df1.nCones,1)*(df1.pWidth(2)-df1.pWidth(1))/100+df1.W(df1.nCones,:);
            
            deltaW(deltaW > df1.pWidth(2)) = 2*(df1.pWidth(2)) - deltaW(deltaW > df1.pWidth(2)); 
            deltaW(deltaW < df1.pWidth(1)) = 2*(df1.pWidth(1)) - deltaW(deltaW < df1.pWidth(1)); 
            
            df1.W(1:df1.nCones,:) = deltaW; 
        end
        
        
        function stepChangeLarge(df1, S)
            %% this function alters the heights, widths and the optima positions
            oldC = df1.C(1:df1.nCones,:);
            oldW = df1.W(1:df1.nCones);
            oldH = df1.H(1:df1.nCones);
            
            %% Alter Centre
            deltaC = S*(df1.alpha*sign(rand(df1.nCones,df1.nDim)) + ...
                (df1.alphaMax-df1.alpha)*(rand(df1.nCones,df1.nDim)*2-1))*(df1.domain(2)-df1.domain(1));
            deltaC = deltaC+oldC;

            deltaC(deltaC > (df1.domain(2))) = 2*(df1.domain(2)) - deltaC(deltaC > (df1.domain(2)));
            deltaC(deltaC < df1.domain(1)) = 2*df1.domain(1) - deltaC(deltaC < df1.domain(1));
            df1.C(1:df1.nCones,:) = deltaC;
            
            for i = 1:df1.nCones
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
            
            %% Alter Height
            deltaH = S*(df1.alpha*sign(rand(df1.nCones,1)) + ...
                (df1.alphaMax-df1.alpha)*(rand(df1.nCones,1)*2-1))*(df1.pHeight(2)-df1.pHeight(1));
            deltaH = deltaH+oldH;
            
            deltaH(deltaH > (df1.pHeight(2))) = 2*(df1.pHeight(2)) - deltaH(deltaH > (df1.pHeight(2)));
            deltaH(deltaH < df1.pHeight(1)) = 2*df1.pHeight(1) - deltaH(deltaH < df1.pHeight(1));
            df1.H(1:df1.nCones) = deltaH;
            
            %% Alter Width
            deltaW = S*(df1.alpha*sign(rand(df1.nCones,1)) + ...
                (df1.alphaMax-df1.alpha)*(rand(df1.nCones,1)*2-1))*(df1.pWidth(2)-df1.pWidth(1));
            deltaW = deltaW+oldW;
            
            deltaW(deltaW > (df1.pWidth(2))) = 2*(df1.pWidth(2)) - deltaW(deltaW > (df1.pWidth(2)));
            deltaW(deltaW < df1.pWidth(1)) = 2*df1.pWidth(1) - deltaW(deltaW < df1.pWidth(1));
            df1.W(1:df1.nCones) = deltaW;

        end
        
        function stepChangePeakFunction(df1,severity)         
            prob = rand;
            if prob < severity/100
                df1.nCones = df1.nCones+ sign(rand*2-1);
            end
            
            if df1.nCones < df1.conesRange(1)
                df1.nCones = df1.conesRange(1)+1;
            elseif df1.nCones > df1.conesRange(2)
                df1.nCones = df1.conesRange(2)-1;
            end
        end
        
            
    end
end
