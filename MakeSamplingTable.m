function  MakeSamplingTable(MLMSet, pSize, dynamic, DOP, dirName)
    %% This function loads a whole bunch of arrays, does some basic manipulations and saves it into a csv file
    % Format of csv: Each row corresponds to a single sampling technique
    % and results
    
    sampTech = {'URS','EDS','JGS','RSHS'};
%     sampTech = {'JGS'};
    saveFile = fopen([dirName, DOP, '-', dynamic, '-', 'Results.csv'],'w');
    % sort the sample set size just in case I am an idiot
    pSize = sort(pSize);
    

    
    %% Write the first line of the file
    fprintf(saveFile,'Metric,Driver,Technique,');
    for i = 1:length(pSize)
        fprintf(saveFile,'%d,',pSize(i));
    end
    fprintf(saveFile,'\n');
    
    %% Main Loop, this is going to calculate each row values
    for i = 1:numel(MLMSet)
        for j = 1:numel(sampTech)
            %% Do a little preparation at the start, find the biggest value to use as the base
            pSizeBig = 0;
            for k = 1:length(pSize)
                fileName = [dirName, DOP, '-', dynamic, '-', MLMSet{i}, '-', sampTech{j}, '-',num2str(pSize(k)),'.mat'];
                if(exist(fileName,'file'))
                    pSizeBig = pSize(k);
                end
            end 

            
            %% Load the biggest value first, to be used as our comparison
            fileName = [dirName, DOP, '-', dynamic, '-', MLMSet{i}, '-', sampTech{j}, '-', num2str(pSizeBig)];
            output.(sampTech{j}) = load(fileName);
        end
        GetSampDiff(output, pSize, MLMSet{i}, sampTech, saveFile, [dirName, DOP, '-', dynamic, '-'])

    end
    
    fclose('all');
end