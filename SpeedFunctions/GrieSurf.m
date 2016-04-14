
function [M1] = GrieSurf(nPoints)

x = linspace(-100,100,nPoints);
y = x;

for i = 1:length(x)
    for j = 1:length(x)
        M1(i,j) = Griewank([x(i) y(j)]);
    end
end


figure('units','normalized','outerposition',[0 0 1 1]);
surf(x,x,M1);

end

function  [y] = Griewank(xx)

d = length(xx);
sum = 0;
prod = 1;

for ii = 1:d
	xi = xx(ii);
	sum = sum + xi^2/4000;
	prod = prod * cos(xi/sqrt(ii));
end

y = sum - prod + 1;

end

