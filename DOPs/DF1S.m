classdef DF1S < handle
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
        
        %% Note that this is the only difference between CGF prime and this. We have an independent random number stream.
        strm;
    end
    
    methods
        
        function df1 = DF1S(DOPStrm,nPoints)
            %% constructor
            df1.strm = DOPStrm;
            df1.pHeight(1) = 1; df1.pHeight(2) = 20;
            df1.pWidth(1) = 40; df1.pWidth(2) = 100;
            df1.nDim = 2;
            df1.nCones = 20;
            if (nPoints) > 1e6
                df1.nPos = 1e6;
            else
                df1.nPos = nPoints;
            end
            df1.C = rand(df1.strm,df1.nCones,df1.nDim)*2 -1;
            df1.H = df1.pHeight(1)+rand(df1.strm,df1.nCones,1)*(df1.pHeight(2) - df1.pHeight(1));
            df1.W = df1.pWidth(1)+rand(df1.strm,df1.nCones,1)*(df1.pWidth(2) - df1.pWidth(1));

            [~,df1.sidx] = max(df1.H); % locate the max peak
            % relocate max peak to at least somewhere in the centre half
            df1.C(df1.sidx,:) = rand(df1.strm,1,df1.nDim)*((df1.domain(2)-df1.domain(1))/2) + ((df1.domain(2)-df1.domain(1))/4)+df1.domain(1);

            for i = 1:df1.nCones
                thePos = df1.C(i,:);
                df1.posC(:,:,i) = thePos(ones(1,df1.nPos ),:);
            end
            
        end
          
        function reset(df1)
            df1.C = rand(df1.strm,df1.nCones,df1.nDim)*2 -1;
            df1.H = df1.pHeight(1)+rand(df1.strm,df1.nCones,1)*(df1.pHeight(2)-df1.pHeight(1));
            df1.W = df1.pWidth(1)+rand(df1.strm,df1.nCones,1)*(df1.pWidth(2)-df1.pWidth(1));
            
            [~,df1.sidx] = max(df1.H); % locate the max peak
            % relocate max peak to at least somewhere in the centre half
            df1.C(df1.sidx,:) = rand(df1.strm,1,df1.nDim)*((df1.domain(2)-df1.domain(1))/2) + ((df1.domain(2)-df1.domain(1))/4)+df1.domain(1);
            
            for i = 1:df1.nCones
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
        end
        
        
        
        function fitness = calc(df1,pos)
            if length(pos) <= 1e6
                for i = df1.nCones:-1:1
                    dummy(:,i) = df1.H(i) - df1.W(i).*sqrt(sum((pos-df1.posC(1:size(pos,1),:,i)).^2,2));
                end
                fitness = max(dummy,[],2);
            else
                fitness = [];
                idx = 1;
                while length(fitness) ~= length(pos)
                    endPoint = idx+1e6;
                    if endPoint > length(pos)
                        endPoint = length(pos);
                    end
                    
                    for i = df1.nCones:-1:1
                        dummy(:,i) = df1.H(i) - df1.W(i).*sqrt(sum((pos(idx:endPoint-1,:)-df1.posC(1:(endPoint-idx),:,i)).^2,2));
%                         dummy(:,i) = mpb.H(i) - mpb.W(i).*(sum((pos(idx:endPoint-1,:)-mpb.posC(1:(endPoint-idx),:,i)).^2,2));
                    end
                    fitness = [fitness;max(dummy,[],2)];
                    idx = idx + 1e6;
                end
                
                
            end
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
%             figure
%             contour(x,y,fitness);
            figure
            surf(x,y,fitness);
            
            
        end
        
        function stepChangeRandom(df1,severity)
            s = severity;
            
            %% do centres first
            deltaC = s*randn(df1.strm,df1.nCones, df1.nDim)*(df1.domain(2)-df1.domain(1))/100+df1.C;
            
            deltaC(deltaC > df1.domain(2)) = 2*df1.domain(2) - deltaC(deltaC > df1.domain(2));
            deltaC(deltaC < df1.domain(1)) = 2*df1.domain(1) - deltaC(deltaC < df1.domain(1));
            
            df1.C = deltaC;
            for i = 1:df1.nCones
                df1.posC(:,:,i) = repmat(df1.C(i,:),df1.nPos,1);
            end
            
            %% do heights
            deltaH = s*randn(df1.strm,df1.nCones,1)*(df1.pHeight(2)-df1.pHeight(1))/100+df1.H;
            
            deltaH(deltaH > df1.pHeight(2)) = 2*(df1.pHeight(2)) - deltaH(deltaH > df1.pHeight(2));
            deltaH(deltaH < df1.pHeight(1)) = 2*(df1.pHeight(1)) - deltaH(deltaH < df1.pHeight(1));
            
            df1.H = deltaH;
            
            
            %% do widths
            deltaW = s*randn(df1.strm,df1.nCones,1)*(df1.pWidth(2)-df1.pWidth(1))/100+df1.W;
            
            deltaW(deltaW > df1.pWidth(2)) = 2*(df1.pWidth(2)) - deltaW(deltaW > df1.pWidth(2));
            deltaW(deltaW < df1.pWidth(1)) = 2*(df1.pWidth(1)) - deltaW(deltaW < df1.pWidth(1));
            
            df1.W = deltaW;
        end
        
    end
end
