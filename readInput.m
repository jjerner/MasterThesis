fileID = fopen('data\Inputs\T085\8926095723.txt', 'rt');
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
    reference(iSet2)=allSets(referenceAtRow,2,iSet2);
    value(iSet2)=allSets(valueAtRow,2,iSet2);
    
end

fclose(fileID);