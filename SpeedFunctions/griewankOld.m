function fit = griewankOld(pos)
    s1=0;s2=1;
    for i = 1:size(pos,2)
        s1 = s1+ (pos(:,i).^2)/4000;
        s2 = s2.*cos(pos(:,i)/sqrt(i));
    end
    fit = s1-s2+1;
end