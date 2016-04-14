function [landscape1, x] = FieldOfCones(nCones, hMin, hRange, rMin, rRange, nPoints)

% generates the DF1 landscape, 2 dimensions. Ranges from -1 to 1;
%[z,x] = FieldOfCones(1, 3, 3, 2, 5, 100);
%[z,x] = FieldOfCones(50, 1, 9, 8, 12, 101);

C = rand(2,nCones)*2 -1;
H = hMin+rand(1,nCones)*hRange;
R = rMin+rand(1,nCones)*rRange;

% need to create a landscape for each cone, then take max for each


x = linspace(-1,1,nPoints);
y = x;
for i = 1:nCones
    for xi = 1:nPoints
        for yi = 1:nPoints
            landscape1(xi,yi,i) = H(i) - R(i)*sqrt(((x(xi)-C(1,i))^2 + (y(yi)-C(2,i))^2));
        end
    end
end

M2 = max(landscape1,[],3);

figure;
surf(x,x,M2);

end

