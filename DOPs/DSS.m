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
    end
    
    methods
        
        
        function ds = DS(nDim, nPos)
            %% constructor
            ds.C = rand(1,nDim)*6-3;
            ds.posC = repmat(ds.C, nPos, 1);
            
            ds.nDim = nDim;
            ds.nPos = nPos;
            
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
        
        
        
    end
    
end