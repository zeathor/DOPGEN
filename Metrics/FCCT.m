function [MLM] = FCCT(DOP, pos, dynSettings, dim, dynamic,DOPLength)
%% This is the MLM for sample fitness. 
% simple, huh?
base = zeros(250,length(pos));
DOPidx = 1;

classDOP = class(DOP);
count = 0;
for i = 1:DOPLength
    
    if i > 1
        fprintf(1, repmat('\b',1,count)); %delete line before
        count = fprintf('%s: FCCT iter %3.2f%%',classDOP,i/DOPLength*100);
    end
    
    if(numel(DOP) > 1)
        base(i,:) = DOP{DOPidx}.calc(pos);
    else
        base(i,:) = DOP.calc(pos);
    end
    
    
    if i > 1
       MLM.base(i-1) = corr2(base(i,:), base(i-1,:)); 
    end
    
    %% sometimes you need to modify the position matrix
    [pos, DOPidx] = dynamic(DOP, pos, dynSettings, dim,i, DOPidx);
end
end