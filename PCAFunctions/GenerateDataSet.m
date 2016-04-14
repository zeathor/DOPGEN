function [ dataSet, descriptorSet, IDSet, dStart, dEnd, dStep] = GenerateDataSet(DOPSet, dynamicSet,MLMSet,settings)
    dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\';
    
    grpIdx = 1;
    indIdx = 1;
    
    descriptorSet = FillDescriptorSet(MLMSet);
    dataSet = [];
    
    dStart = [];
    dEnd = [];
    dStep = [];
    
    for DOPIdx = 1:numel(DOPSet)
        for dynIdx = 1:numel(dynamicSet)
            
            %% we assume that a specific DOP/Dynamic/Driver is an individual, not each iteration or metric.
            varIdx = 1;
            for MLMIdx = 1:numel(MLMSet)
                %% load the file
                %                 switch dynamicSet{dynIdx}
                %                     case 'RCDR'
                %                         dynamicSet{dynIdx} = 'RCD';
                %                     case 'RCDF'
                %                         dynamicSet{dynIdx} = 'RCDFix';
                %                     case 'RCDS'
                %                         dynamicSet{dynIdx} = 'RCDF';
                %                 end
                
                fileName = [dirName DOPSet{DOPIdx} '-' dynamicSet{dynIdx} '-' MLMSet{MLMIdx} '.mat'];
                if(exist(fileName,'file'))
                    output = load(fileName);
                    nDriver = size(output.trackedMLM,1);
                    if MLMIdx == 1
                        
                        if strcmp(settings.analType,'ind')
                            indIdx = size(output.trackedMLM,3);
                        end
                        %% fill out the IDSet
                        for i = 1:nDriver
                            for j = 1:indIdx
                                IDSet(grpIdx+j-1 + (i-1)*indIdx).DD = output.dynRange(1,i);
                                IDSet(grpIdx+j-1 + (i-1)*indIdx).DOP = DOPSet{DOPIdx};
                                IDSet(grpIdx+j-1 + (i-1)*indIdx).dyn = dynamicSet{dynIdx};
                            end
                        end
                        if(isempty(dStart))
                            dStart = 1;
                            dEnd = dStart + indIdx*nDriver-1;
                            dStep = indIdx;
                        else
                            dStart = [dStart, dEnd(end)+1];
                            dEnd = [dEnd, dStart(end)+indIdx*nDriver-1];
                            dStep = [dStep, indIdx];
                        end
                        
                    end
                    
                    %% we can do multiple analysis types
                    switch settings.analType
                        case 'all'
                            %% Analysis 1 - Mean of all iterations (normal)
                            trackedMLM = mean(output.trackedMLM,3);
                            dataSet(grpIdx:grpIdx+nDriver - 1,varIdx:varIdx + 16-1) = trackedMLM(:,1:16);
                            varIdx = varIdx+16;
                            switch MLMSet{MLMIdx}
                                case 'SLHC'
                                    otherMLM = mean(output.otherMLM.nExemp,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.optDist,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FCSP'
                                    otherMLM = mean(output.otherMLM.range,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'CC'
                                    otherMLM = mean(output.otherMLM.std,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.range,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FEPC'
                                    otherMLM = mean(output.otherMLM.closeIdx,3);
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                            end
                        case 'ind'
                            %% Analysis 2 - each iteration is an individual
                            trackedMLM = output.trackedMLM;
                            for i = 1:nDriver
                                rowStart = grpIdx+((i-1)*indIdx);
                                rowEnd = rowStart+indIdx-1;
                                dataSet(rowStart:rowEnd,varIdx:varIdx + 16-1) = squeeze(trackedMLM(i,1:16,:))';
                                tempVarIdx = varIdx+16;
                                switch MLMSet{MLMIdx}
                                    case 'SLHC'
                                        otherMLM = squeeze(output.otherMLM.nExemp(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                        otherMLM = squeeze(output.otherMLM.optDist(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                    case 'FCSP'
                                        otherMLM = squeeze(output.otherMLM.range(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                    case 'CC'
                                        otherMLM = squeeze(output.otherMLM.std(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                        otherMLM = squeeze(output.otherMLM.range(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                    case 'FEPC'
                                        otherMLM = squeeze(output.otherMLM.closeIdx(i,1:16,:))';
                                        dataSet(rowStart:rowEnd,tempVarIdx:tempVarIdx + 16-1) = otherMLM(:,1:16);
                                        tempVarIdx = tempVarIdx+16;
                                end
                            end
                            varIdx = tempVarIdx;
                        case 'norm'
                            %% Analysis 3 - Remove mean of each Mean metric i.e., columns 1,2,17,18 etc
                            trackedMLM = mean(output.trackedMLM,3);
                            % subtract mean
                            trackedMLM(:,1:2) = trackedMLM(:,1:2) - mean(trackedMLM(:,1));
                            dataSet(grpIdx:grpIdx+nDriver - 1,varIdx:varIdx + 16-1) = trackedMLM(:,1:16);
                            varIdx = varIdx+16;
                            switch MLMSet{MLMIdx}
                                case 'SLHC'
                                    otherMLM = mean(output.otherMLM.nExemp,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.optDist,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FCSP'
                                    otherMLM = mean(output.otherMLM.range,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'CC'
                                    otherMLM = mean(output.otherMLM.std,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.range,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FEPC'
                                    otherMLM = mean(output.otherMLM.closeIdx,3);
                                    otherMLM(:,1:2) = otherMLM(:,1:2) - mean(otherMLM(:,1));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                            end
                        case 'zscore'
                            %% Analysis 3 - Remove mean of each Mean metric i.e., columns 1,2,17,18 etc
                            trackedMLM = mean(output.trackedMLM,3);
                            % subtract mean
                            trackedMLM(:,1:2) = zscore(trackedMLM(:,1:2));
                            dataSet(grpIdx:grpIdx+nDriver - 1,varIdx:varIdx + 16-1) = trackedMLM(:,1:16);
                            varIdx = varIdx+16;
                            switch MLMSet{MLMIdx}
                                case 'SLHC'
                                    otherMLM = mean(output.otherMLM.nExemp,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.optDist,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FCSP'
                                    otherMLM = mean(output.otherMLM.range,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'CC'
                                    otherMLM = mean(output.otherMLM.std,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                    otherMLM = mean(output.otherMLM.range,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                                case 'FEPC'
                                    otherMLM = mean(output.otherMLM.closeIdx,3);
                                    otherMLM(:,1:2) = zscore(otherMLM(:,1:2));
                                    dataSet(grpIdx:grpIdx+nDriver-1,varIdx:varIdx + 16-1) = otherMLM(:,1:16);
                                    varIdx = varIdx+16;
                            end
                            
                            
                            
                    end
                    
                    
                    
                    
                    
                end
                
            end
            grpIdx = grpIdx+ nDriver*indIdx;
        end
        
    end
    
    
end

