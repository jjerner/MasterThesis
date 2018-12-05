
% Help file for "InitializeCables.m"
% Does not work on its own.

% Start bus is in data.data(:,3) & data.textdata(:,3)
% End bus is in data.data(:,4) & data.textdata(:,4)
% 5 possible types of bus: Transformer - T
%                           Cablestation - S
%                           Load - L
%                           High voltage (pre-trafo) - H
%                           Joint - J

startBuses = zeros(length(data.data),1);
endBuses = zeros(length(data.data),1);
connectionType = blanks(length(data.data))';
connectionType = repmat(connectionType, 1, 2);

for row = 1:length(data.data)
% startbus   
    if ~isnan(data.data(row,3))
        if data.data(row,3) > 99
            currentcell = num2str(data.data(row,3));
            intStart = str2double(currentcell(1:3));
            startBuses(row) = intStart;
            typeStart = currentcell(4:end);
            busName(row,1) = {typeStart};
        else
            startBuses(row) = data.data(row,3);
        end
    else
        currentcell = data.textdata{row,3};
        cellsplit = strsplit(currentcell);
        intStart = str2double(cellsplit{1});       % start bus
        startBuses(row) = intStart;
        typeStart = cellsplit(2);                  % start bus type
        busName(row,1) = typeStart;
    end
    
% endbus
    if ~isnan(data.data(row,4))
        if data.data(row,4) > 99
            currentcell = num2str(data.data(row,4));
            intEnd = str2double(currentcell(1:3));
            endBuses(row) = intEnd;
            typeEnd = currentcell(4:end);
            busName(row,2) = {typeEnd};
            
        else
            endBuses(row) = data.data(row,4);
        end
    else
        currentcell = data.textdata{row,4};
        cellsplit = strsplit(currentcell);
        intEnd = str2double(cellsplit{1});          % end bus
        endBuses(row) = intEnd;
        typeEnd = cellsplit(2);                     % end bus type
        busName(row,2) = typeEnd;
    end

end

foundTransformer = 0;
for row = 1:length(busName)
    for col = 1:2
        
        if isempty(busName{row,col}) && foundTransformer == 0      % First few elements, pre-trafo
            connectionType(row,col) = 'H';
        elseif isempty(busName{row,col}) && foundTransformer == 1  % joint, 2 cables in series
            connectionType(row,col) = 'J';
        elseif busName{row,col}(1) == 'T'                          % first char = T -> Transformer
            connectionType(row,col) = 'T';
            foundTransformer = 1;
        elseif length(busName{row,col}) == 4                       % 4 digitname = cablestation
            connectionType(row,col) = 'S';
        else
            connectionType(row,col) = 'L';
        end
        
        if col == 1
            CableData(row).StartType = connectionType(row,col);
        elseif col == 2
            CableData(row).EndType = connectionType(row,col);
        end
        
    end
end

start2end = [startBuses, endBuses];
modifier = min(min(start2end)) - 1;
start2end_mod = start2end - modifier;      % modified so start point gets index 1

% add extra internal busconnection in the transformer, called 'TT'
for connection = 1:length(connectionType(1,:))
   
    if all(strcmp(connectionType(connection,:), 'HT'))
        connectionType = [connectionType(1:connection,1:2); 'TT'; connectionType(connection+1:end,1:2)];
        newStart = [start2end_mod(1:connection,1); connection+1; start2end_mod(connection+1:end,1)+1];
        newEnd = [start2end_mod(1:connection,2); connection+2; start2end_mod(connection+1:end,2)+1];
        connectionBuses = [newStart, newEnd];
        
        addedTransformerBusAtIndex = [connection+1, connection+2];
    end
    
end

% The following section is to remove any connection previous to the
% Transformer, so that bus/bus 1 is the transformers high voltage side
removeHighVoltageBuses = true;      % true if all buses previous to transformer should be ignored

if removeHighVoltageBuses
    type = connectionType(1, :);
    while any(type == 'H')
        CableData(1) = [];          % remove first struct in cable data
        connectionType(1,:) = [];   % remove first connection type
        connectionBuses(1,:) = [];  % remove first connection buses
        
        connectionBuses = connectionBuses - 1;
        addedTransformerBusAtIndex = addedTransformerBusAtIndex - 1;
        
        type = connectionType(1, :);    % update type
    end
end

for iterator = 1:length(CableData)
    if removeHighVoltageBuses
        CableData(iterator).StartBus = connectionBuses(iterator,1)+1;
        CableData(iterator).EndBus = connectionBuses(iterator,2)+1;
    else
        CableData(iterator).StartBus = connectionBuses(iterator,1);
        CableData(iterator).EndBus = connectionBuses(iterator,2);
    end
end


%clear some workspace
clear foundTransformer typeEnd typeStart startBuses endBuses intStart intEnd typeStart typeEnd
clear currentcell cellsplit row col iterator newStart newEnd connection type
