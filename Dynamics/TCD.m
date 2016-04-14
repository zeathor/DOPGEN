function [ pos, DOPidx] = TCD(DOP, pos, S, dim,iter, DOPidx)
%% This implements the Positional Change Metric
%
persistent posOffset maxOff minOff origPos;

if (iter == 1) || isempty(posOffset)
    origPos = pos;
    posOffset = zeros(1,min(size(pos)));
       
    maxOff = (DOP.domain(2) - DOP.domain(1))/2;
    minOff = -maxOff;
end



% delta = (S/100)*(DOP.domain(2)-DOP.domain(1));
delta = (DOP.domain(2) - DOP.domain(1))/100 * S * (rand(1,dim)*2-1);
%% execute the dynamic
for j = 1:dim
    if((posOffset(j) + delta(j)) > maxOff)
        posOffset(j) = 2*(maxOff - posOffset(j)) - delta(j) + posOffset(j);
    elseif((posOffset(j) + delta(j)) < minOff)
        posOffset(j) = 2*(minOff - posOffset(j)) - delta(j) + posOffset(j);
    else
        posOffset(j) = posOffset(j) + delta(j);
    end
end
pos = bsxfun(@plus,origPos,posOffset);

end

