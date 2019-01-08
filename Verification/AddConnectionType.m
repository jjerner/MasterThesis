
load('Loads.mat')       % NOTE: category "yearly" refers to the load shape measured for that particular load
load('LoadShapes.mat')

% Setup "connectionType"
connectionType = repmat(' ', length(connectionBuses), 2);   % pre-allocate

indexLoad = 1;
nextLoadBus = Loads.Bus(indexLoad);

for iCon = 1:length(connectionBuses)
    conLog = connectionBuses == iCon;
    
    if iCon==1
        connectionType(conLog) = 'T';
    elseif iCon == nextLoadBus
        connectionType(conLog) = 'L';
        
        indexLoad = indexLoad + 1;
        nextLoadBus = Loads.Bus(indexLoad);
    else
        connectionType(conLog) = 'J';
    end
end
connectionType(end,2) = 'L';


if indexLoad < height(Loads)
    error('All loads have not been found!!')
end



% add the transformer to the connection matrix

connectionBuses = [Info.addedTransformerBusAtIndex; connectionBuses+1];
connectionType = ['TT'; connectionType];