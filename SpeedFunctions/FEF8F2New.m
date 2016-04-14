%------------------------------------------------------------------------------
% FEF8F2 Function
%------------------------------------------------------------------------------
function fit = FEF8F2New(pos)
    [~,D] = size(pos);
    fit = 0;
    for i = 1:(D-1)
        fit = fit + F8F2Old( pos(:,[i,i+1])+1 );     % (1,...,1) is minimum
    end
    fit = fit + F8F2Old( pos(:,[D,1]) +1 );           % (1,...,1) is minimum
end