classdef CGFS < handle
    %% This is the CGF DOP, modified to handle a unique random number stream. There are no dynamics instituted as all we are testing 
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
        
        %% Note that this is the only difference between CGF prime and this. We have an independent random number stream.
        strm;
    end
    
    methods
        
        function cgf = CGFS(DOPStrm,nPoints)
            cgf.strm = DOPStrm;
            cgf.nFunc = 10;
            cgf.nDim = 2;
            cgf.fHeight(1) = 10;
            cgf.fHeight(2) = 100;
            
            cgf.nPos = nPoints;
            
            cgf.stretchS = ones(1,cgf.funcRange(2))*(cgf.domain(2)-cgf.domain(1))/(cgf.funcDomain(2)-cgf.funcDomain(1));
            cgf.convergeS = ones(1,cgf.funcRange(2));
            cgf.funcRotMat = zeros(cgf.nDim, cgf.nDim,cgf.funcRange(2));
            cgf.setRotationMatrix;
            cgf.O = rand(cgf.strm,cgf.funcRange(2),cgf.nDim)*10-5;
            
            for i = 1:cgf.funcRange(2)
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos ,1);
            end
            
            cgf.setFMax;
            cgf.H = rand(cgf.strm,cgf.funcRange(2),1)*(cgf.fHeight(2)-cgf.fHeight(1))+cgf.fHeight(1);
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);
            [~,cgf.sidx] = min(cgf.H(1:cgf.nFunc,1)); % locate the min peak out of the set peaks
            cgf.si = round(randi(cgf.strm,2,1,cgf.nDim)*2-3); %randomly set the global optimum movement direction
            cgf.S = [];
            
        end

        function reset(cgf)
            
            cgf.setRotationMatrix;
            cgf.O = rand(cgf.strm,cgf.funcRange(2),cgf.nDim)*10-5;
            for i = 1:cgf.nFunc
                cgf.posO(:,:,i) = repmat(cgf.O(i,:),cgf.nPos,1);
            end
            cgf.H = rand(cgf.strm,cgf.funcRange(2),1)*(cgf.fHeight(2) - cgf.fHeight(1))+cgf.fHeight(1);
            cgf.hExp = repmat(cgf.H,1,cgf.nPos);
            [~,cgf.sidx] = min(cgf.H); % locate the min peak
            cgf.si = round(randi(cgf.strm,2,1,cgf.nDim)*2-3); %randomly set the global optimum movement direction
            cgf.S = [];
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
            d = randperm(cgf.strm,cgf.nDim);
            for i = 1:cgf.funcRange(2)
                cgf.funcRotMat(:,:,i) = eye(cgf.nDim,cgf.nDim);
                for j = 1:2:(cgf.nDim-1)
                    theta = 2*pi*rand(cgf.strm);
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




