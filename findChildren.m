% Function to find children nodes in tree structure
% function children = findChildren(connMatrix,lookFromNode)
%
% INPUTS:
% connMatrix:   Logical n x n matrix describing node connections using
%               nonzero elements. Rows correspond to start nodes and
%               columns to end nodes, i.e. connMatrix(1,3)~=0 denotes a 
%               connection from node 1 to node 3. Only elements above first
%               diagonal are considered (connections assumed bi-directional).
% lookFromNode: Node number to begin looking from (1 x 1).
%
% OUTPUTS:
% children:     Sorted vector containing node numbers for all nodes on the
%               same branch as lookFromNode.

function children = findChildren(connMatrix,lookFromNode)

    connMatrix = triu(connMatrix,1);  % Only look at elements above first diagonal
    
    children = find(connMatrix(lookFromNode,:));
    
    for iChild = children
       subChildren = findChildren(connMatrix,iChild);
       children = [children subChildren];
    end
    children=sort(children);
end