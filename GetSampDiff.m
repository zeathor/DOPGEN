function GetSampDiff(refMat, pSize, MLM, sampTech, theFile, dirName)
    %% This function compares the specific matrix agains the reference matrix.
    % each metric value is compared against the reference value, the error
    % is calculated and averaged over the n iterations
    % Note: we need to do row by row, this is some of the worst code I have
    % ever written!
    
    output = [];
    %% loop through each sample size, load the file
    for i = 1:length(pSize)
        for j = 1:numel(sampTech)
            fileName = [dirName, MLM, '-', sampTech{j}, '-', num2str(pSize(i))];
            if(exist([fileName,'.mat'],'file') && (pSize(i)~= refMat.(sampTech{j}).nPoints))
                output.([sampTech{j},num2str(pSize(i))]) = load(fileName);
            end
        end
    end
    
    
    for i = 1:length(refMat.(sampTech{1}).dynRange)
        %% We have to do unique things per metric, call a function to handle it
        switch MLM
            case 'SF_S'
                %% only variables: mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean SF,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD SF,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
            case 'FCCT_S'
                %% only variables: mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean FCCT,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD FCCT,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
            case 'FEPC_S'
                %% only variables: mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean FEPC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD FEPC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
            case 'FCSP_S'
                %% only variables: mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean FCSP,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD FCSP,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean Range FCSP,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.range;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD Range FCSP,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.range;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
            case 'CC_S'
                %% only variables: mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean Range CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.range;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD Range CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.range;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.range;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% STD mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD Mean CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.std;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.std;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.std;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% STD Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD STD CC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.std;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.std;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.std;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                               
            case 'SLHC_S'
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean SLHC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'SLHC STD,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            temp = output.([sampTech{j},num2str(pSize(k))]).trackedMLM;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).trackedMLM;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range mean fitness
                for j = 1:numel(sampTech)
                    fprintf(theFile,'Mean OptDist SLHC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.optDist;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.optDist;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,1);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.optDist;
                            val = mean(tempRef,3);
                            val = val(i,1);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
                %% Range Spatial Std
                for j = 1:numel(sampTech)
                    fprintf(theFile,'STD OptDist SLHC,%1.4f,%s,',refMat.(sampTech{1}).dynRange(1,i),sampTech{j});
                    % calculate value in table
                    
                    for k = 1:length(pSize)
                        val = -1;
                        if(isfield(output,[sampTech{j},num2str(pSize(k))]))
                            tempRef = refMat.(sampTech{j}).otherMLM.optDist;
                            temp = output.([sampTech{j},num2str(pSize(k))]).otherMLM.optDist;
                            val = mean(abs(tempRef-temp(:,:,1:5)),3);
                            val = val(i,3);
                        end
                        if(k == length(pSize))
                            tempRef = refMat.(sampTech{j}).otherMLM.optDist;
                            val = mean(tempRef,3);
                            val = val(i,3);
                        end
                        fprintf(theFile,'%2.4f,',val);
                    end
                    fprintf(theFile,'\n');
                end
                
        end
    end
    
end