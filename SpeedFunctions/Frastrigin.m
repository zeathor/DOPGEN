function fit = Frastrigin(pos)
    fit = sum(pos.^2 - 10*cos(2*pi*pos),2)+ 10*size(pos,2);
end