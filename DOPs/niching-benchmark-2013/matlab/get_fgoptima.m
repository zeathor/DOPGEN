% ******************************************************************************
% * Version: 1.0
% * Last modified on: 21 January, 2013 
% * Developers: Michael G. Epitropakis, Xiaodong Li.
% *      email: mge_(AT)_cs_(DOT)_stir_(DOT)_ac_(DOT)_uk 
% *           : xiaodong_(DOT)_li_(AT)_rmit_(DOT)_edu_(DOT)_au 
% * ****************************************************************************

function [fit] = get_fgoptima(nfunc)
fgoptima = [200.0 1.0 1.0 200.0 1.03163 186.731 1.0 2709.0935 1.0 -2.0 zeros(1,10)];
fit = fgoptima(nfunc);
