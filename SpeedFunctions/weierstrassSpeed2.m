function fit = weierstrassSpeed2(pos)
    
    a  = 0.5;
    b = 3;
    n = 20;
        fit = sum(bsxfun(@times, a.^(0:n), cos(pi*bsxfun(@times, b.^(0:n), pos(:)+0.5))), 2); 
end
