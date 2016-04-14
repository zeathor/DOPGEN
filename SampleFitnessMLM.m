function [MLM] = SF(DOP, pos)
%% This is the MLM for sample fitness. 
% simple, huh?
    MLM = DOP.calc(pos);
end

