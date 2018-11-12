
% Help file for "InitializeCables.m"
% Does not work on its own.

% Start node is in data.data(:,3) & data.textdata(:,3)
% End node is in data.data(:,4) & data.textdata(:,4)
% 5 possible types of node: Transformer - T
%                           Cablestation - S
%                           Load - L
%                           High voltage (pre-trafo) - H
%                           Joint - J

startNodes = zeros(length(data.data),1);
endNodes = zeros(length(data.data),1);
connectionType = blanks(length(data.data))';
connectionType = repmat(connectionType, 1, 2);

for row = 1:length(data.data)
% startnode   
    if ~isnan(data.data(row,3))
        startNodes(row) = data.data(row,3);
    else
        currentcell = data.textdata{row,3};
        cellsplit = strsplit(currentcell);
        intStart = str2double(cellsplit{1});      % start node
        startNodes(row) = intStart;
        typeStart = cellsplit(2);                  % start node type
        nodeName(row,1) = typeStart;
    end
    
% endnode
    if ~isnan(data.data(row,4))
        endNodes(row) = data.data(row,4);
    else
        currentcell = data.textdata{row,4};
        cellsplit = strsplit(currentcell);
        intEnd = str2double(cellsplit{1});          % end node
        endNodes(row) = intEnd;
        typeEnd = cellsplit(2);                     % end node type
        nodeName(row,2) = typeEnd;
    end

end

foundTransformer = 0;
for row = 1:length(nodeName)
    for col = 1:2
        
        if isempty(nodeName{row,col}) && foundTransformer == 0      % First few elements, pre-trafo
            connectionType(row,col) = 'H';
        elseif isempty(nodeName{row,col}) && foundTransformer == 1  % joint, 2 cables in series
            connectionType(row,col) = 'J';
        elseif nodeName{row,col}(1) == 'T'                          % first char = T -> Transformer
            connectionType(row,col) = 'T';
            foundTransformer = 1;
        elseif length(nodeName{row,col}) == 4                       % 4 digitname = cablestation
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

start2end = [startNodes, endNodes];
modifier = min(min(start2end)) - 1;
connectionNodes = start2end - modifier;      % modified so start point gets index 1

for iterator = 1:length(connectionNodes)
    CableData(iterator).StartNode = connectionNodes(iterator,1);
    CableData(iterator).EndNode = connectionNodes(iterator,2);
end

% add extra internal nodeconnection in the transformer, called 'TT'
for connection = 1:length(connectionType(1,:))
   
    if all(strcmp(connectionType(connection,:), 'HT'))
        connectionType = [connectionType(1:connection,1:2); 'TT'; connectionType(connection+1:end,1:2)];
        newStart = [connectionNodes(1:connection,1); connection+1; connectionNodes(connection+1:end,1)+1];
        newEnd = [connectionNodes(1:connection,2); connection+2; connectionNodes(connection+1:end,2)+1];
        connectionNodes = [newStart, newEnd];
    end
    
end


%clear some workspace
clear foundTransformer typeEnd typeStart startNodes endNodes intStart intEnd typeStart typeEnd
clear currentcell cellsplit row col iterator
