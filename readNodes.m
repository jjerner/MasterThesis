
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
nodeType = blanks(length(data.data))';
nodeType = repmat(nodeType, 1, 2);

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
        intEnd = str2double(cellsplit{1});        % end node
        endNodes(row) = intEnd;
        typeEnd = cellsplit(2);                    % end node type
        nodeName(row,2) = typeEnd;
    end

end

foundTransformer = 0;
for row = 1:length(nodeName)
    for col = 1:2
        
        if isempty(nodeName{row,col}) && foundTransformer == 0      % First few elements, pre-trafo
            nodeType(row,col) = 'H';
        elseif isempty(nodeName{row,col}) && foundTransformer == 1  % joint, 2 cables in series
            nodeType(row,col) = 'J';
        elseif nodeName{row,col}(1) == 'T'                          % first char = T -> Transformer
            nodeType(row,col) = 'T';
            foundTransformer = 1;
        elseif length(nodeName{row,col}) == 4                       % 4 digitname = cablestation
            nodeType(row,col) = 'S';
        else
            nodeType(row,col) = 'L';
        end
        
    end
end

start2end = [startNodes, endNodes];
