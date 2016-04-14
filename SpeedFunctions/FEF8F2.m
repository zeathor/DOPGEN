function fit = FEF8F2(pos)
    [~,D] = size(pos);
    fit = 0;
    for i = 1:(D-1)
        fit = fit + F8F2( pos(:,[i,i+1])+1 );     % (1,...,1) is minimum
    end
    fit = fit + F8F2( pos(:,[D,1]) +1 );           % (1,...,1) is minimum
end

function f = F8F2(x)
    f2 = 100.*(x(:,1).^2-x(:,2)).^2+(1-x(:,1)).^2;
    f = 1+f2.^2./4000-cos(f2);
end