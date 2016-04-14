function [ newResults ] = DeathMarchGraphs()

%% THIS IS ONLY TO BE RUN ONCE PER DAY
folder = 'C:\PhD\Eclipse workspace\Latex\DSSC-Thesis\Progress\';
 
fid = fopen(strcat(folder,'log.txt'));
notFirstTime = 0;

% if the DeathMarch.mat file exists, load variables (DEFAULT)
%this loads the following variables:
%'chapterRecord', 'date', 'total'
if exist(strcat(folder,'DeathMarch.mat'), 'file') == 2

    load(strcat(folder,'DeathMarch.mat'));
    notFirstTime = 1;
end

%% DATE 
%first line is date. Add to date struct
theDate = fgetl(fid);
if(notFirstTime)
    date{size(date,2)+1} = theDate;
else
    date{1} = theDate;
end

line = fgetl(fid);
%loop through until 'Sum' reached
while isempty(strfind(line, 'Sum'))
    line = fgetl(fid);
end

%% TOTAL
idx = strfind(line, ':');
theTotal = sscanf(line((idx(1)+1):end), '%g', 1);
if(notFirstTime)
    total(size(total,2)+1) = theTotal;
else
    total = theTotal;
end

%loop until Subcounts is reached
while isempty(strfind(line, 'Subcounts:'))
    line = fgetl(fid);
end
% skip the next line - it's just a definition line after all
fgetl(fid);

line = fgetl(fid);


%% CHAPTERRECORD, ALL
i = 1;
while ischar(line) && ~isempty(line) 
    
    
    % format is: 'COUNT','OTHER STUFF', ')', 'name'
    % go through each line, pull out the COUNT and NAME, store in a struct
    % COUNT is first, no need to do anything exciting
    count = sscanf(line, '%g', 1);   
    
    %Name is last, search for ')'
    idx = strfind(line, ')');
    name = line(idx(1)+1:end);   
    
   
    %check if we have a previously generated array. If so, lets add the
    %total after. NOTE, only do this on a chapter by chapter basis
    %Basically, we are going to store the progression of each chapter but
    %not the sections.
    if(~isempty(strfind(name, 'Chapter:')))
        %this is not the first time we have done this (should be default)
        j = 1;
        if(notFirstTime)
            % loop through
            while(~strcmpi(name, chapterRecord(j).name) && (j <= size(chapterRecord,2))) 
                j = j+1;
            end
            
            %we've found a matching chapter - add the count to the record
            chapterRecord(j).count(size(chapterRecord(j).count,2)+1)=count;
        else
            chapterRecord(i).name = name;
            chapterRecord(i).count = count;
        end
    end
    
    i = i+1;
    % get the next line
    line = fgetl(fid);
end

%load the previous results file
save(strcat(folder,'DeathMarch.mat'),'chapterRecord', 'total', 'date');
%load('C:\PhD\Eclipse workspace\Latex\DSSC-Thesis\Progress\DeathMarch.mat');


end

