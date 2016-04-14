
delta = [0 0];
Spercent = 0;
temp = 1:0.1:250;
tau = 25;
figure
hold all
pos = zeros(251,2);
for k = 0:5:20
for i = 1:length(temp)
   
    for j = 1:2
        if mod(j,2)
            delta(j) = 5.*sin(2*pi*temp(i)/(25));
        else
            delta(j) = (5).*cos(2*pi*temp(i)/(25-k));
        end
    end
     pos(i+1,:) = pos(i,:) + delta;
end

plot(pos(2:end,1)',pos(2:end,2)','linewidth', 3);

end


