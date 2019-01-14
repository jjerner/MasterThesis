% Set up connection buses, names, types etc.

% Start bus is in data.data(:,3) & data.textdata(:,3)
% End bus is in data.data(:,4) & data.textdata(:,4)
% 5 possible types of bus: Transformer - T
%                          Cablestation - S
%                          Load - L
%                          High voltage (pre-trafo) - H
%                          Joint - J

startBuses = zeros(length(data.data),1);
endBuses = zeros(length(data.data),1);
connectionType = blanks(length(data.data))';
connectionType = repmat(connectionType,1,2);
connectionName = cell(size(connectionType));

for iRow = 1:length(data.data)
% startbus   
    if ~isnan(data.data(iRow,3))
        if data.data(iRow,3) > 99
            currentcell = num2str(data.data(iRow,3));
            intStart = str2double(currentcell(1:3));
            startBuses(iRow) = intStart;
            typeStart = currentcell(4:end);
            connectionName(iRow,1) = {typeStart};
        else
            startBuses(iRow) = data.data(iRow,3);
        end
    else
        currentcell = data.textdata{iRow,3};
        cellsplit = strsplit(currentcell);
        intStart = str2double(cellsplit{1});       % start bus
        startBuses(iRow) = intStart;
        typeStart = cellsplit(2);                  % start bus type
        connectionName(iRow,1) = typeStart;
    end
    
% endbus
    if ~isnan(data.data(iRow,4))
        if data.data(iRow,4) > 99
            currentcell = num2str(data.data(iRow,4));
            intEnd = str2double(currentcell(1:3));
            endBuses(iRow) = intEnd;
            typeEnd = currentcell(4:end);
            connectionName(iRow,2) = {typeEnd};
        else
            endBuses(iRow) = data.data(iRow,4);
        end
    else
        currentcell = data.textdata{iRow,4};
        cellsplit = strsplit(currentcell);
        intEnd = str2double(cellsplit{1});          % end bus
        endBuses(iRow) = intEnd;
        typeEnd = cellsplit(2);                     % end bus type
        connectionName(iRow,2) = typeEnd;
    end

end

foundTransformer = 0;
for iRow = 1:length(connectionName)
    for iCol = 1:2
        
        if isempty(connectionName{iRow,iCol}) && foundTransformer == 0      % First few elements, pre-trafo
            connectionType(iRow,iCol) = 'H';
        elseif isempty(connectionName{iRow,iCol}) && foundTransformer == 1  % joint, 2 cables in series
            connectionType(iRow,iCol) = 'J';
        elseif connectionName{iRow,iCol}(1) == 'T'                          % first char = T -> Transformer
            connectionType(iRow,iCol) = 'T';
            foundTransformer = 1;
        elseif length(connectionName{iRow,iCol}) == 4                       % 4 digitname = cablestation
            connectionType(iRow,iCol) = 'S';
        else
            connectionType(iRow,iCol) = 'L';
        end
        
        if iCol == 1
            CableData(iRow).StartType = connectionType(iRow,iCol);
        elseif iCol == 2
            CableData(iRow).EndType = connectionType(iRow,iCol);
        end
        
    end
end

connectionBuses_notrafo = [startBuses, endBuses];
connectionBuses_notrafo = connectionBuses_notrafo - (min(min(connectionBuses_notrafo)) - 1);      % modified so start point gets index 1

% add extra internal busconnection in the transformer, called 'TT' 
for iConn = 1:length(connectionType(1,:))
   
    if all(strcmp(connectionType(iConn,:), 'HT'))
        connectionType = [connectionType(1:iConn,1:2); 'TT'; connectionType(iConn+1:end,1:2)];
        connectionName = [connectionName(1:iConn,1:2); [{'Trafo internal'} {'Trafo internal'}]; connectionName(iConn+1:end,1:2)];
        newStart = [connectionBuses_notrafo(1:iConn,1); iConn+1; connectionBuses_notrafo(iConn+1:end,1)+1];
        newEnd = [connectionBuses_notrafo(1:iConn,2); iConn+2; connectionBuses_notrafo(iConn+1:end,2)+1];
        connectionBuses = [newStart, newEnd];
        
        Info.addedTransformerBusAtIndex = [iConn+1, iConn+2];
    end
    
end

% The following section is to remove any connection previous to the
% Transformer, so that bus 1 is the transformer's high voltage side

if Settings.removeHighVoltageBuses
    type = connectionType(1, :);
    while any(type == 'H')
        CableData(1)         = [];  % remove first struct in cable data
        connectionType(1,:)  = [];  % remove first connection types
        connectionBuses(1,:) = [];  % remove first connection buses
        connectionName(1,:)  = [];  % remove first connection names
        connectionBuses = connectionBuses - 1;      % re-numbering of buses
        Info.addedTransformerBusAtIndex = Info.addedTransformerBusAtIndex - 1;  % re-numbering of transformer bus
        type = connectionType(1, :);    % update type
    end
    
end

% adding start- / end-bus to each cable
for iCable = 1:length(CableData)
    if Settings.removeHighVoltageBuses
        CableData(iCable).StartBus = connectionBuses(iCable,1);
        CableData(iCable).EndBus = connectionBuses(iCable,2);
    else
        CableData(iCable).StartBus = connectionBuses(iCable,1);
        CableData(iCable).EndBus = connectionBuses(iCable,2);
    end
end


%clear some workspace
clear foundTransformer typeEnd typeStart startBuses endBuses intStart intEnd typeStart typeEnd
clear currentcell cellsplit iRow iCol newStart newEnd type iCable iConn data connectionBuses_notrafo