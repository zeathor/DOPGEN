function fit = griewankSpeed(pos)
    pos = pos';
%     s1=zeros(1,size(pos,2));s2=ones(1,size(pos,2));
    
    s1 = sum(pos.^2)/4000;
    ith = 1:size(pos,1); 
    new = bsxfun(@rdivide,pos,sqrt(ith)');
    s2 = prod(cos(new));
    
    fit = s1-s2+1;
    
end