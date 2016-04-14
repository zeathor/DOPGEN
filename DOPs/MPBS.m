classdef MPBS < handle
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
        
        %% Note that this is the only difference between CGF prime and this. We have an independent random number stream.
        strm;
    end
    
    methods
        
        
        function mpb = MPBS(DOPStrm,nPoints)
            %% constructor
            mpb.nCones = 50;
            mpb.pHeight(1) = 30;    mpb.pHeight(2) = 70;
            mpb.pWidth(1) = 1;      mpb.pWidth(2) = 12;
            mpb.nDim = 2;
            if (nPoints) > 1e6
                mpb.nPos = 1e6;
            else
                mpb.nPos = nPoints;
            end
            
            mpb.strm = DOPStrm;
            
            mpb.C = rand(mpb.strm,mpb.nCones,mpb.nDim)*100;
            mpb.H = mpb.pHeight(1)+rand(mpb.strm,mpb.nCones,1)*(mpb.pHeight(2) - mpb.pHeight(1));
            mpb.W = mpb.pWidth(1)+rand(mpb.strm,mpb.nCones,1)*(mpb.pWidth(2) - mpb.pWidth(1));
            [~,mpb.sidx] = max(mpb.H); % locate the max peak
            % relocate max peak to at least somewhere in the centre half
            mpb.C(mpb.sidx,:) = rand(mpb.strm,1,mpb.nDim)*((mpb.domain(2)-mpb.domain(1))/2) + ((mpb.domain(2)-mpb.domain(1))/4);
            mpb.si = round(randi(mpb.strm,2,1,mpb.nDim)*2-3); %randomly set the global optimum movement direction
            mpb.LS = [];
            mpb.CS = [];
            for i = 1:mpb.nCones
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            mpb.DeltaN = 0;
        end
        
        function reset(mpb)
            mpb.C = rand(mpb.strm,mpb.nCones,mpb.nDim)*max(mpb.domain);
            mpb.C(mpb.sidx,:) = rand(mpb.strm,1,mpb.nDim)*((mpb.domain(2)-mpb.domain(1))/2) + ((mpb.domain(2)-mpb.domain(1))/4);
            mpb.H = mpb.pHeight(1) + rand(mpb.strm,mpb.nCones,1)*(mpb.pHeight(2) - mpb.pHeight(1));
            mpb.W = mpb.pWidth(1) + rand(mpb.strm,mpb.nCones,1)*(mpb.pWidth(2) - mpb.pWidth(2));
            for i = 1:mpb.nCones
                mpb.posC(:,:,i) = repmat(mpb.C(i,:),mpb.nPos,1);
            end
            
            mpb.LS = [];
            mpb.tau = [];
            mpb.CS = [];
            mpb.DeltaN = 0;
        end
        
           
        function fitness = calc(mpb,pos)
            
            %% some optimisation, we can't store as much as we'd like
            if length(pos) <= 1e6
                for i = mpb.nCones:-1:1
                    dummy(:,i) = mpb.H(i) - mpb.W(i).*(sum((pos-mpb.posC(1:size(pos,1),:,i)).^2,2));
                end
                fitness = max(dummy,[],2);
            else
                fitness = zeros(size(pos));
                idx = 1;
                while length(fitness ) ~= length(pos)
                    endPoint = idx+1e6;
                    if endPoint > (length(pos)+1)
                        endPoint = length(pos)+1;
                    end
                    
                    for i = mpb.nCones:-1:1
                        dummy(:,i) = mpb.H(i) - mpb.W(i).*(sum((pos(idx:endPoint-1,:)-mpb.posC(1:(endPoint-idx),:,i)).^2,2));
                    end
                    fitness(idx:endPoint-1,:) =  max(dummy,[],2);
                    idx = idx + 1e6;
                end
                
            end
                
                
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
            fitness = zeros(100);
            for i = 1:length(x)
                for j = 1:length(y)
                    fitness(i,j) = mpb.calc([x(i) y(j)]);
                end
            end
            figure
            surf(x,y,fitness);
            
        end

        
    end
    
end

