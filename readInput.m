

switch location
    case 'Hallonvägen'
        inputDir = 'data\Inputs\T085';
    case 'Amundstorp'
        inputDir = 'data\Inputs\T317';
end


filesInDir = dir(inputDir);
filesToRead = {};
for k = 1:length(filesInDir)
    [fPath, fname, ext] = fileparts(filesInDir(k).name);
    if strcmp(ext, '.txt')
        filesToRead = [filesToRead; {filesInDir(k).name}];
    end
end



counter = 1 ;
for outerLoop = 1:length(filesToRead)             % loop for each file in the directory
    
    currentFile = strcat(inputDir, '\', filesToRead{outerLoop});
    fileID = fopen(currentFile, 'rt');
    %fileID = fopen('data\Inputs\T085\89260957239.txt', 'rt');
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
        referenceFromFile(iSet2)=allSets(referenceAtRow,2,iSet2);  % bytte namn [reference -> referenceFromFile]
        valueFromFile(iSet2)=allSets(valueAtRow,2,iSet2);          % bytte namn [value -> valueFromFile]
    end
    
    for iSet3 = 1:nSets
        % Get Values
        valueIndex = regexp(valueFromFile{iSet3}, '\d\/\/\d');      % plockar index efter mönster '[siffra1]//[siffra2]'
        valueString = valueFromFile{iSet3}(valueIndex);             % Alla värden i en lång sträng

        % Fix reference numbering
        refIndex = regexp(referenceFromFile{iSet3}, '\.');          % ger index på punkterna (vill läsa det som ligger mellan)
        refString = referenceFromFile{iSet3}(refIndex(1)+1 : refIndex(2)-1);

        % Creating Input struct with 2 fields
        Input(counter).reference = str2double(refString);
        Input(counter).values = nan(length(valueString), 1);

        for iterator = 1:length(valueString)
            Input(counter).values(iterator) = str2double(valueString(iterator));
        end
        counter = counter + 1;
    end

    fclose(fileID);

end