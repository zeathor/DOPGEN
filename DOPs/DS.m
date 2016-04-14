classdef DS < handle
    %% Dynamic Sphere - Class version
    
    %ds = DynamicSphere(2);
    
    properties
        C;
        nDim;
        domain = [-5,5];
        typeDOP = 'lt'; % minimisation problem
        posC;
        nPos;
        LS;
        si;
        CS;
        DeltaN; % environmental change index (only used for circular motion
        tau;
    end
    
    methods
        
        
        function ds = DS(nDim, nPos)
            %% constructor
            ds.C = rand(1,nDim)*6-3;
            if nargin < 1
                ds.nPos = 1000*100;
                ds.nDim = 2;
            elseif nPos > 100
                ds.nPos = nPos*100;
                ds.nDim = nDim;
            else
                ds.nPos = 100*100;
                ds.nDim = nDim;
            end
            
            ds.posC = repmat(ds.C, ds.nPos, 1);
            ds.LS = [];
            ds.DeltaN = 0;
            ds.LS = [];
            ds.CS = [];
            ds.tau = [];
            
            %% initialise movement directions
            ds.si = round(randi(2,1,ds.nDim)*2-3);
        end
        
        function fitness = calc(ds,pos)
            fitness = sum((pos -  ds.posC(1:size(pos,1),:)).^2,2);
        end
        
        function CS = getCS(ds)
            CS = ds.C;
        end
        
        function setCS(ds,C)
            ds.C = C;
            ds.posC = repmat(ds.C, ds.nPos, 1);
        end
        
        function reset(ds)
            ds.C = rand(1,ds.nDim)*6-3;
            ds.posC = repmat(ds.C, ds.nPos, 1);
            
        end
        
        function [x,y,fitness] = graphDOP(ds)
            x = linspace(ds.domain(1),ds.domain(2),100);
            y = x;
            
            pos = [];
            for i = length(x):-1:1
                for j = length(y):-1:1
                    pos((i-1)*length(x)+(j),:) = [x(i) y(j)];
                end
            end
            fitness = ds.calc(pos);
        end
        
        function linearGOM(ds, severity)
            if isempty(ds.LS)
                ds.LS(1,1:(ds.nDim/2)) = severity;
                ds.LS(1,(ds.nDim/2)+1:ds.nDim) = rand(1,ds.nDim/2)/2 * severity;
            end
            delta = ds.C + ds.LS.*ds.si;
            %% find the dimensions too big
            idxBig = delta > ds.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (ds.domain(2) - ds.C(:,idxBig))*2 - delta(idxBig) + 2*ds.C(:,idxBig);
                ds.si(idxBig) = ds.si(idxBig)*-1;
            end
            %% find the dimensions too small
            idxSmall = delta < ds.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (ds.domain(1) -  ds.C(:,idxSmall))*2 - delta(idxSmall) +2*ds.C(:,idxSmall);
                % mpb.C(mpb.sidx,idxSmall)
                ds.si(idxSmall) = ds.si(idxSmall)*-1;
            end
            ds.C = delta;
            
            ds.posC = repmat(ds.C, ds.nPos, 1);
            
        end
        
        function circularGOM(ds, severity)
            if isempty(ds.CS)
                SC = severity(1);
                Stau = severity(2);
                
                ds.CS(1,1:(ds.nDim/2)) = (ds.domain(2)-ds.domain(1))/100 * (5 - SC);
                ds.CS(1,(ds.nDim/2)+1:ds.nDim) = (ds.domain(2)-ds.domain(1))/100 *5;
                ds.tau(1,1:(ds.nDim/2)) = 25;
                ds.tau(1,(ds.nDim/2)+1:ds.nDim) = 25 - Stau;
            end
            ds.DeltaN = ds.DeltaN + 1;
            temp = ds.C;
            delta = zeros(1,ds.nDim);
            for i = 1:ds.nDim
                if mod(i,2)
                    delta(i) = ds.CS(i).*sin(2*pi.*ds.DeltaN./(ds.tau(i)));
                else
                    delta(i) = ds.CS(i).*cos(2*pi.*ds.DeltaN./(ds.tau(i)));
                end
            end
            
            ds.C = temp + delta;
            ds.posC(:,:) = repmat(ds.C,ds.nPos,1);
            
        end
        
        
        function randomGOM(ds, severity)
            delta = (rand(1,ds.nDim)*2 -1)*(severity) * (ds.domain(2)-ds.domain(1))/100 + ds.C;
            %% find the dimensions too big
            idxBig = delta > ds.domain(2);
            if(sum(idxBig))
                delta(idxBig) = (ds.domain(2) - ds.C(:,idxBig))*2 - delta(idxBig) + 2*ds.C(:,idxBig);
            end
            %% find the dimensions too small
            idxSmall = delta < ds.domain(1);
            if(sum(idxSmall))
                delta(idxSmall) = (ds.domain(1) -  ds.C(:,idxSmall))*2 - delta(idxSmall) +2*ds.C(:,idxSmall);
                
            end
            ds.C = delta;
            
            ds.posC = repmat(ds.C, ds.nPos, 1);
            
        end
        
        
        
    end
    
end