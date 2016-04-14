function fit = rastriginSlow(pos)
    d = size(pos,2);
    sum = 0;
    for i = 1:d
        sum = sum + (pos(:,i).^2 - 10*cos(2*pi*pos(:,i)));
    end
    
    fit = 10*d + sum;
end