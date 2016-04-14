function [dynSettings] = setDynamicArrays(varargin)
    %% This function returns a dynamic range cell array and dynamic list cell array  based on the
    dynSettings = [];
    for i = nargin:-1:1
        dynSettings(1,i).dynamic = varargin{i};
        switch varargin{i}
            case {'TCD','TRCD', 'RGOM','SCR'}
%                 dynSettings(1,i).dynRange = 1:25;
                                dynSettings(1,i).dynRange = [1 5 10 15 20 25];
                dynSettings(1,i).DOP = str2func('DF1');
            case{'TRCD_S','SCR_S'}
                dynSettings(1,i).dynRange = 1:2:25;
                dynSettings(1,i).DOP = str2func('DF1S');
            case {'RCD' ,'RCDF' ,'RCDFix','RCDR','RCDS'}
%                 dynSettings(1,i).dynRange = pi/16:pi/16:pi;
                dynSettings(1,i).dynRange = [1 2 4 8 16];
%                 dynSettings(1,i).DOP = str2func('MPB');
            case {'RCDF_S'}
                dynSettings(1,i).dynRange = pi/16:pi/16:pi;
                dynSettings(1,i).DOP = str2func('DF1S');
            case {'CGOMEllip'}
                dynSettings(1,i).dynRange = [0.5:0.5:4.5; zeros(1,length(0.5:0.5:4.5))];
                dynSettings(1,i).DOP = str2func('CGF');
            case {'CGOMCHM'}
                dynSettings(1,i).dynRange = [zeros(1,length([4 5 8 10 12 15 16 20 24])); [4 5 8 10 12 15 16 20 24]];
                dynSettings(1,i).DOP = str2func('CGF');
            case {'AM'}
                dynSettings(1,i).dynRange = 0.5:0.5:5;
                dynSettings(1,i).DOP = str2func('DF1');
            case {'SCG','LGOM'}
                dynSettings(1,i).dynRange = [1 5 10 15 20 25];
%                 dynSettings(1,i).dynRange = 1:25;
                dynSettings(1,i).DOP = str2func('CGF');
            case 'SCL'
%                 dynSettings(1,i).dynRange = 0.5:0.5:10;
                dynSettings(1,i).dynRange = [0.5 2.5 5 7.5 10];
                dynSettings(1,i).DOP = str2func('CF4');
            case 'SCPF'
                dynSettings(1,i).dynRange = 5:5:100;
                dynSettings(1,i).DOP = str2func('CGF');
            case {'RSS1','RSS2'}
                dynSettings(1,i).dynRange = 6:4:50;
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('CGF');
                end
            case {'RSG1','RSG2'}
                dynSettings(1,i).dynRange = [5:5:50;1:0.5:5.5];
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('MPB');
                end
            case {'RSQR1','RSQR2'}
                dynSettings(1,i).dynRange = 6:4:50;
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('MPB');
                end
            case {'RSR1','RSR2'}
                dynSettings(1,i).dynRange = 6:4:50;
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('MPB');
                end
            case {'RSRG1','RSRG2','RSRG1_S'}
                dynSettings(1,i).dynRange = [10:5:50;2:1:10];
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('CGF');
                end
            case {'FP1','FP2'}
                dynSettings(1,i).dynRange = 5:5:50;
                for j = 50:-1:1
                    dynSettings(1,i).DOP{j} = str2func('CGF');
                end
            case 'SCA'
                dynSettings(1,i).dynRange = 1:4;
                dynSettings(1,i).DOP = str2func('SCA');
                
        end
        
        if sum(strcmp(varargin{i},{'RSRG2','RSS2','RSG2','RSQR2','RSR2','FP2'}))
            %% CYCLICAL DOPS, F2
            randDOP = randi(4,1,50);
            for j = 50:-1:1
                switch randDOP(j)
                    case 1
                        dynSettings(1,i).DOP{j} = str2func('MPB');
                    case 2
                        dynSettings(1,i).DOP{j} = str2func('DF1');
                    case 3
                        dynSettings(1,i).DOP{j} = str2func('CGF');
                    case 4
                        dynSettings(1,i).DOP{j} = str2func('CF4');
                end
            end
            
        end
        
        
    end
    
    
    
    
end
