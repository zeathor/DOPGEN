function fit = griewankSpeed2(pos)
[~,D] = size(pos);
fit = 1;
for i = 1:D
	fit = fit.*cos( pos(:,i)./sqrt(i) );
end
fit = sum( pos.^2, 2)./4000 - fit + 1;
    
end

