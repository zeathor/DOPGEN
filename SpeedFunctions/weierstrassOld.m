function f = weierstrassOld(x)
    [~,D] = size(x);
    x = x+0.5;
    a = 0.5;
    b = 3;
    kmax = 20;
    c1(1:kmax+1) = a.^(0:kmax);
    c2(1:kmax+1) = 2*pi*b.^(0:kmax);
    f = 0;
    c = -w(0.5,c1,c2);
    for i = 1:D
        f = f + w( x(:,i)', c1, c2 );
    end
    f = f + c*D;
end

function y = w(x,c1,c2)
y = zeros(length(x),1);
for k = 1:length(x)
	y(k) = sum( c1.*cos( c2.*x(:,k) ) );
end
end