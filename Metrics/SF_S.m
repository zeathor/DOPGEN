function [MLM] = SF_S(DOP, pos, dynSettings, dim, dynamic,DOPLength,DOPStrm)
%% This is the MLM for sample fitness. 
% simple, huh?
DOPidx = 1;

MLM.base = zeros(DOPLength,length(pos));

classDOP = class(DOP);
count = 0;
for i = 1:DOPLength
    
    if i > 1
        fprintf(1, repmat('\b',1,count)); %delete line before
        count = fprintf('%s: SF iter %3.2f%%',classDOP,i/DOPLength*100);
    end
        
    if(numel(DOP) > 1)
        MLM.base(i,:) = DOP{DOPidx}.calc(pos);
    else
        MLM.base(i,:) = DOP.calc(pos);
    end
        %% sometimes you need to modify the position matrix
    [pos, DOPidx] = dynamic(DOP, pos, dynSettings, dim,i, DOPidx,DOPStrm);
end
fprintf('');

end

