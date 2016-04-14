function fit = Fweierstrass(pos)
    persistent kmax a b ak bk part2;
    if isempty(kmax)
        kmax= 20;
        a = 0.5;
        b = 3;
        ak = a.^(0:kmax);
        bk = b.^(0:kmax).*2.*pi;
        part2 = sum(ak.*cos(bk.*0.5));
    end
    [p,d] = size(pos);
    
    dummy = zeros(p,1);
    for i = 1:d
        dummy = dummy + sum(bsxfun(@times,ak,cos(bsxfun(@times,(pos(:,i)+0.5),bk))),2);
    end
    
    fit = dummy - d.*part2;
    
end