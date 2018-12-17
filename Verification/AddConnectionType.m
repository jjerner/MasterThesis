
load('Loads.mat')
load('LoadShapes.mat')


% Setup "connectionType"
connectionType = repmat(' ', length(connectionBuses), 2);   % pre-allocate

indexLoad = 1;
nextLoadBus = Loads.Bus(indexLoad);

for iCon = 1:length(connectionBuses)
    
    if isspace(connectionType(iCon, 1))
        if any(connectionBuses(iCon, 1) == connectionBuses(1:iCon-1, 1)) || any(connectionBuses(iCon, 1) == connectionBuses(iCon+1:end, 1))
            connectionType(iCon,1) = 'S';
        elseif connectionBuses(iCon, 1) == 1
            connectionType(iCon,1) = 'T';
        else
            connectionType(iCon,1) = 'J';
        end
    end
    
    if isspace(connectionType(iCon, 2))
        if iCon == nextLoadBus
            connectionType(iCon, 2) = 'L';
            indexLoad = indexLoad + 1;
            nextLoadBus = Loads.Bus(indexLoad);
        else
            connectionType(iCon, 2) = 'J';
        end
    end
    
end

if indexLoad < height(Loads)
    error('All loads have not been found!!')
end



% add the transformer to the connection matrix

connectionBuses = [addedTransformerBusAtIndex; connectionBuses+1];
connectionType = ['HT'; connectionType];