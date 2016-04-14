function fit = Fgriewank(pos)
    s1=zeros(size(pos,1),1);s2=ones(size(pos,1),1);
    for i = 1:size(pos,2)
        s1 = s1+ (pos(:,i).^2)/4000;
        s2 = s2.*cos(pos(:,i)/sqrt(i));
    end
    fit = s1-s2+1;
end