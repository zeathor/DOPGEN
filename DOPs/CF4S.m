classdef CF4 < handle
    %% CF4 - Class version
    
    %cf4 = CF4(10, 3, 3, 2, 5, 2,101*101);
    
    properties
        nFunc;
        funcRange = [5,15]
        O;
        H;
        nDim;
        domain = [-5,5];
        typeDOP = 'gt'; % just to let us know this is a maximisation problem
        posO = []; % for optimisation only
        nPos;   % same reason as above
        bias;
        sigma;
        lambda;
        c;
        M;
        func;
        pHeight = [];
    end
    
    methods
        
        function cf4 = CF4(hMin, hMax, nDim, nPos)
            %% constructor
            if(nargin < 4)
                cf4.nDim = 2;
                cf4.pHeight(1) = -0; cf4.pHeight(2) = -100;
                cf4.nPos = 50*1000;
            else
                cf4.nDim = nDim;
                cf4.pHeight(1) = -hMin; cf4.pHeight(2) = -hMax;
                if nPos < 100*100
                    cf4.nPos = 100*100;
                else
                    cf4.nPos = nPos;
                end
                
            end
            cf4.nFunc = 8;
            cf4.O = cf4.domain(1) + (cf4.domain(2)-cf4.domain(1))*rand(cf4.nFunc,cf4.nDim);
            cf4.bias = rand(1,cf4.nFunc)*(cf4.pHeight(2)-cf4.pHeight(1))+cf4.pHeight(1);
            cf4.sigma = [1,1,1,1,1,2,2,2];
            lambda1 = [4; 1; 4; 1; 1/10; 1/5; 1/10; 1/40];
            cf4.func.f1 = str2func('Frastrigin');
            cf4.func.f2 = str2func('Frastrigin');
            cf4.func.f3 = str2func('FEF8F2');
            cf4.func.f4 = str2func('FEF8F2');
            cf4.func.f5 = str2func('Fweierstrass');
            cf4.func.f6 = str2func('Fweierstrass');
            cf4.func.f7 = str2func('Fgriewank');
            cf4.func.f8 = str2func('Fgriewank');
     
            cf4.c = ones(1,cf4.nFunc);
            for i = 1:cf4.nFunc
                eval(['MT.M' int2str(i) '= cf4.RotMatrixCondition( cf4.nDim);']);
                cf4.posO(:,:,i) = repmat(cf4.O(i,:),cf4.nPos,1);
                cf4.lambda(:,:,i) = repmat(lambda1(i),cf4.nPos,cf4.nDim);
            end
            cf4.M = MT;           
        end
        
        function reset(cf4)
            cf4.O = cf4.domain(1) + (cf4.domain(2)-cf4.domain(1))*rand(cf4.nFunc,cf4.nDim);
            cf4.bias = rand(1,cf4.nFunc)*(cf4.pHeight(2)-cf4.pHeight(1))+cf4.pHeight(1);
            
            cf4.c = ones(1,cf4.nFunc);
            for i = 1:cf4.nFunc
                eval(['MT.M' int2str(i) '= cf4.RotMatrixCondition( cf4.nDim);']);
                cf4.posO(:,:,i) = repmat(cf4.O(i,:),cf4.nPos,1);
            end
            
            cf4.M = MT;
        end
        
        function fit = calc(cf4, pos)
            
            [ps,D] = size(pos);
            for i = cf4.nFunc:-1:1
                W(:,i) = exp( -sum( (pos-cf4.posO(1:ps,:,i)).^2, 2 )./2./( D * cf4.sigma(i)^2 ) );
            end
            
            wmax = max(W,[],2);
            tempWmax = wmax(:,ones(1,cf4.nFunc));
            W(W ~= tempWmax) = W(W ~= tempWmax).*(1-tempWmax(W ~= tempWmax).^10);
            sumW = sum(W,2);
            W = bsxfun(@rdivide,W,sumW);
            
            
            res = 0;
            for i = 1:cf4.nFunc
                
                eval(['f = feval(cf4.func.f' int2str(i) ',((pos-cf4.posO(1:ps,:,i))./cf4.lambda(1:ps,:,i))*cf4.M.M' int2str(i) ');']);
                x1 = 5*ones(1,D);
                eval(['f1 = feval(cf4.func.f' int2str(i) ',(x1./cf4.lambda(1,:,i))*cf4.M.M' int2str(i) ');']);
                fit1 = 2000 .* f ./ f1;
                res = res + W(:,i) .* ( fit1 + cf4.bias(i) );
            end
            fit = -res;
            
        end
        
        function M = RotMatrixCondition(cf4,D)
            P = cf4.LocalGramSchmidt(randn(D));
            Q = cf4.LocalGramSchmidt(randn(D));
            D = diag(ones(1,D));
            M = P*D*Q;
        end
        
        function [q,r] = LocalGramSchmidt(cf4,A)
            % computes the QR factorization of $A$ via
            % classical Gram Schmid
            
            [n,m] = size(A);
            q = A;
            for j=1:m
                for i=1:j-1
                    r(i,j) = q(:,j)'*q(:,i);
                end
                for i=1:j-1
                    q(:,j) = q(:,j) -  r(i,j)*q(:,i);
                end
                t =  norm(q(:,j),2 ) ;
                q(:,j) = q(:,j) / t ;
                r(j,j) = t  ;
            end
        end
        
        function [x,y,fitness] = graphDOP(cf4)
            x = linspace(cf4.domain(1),cf4.domain(2),100);
            y = x;
            
            pos = [];
            for i = length(x):-1:1
                for j = length(y):-1:1
                    pos((i-1)*length(x)+(j),:) = [x(i) y(j)];
                end
            end
            
            fitness = cf4.calc(pos);
        end
        
        
        function stepChangeLarge(cf4, alpha, alphaMax, S)
            %% this function alters the heights and the optima positions
            oldO = cf4.O;
            oldBias = cf4.bias;
            
            theRand = rand(cf4.nFunc,cf4.nDim);
            deltaO = (S).*((alpha.*sign(theRand)) + (alphaMax-alpha).*theRand).*(cf4.domain(2)-cf4.domain(1));
            deltaO = oldO + deltaO;
            
            deltaO(deltaO > (cf4.domain(2))) = 2*(cf4.domain(2)) - deltaO(deltaO > (cf4.domain(2)));
            deltaO(deltaO < cf4.domain(1)) = 2*cf4.domain(1) - deltaO(deltaO < cf4.domain(1));
            cf4.O = deltaO;
            
            for i = 1:cf4.nFunc
                cf4.posO(:,:,i) = repmat(cf4.O(i,:),cf4.nPos,1);
            end
            
            
            theRand = rand(1,cf4.nFunc);
            deltaB = oldBias+S.*((alpha.*sign(theRand)) + (alphaMax-alpha).*theRand).*(cf4.pHeight(2)-cf4.pHeight(1));
            
            deltaB(deltaB < (cf4.pHeight(2))) = 2*(cf4.pHeight(2)) - deltaB(deltaB < (cf4.pHeight(2)));
            deltaB(deltaB > cf4.pHeight(1)) = 2*cf4.pHeight(1) - deltaB(deltaB > cf4.pHeight(1));
            cf4.bias = deltaB;
            
        end
        
        function stepChangePeakFunction(cf4, S)
            S = 'X GON GIVE IT TO YA!';
            
            
            %% at the end, call stepChangeGradual
            stepChangeGradual(cf4,5);
        end
        
        function stepChangeGradual(cf4,severity)
            s = severity/100;
            %% alter the optimum centres first
            oldO = cf4.O;
            oldBias = cf4.bias;
            
            deltaO = s*(rand(cf4.nFunc,cf4.nDim)*2-1)*(cf4.domain(2)-cf4.domain(1)) + cf4.O(1:cf4.nFunc,:);
            deltaO(deltaO > cf4.domain(2)) = 2*cf4.domain(2) - deltaO(deltaO > cf4.domain(2));
            deltaO(deltaO < cf4.domain(1)) = 2*cf4.domain(1) - deltaO(deltaO < cf4.domain(1));
            
            cf4.O(1:cf4.nFunc,:) = deltaO;
            for i = 1:cf4.nFunc
                cf4.posO(:,:,i) = repmat(cf4.O(i,:),cf4.nPos,1);
            end
            
            
            %% alter the heights second
            
            deltaB = oldBias + s*(rand(cf4.nFunc,1)*2-1)*(cf4.pHeight(2)-cf4.pHeight(1));
            deltaB(deltaB > (cf4.pHeight(2))) = 2*(cf4.pHeight(2)) - deltaB(deltaB > (cf4.pHeight(2)));
            deltaB(deltaB < cf4.pHeight(1)) = 2*cf4.pHeight(1) - deltaB(deltaB < cf4.pHeight(1));
            
            cf4.bias = deltaB;
            
           
        end
        
        
        
    end
end
