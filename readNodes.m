

% Start node is in data.data(:,3) & data.textdata(:,3)
% End node is in data.data(:,4) & data.textdata(:,4)
% 3 possible types of node: Transformer, "cablestation", Load

nTypes =['T', 'S', 'L'];         % T = trafo, S = cablestation, L = load

startnodes = zeros(length(data.data),1);
endnodes = zeros(length(data.data),1);


for i = 1:length(data.data)
% startnode   
    if ~isnan(data.data(i,3))
        startnodes(i) = data.data(i,3);
    else
        currentcell = data.textdata{i,3};
        cellsplit = strsplit(currentcell);
        iStart = str2double(cellsplit{1});      % start node
        tStart = cellsplit(2);                  % start node type
    end
    
% endnode
    if ~isnan(data.data(i,4))
        endnodes(i) = data.data(i,4);
    else
        currentcell = data.textdata{i,4};
        cellsplit = strsplit(currentcell);
        iEnd = str2double(cellsplit{1});        % end node
        tEnd = cellsplit(2);                    % end node type
    end
end