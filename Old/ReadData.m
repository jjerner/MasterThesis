clear; clc;
%% Find & Open file

DataFolder = 'D:\Exjobb\Data\Example';                      % Set path
listing = dir(DataFolder);                                  % List all files
listing = listing(3:end);                                   % remove garbage from list

filename = listing(1).name;                                 % get file from list [first file in this example]
filepath = strcat(DataFolder, '\', filename);

%filepath = 'testfile.txt';
fileID = fopen(filepath, 'r');

delim = [' ', '\t'];
%% Keywords

lookFor = [{'R E S U L T A T   F Ö R   L S P - L E D N I N G S S T R Ä C K O R'}...    % keywords
           {'SENASTE BERÄKNINGS RESULTAT'}];
           
avoid = [{'U T G Å N G'},...
         {'some more shit'}];
     
%% Do things
iterLine = 0;
enterHere = 0;
enterHere2 = 0;
addValueIterator = 1;
while ~feof(fileID)                                                         % run until end of file
    currentLine = fgetl(fileID);
    
    oldText = ['å','ä', 'ö'];
    newText = ['a','a','o']; 
    
    for i = 1:3
        currentLine = strrep(currentLine, oldText(i), newText(i));
    end
    
    iterLine = iterLine + 1;
    
    if(strcmpi(currentLine, avoid{2}))                             
            disp(['Exiting loop at line ', num2str(iterLine)]);
            enterHere2 = 0;
            break
    end
    
    if(startsWith(currentLine,avoid{1},'IgnoreCase',true))
        continue
    end
        
    if(all(isspace(currentLine)))
        continue
    end
     
    if(strcmpi(currentLine, lookFor{1}) || enterHere == 1)
        if(strcmpi(currentLine, lookFor{1}))
            enterLine = iterLine;
        end
        
        enterHere = 1;
        
        if(iterLine == enterLine+3)                                         % Creating ImportData variable, dynamic fieldnaming
            varName = [];
            iterImport = 1;
            for i = 1:length(currentLine)
                if(isletter(currentLine(i)))
                    varName = strcat(varName, currentLine(i));
                else
                    if(~isempty(varName) && isspace(currentLine(i)))
                        ImportData.(varName) = [];
                        iterImport = iterImport + 1;
                        varName = [];
                    end
                end
                
                if(i == length(currentLine) && ~isempty(varName))           % extra statement for end of line
                    ImportData.(varName) = [];
                    varName = [];
                    disp(['Done finding variables.'])
                    clear varName iterImport i;
                end
            end
        end
        
        if(strcmpi(currentLine, lookFor{2}) || enterHere2 == 1)              % Start reading data
            enterHere2 = 1;
            try
                fieldNames = fieldnames(ImportData);
            catch
                errordlg('Shit hit the fan')
            end
            
            if(strcmpi(currentLine, lookFor{2}))                            % jump to next row
                disp(['At line ', num2str(iterLine), ' going to next line.']);
                continue
            end

            sortedRow = sortline(currentLine);
            
            args = [fieldNames'; sortedRow'];
            ImportData(addValueIterator) = struct(args{:});
            addValueIterator = addValueIterator + 1;
            
        end
    end
end

%% Clear some variables and Close file

fclose(fileID);