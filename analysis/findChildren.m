% Function to find children nodes in tree structure
% function children = findChildren(connMatrix,lookFromNode,backwards,includeSelf)
%
% INPUTS:
% connMatrix:   Logical n x n matrix describing node connections using
%               nonzero elements. Rows correspond to start nodes and
%               columns to end nodes, i.e. connMatrix(1,3)~=0 denotes a 
%               connection from node 1 to node 3. Only elements above first
%               diagonal are considered (connections assumed bi-directional).
% lookFrom:     Node number to begin looking from (1 x 1 int).
% backwards:    Find nodes backwards from lookFrom node instead of forwards.
%               0=forwards, 1=backwards (optional 1 x 1 bool). Default off.
% includeSelf:  Include lookFrom node in result (optional 1 x 1 bool). Default off.
%
% OUTPUTS:
% children:     Sorted vector containing node numbers for all nodes on the
%               same branch as lookFrom node.

function children = findChildren(connMatrix,lookFrom,backwards,includeSelf)
    if ~exist('backwards','var'), backwards = 0; end    % Backwards mode is off by default
    if ~exist('includeSelf','var'), includeSelf = 0; end    % Include self is off by default

    connMatrix = triu(connMatrix,1);  % Only look at elements above first diagonal
    
    children = find(connMatrix(lookFrom,:));
    
    for iChild = children
       subChildren = findChildren(connMatrix,iChild);
       children = [children subChildren];
    end
    
    if includeSelf && ~backwards
        children = [children lookFrom];
    end
    
    children=sort(children);    % Sort elements
    
    if backwards
        temp = 1:length(connMatrix);    % All nodes
        temp(children)=[];              % Remove nodes forwards from lookFrom
        if ~includeSelf
            temp(lookFrom)=[];          % Remove lookFrom node itself
        end
        children = temp;
    end
end