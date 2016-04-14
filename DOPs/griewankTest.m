function fit = griewankTest(pos)
                s1=0;s2=1;
%     s1 = sum(pos.^2)/4000;
%     s2 = prod(cos(pos)/sqrt(1:size(pos,1)));
                for i = 1:size(pos,2)
                    s1 = s1+ (pos(1,i).^2)/4000;
                    s2 = s2*cos(pos(1,i)/sqrt(i));
                end
    fit = s1-s2+1;
end