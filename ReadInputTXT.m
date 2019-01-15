% ReadInputTXT
% Reads input .txt files from directory specified in Settings.inputDir
% Works standalone as long as settings are loaded

disp(['Reading input .txt files for ', Settings.location, '.']);
disp(['File path: ''' Settings.inputDir '''']);

filesInDir = dir(Settings.inputDir);
filesToRead = {};
for k = 1:length(filesInDir)
    [fPath, fname, ext] = fileparts(filesInDir(k).name);
    if strcmp(ext, '.txt')
        filesToRead = [filesToRead; {filesInDir(k).name}];
    end
end



counter = 1 ;
for iFile = 1:length(filesToRead)             % loop for each file in the directory
    disp(['- ', filesToRead{iFile}])
    currentFile = strcat(Settings.inputDir, '\', filesToRead{iFile});
    fileID = fopen(currentFile, 'rt');
    scanData = textscan(fileID, '%s %s','Delimiter','=');
    setsBeginAtRow = find(strcmp(scanData{1}, '##Time-series'));
    dataEndsAtRow = find(strcmp(scanData{1}, '##End-message'));
    nSets = length(setsBeginAtRow);

    for iSet = 1:nSets
        if iSet<nSets
            % Read columns
            allSets(:,1,iSet)=scanData{1}(setsBeginAtRow(iSet)+1:setsBeginAtRow(iSet+1)-1);
            % Read data
            allSets(:,2,iSet)=scanData{2}(setsBeginAtRow(iSet)+1:setsBeginAtRow(iSet+1)-1);
        elseif iSet==nSets
            % Read columns
            allSets(:,1,iSet)=scanData{1}(setsBeginAtRow(iSet)+1:dataEndsAtRow-1);
            % Read data
            allSets(:,2,iSet)=scanData{2}(setsBeginAtRow(iSet)+1:dataEndsAtRow-1);
        end
    end

    for iSet2 = 1:nSets
        referenceAtRow = find(strcmp(allSets(:,:,iSet2), '#Reference'));
        valueAtRow = find(strcmp(allSets(:,:,iSet2), '#Value'));
        % Output is reference and value
        referenceFromFile(iSet2)=allSets(referenceAtRow,2,iSet2);
        valueFromFile(iSet2)=allSets(valueAtRow,2,iSet2);
    end
    
    for iSet3 = 1:nSets
        % Get Values
        valueIndex = regexp(valueFromFile{iSet3}, '\d\/\/\d');      % plockar index efter mönster '[siffra1]//[siffra2]'
        valueString = valueFromFile{iSet3}(valueIndex);             % Alla värden i en lång sträng

        % Fix reference numbering
        refIndex = regexp(referenceFromFile{iSet3}, '\.');          % ger index på punkterna (vill läsa det som ligger mellan)
        if length(refIndex) == 2
            refString = referenceFromFile{iSet3}(refIndex(1)+1 : refIndex(2)-1);
        else
            warning(['Cannot find reference value in ', filesToRead{iFile}]);
        end
        
        if strcmp(referenceFromFile{iSet3}(refIndex(2)+1:end), '2')
            InputData(counter).type = 'active';
        elseif strcmp(referenceFromFile{iSet3}(refIndex(2)+1:end), '4')
            InputData(counter).type = 'reactive';
        elseif strcmp(referenceFromFile{iSet3}(refIndex(2)+1:end), '5')
            InputData(counter).type = 'production';
        else
            InputData(counter).type = ['unknown',referenceFromFile{iSet3}(refIndex(2)+1:end)];
        end
        
        % Creating Input struct with 2 fields
        InputData(counter).reference = str2double(refString);
        InputData(counter).values = nan(length(valueString), 1);

        for iterator = 1:length(valueString)
            InputData(counter).values(iterator) = str2double(valueString(iterator));
        end
        counter = counter + 1;
    end

    fclose(fileID);

end

fprintf('Successfully read %d input .txt files.\n',iFile);

clear iSet iSet2 iSet3 counter currentFile iFile fileID scanData dataEndsAtRow setsBeginAtRow nSets allSets
clear filesInDir filesToRead fPath fname ext inputDir referenceAtRow valueAtRow referenceFromFile valueFromFile
clear valueIndex valueString refIndex refString k iterator