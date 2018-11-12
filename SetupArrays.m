
%{
    Help file for setting up the impedance & admittance matrices with appropriate checks
    to ensure stability and correct indexes
%}

if min(min(connectionNodes)) ~= 1
   error('Conenction index does not start at 1, Check "connectionNodes"');
elseif max(max(connectionNodes)) > length(connectionNodes)+1
    error('Connection index exceeds its limit, Check "connectionNodes"');
end

nCables = length(CableData);
nTransformers = length(TransformerData);
nNodes = nCables + nTransformers + 1;

if nCables + nTransformers ~= length(connectionNodes)
   error('Kaos'); 
end

% Preallocation 
Z_ser_self = zeros(nNodes);    % Self impedance, series
Z_ser_mutu = zeros(nNodes);    % Mutual impedance, series
Y_shu_self = zeros(nNodes);    % Self admittance, shunt




% Mutual impedance/admittance (non-diagonal elements)
% Negative of sum of all admittances between node ij
for iConnection = 1:length(CableData)
        startNode = connectionNodes(iConnection,1);
        endNode = connectionNodes(iConnection,2);
        
        if iConnection ~= addedTransformerNodeAtIndex(1)                    % if NOT at added trafo-node
            if iConnection < addedTransformerNodeAtIndex(1)
                Z_ser_mutu(startNode,endNode) = -CableData(iConnection).Z_ser;
                Z_ser_mutu(endNode,startNode) = -CableData(iConnection).Z_ser;
            else
                Z_ser_mutu(startNode,endNode) = -CableData(iConnection-1).Z_ser;
                Z_ser_mutu(endNode,startNode) = -CableData(iConnection-1).Z_ser;
            end
        else
            Z_ser_mutu(startNode,endNode) = 0.0012 + 0.0001i;    % TransformerData.Z_ser;
            Z_ser_mutu(endNode,startNode) = 0.0012 + 0.0001i;    % TransformerData.Z_ser;
        end
end

% Self impedance/admittance (diagonal elements)
% Sum of elements terminating at node i
for iNode = 1:nNodes
    Z_ser_self_vec = [];
    Y_shu_self_vec = [];
    for iConnection = 1:length(connectionNodes)
        startNode = connectionNodes(iConnection,1);
        endNode = connectionNodes(iConnection,2);
        
        if iNode == startNode || iNode == endNode
            if iConnection ~= addedTransformerNodeAtIndex(1)                % if NOT at added trafo-node
                if iConnection < addedTransformerNodeAtIndex(1)
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection).Z_ser];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection).Y_shu];
                else
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection-1).Z_ser];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection-1).Y_shu];
                end
            else
               Z_ser_self_vec =  [Z_ser_self_vec; 0.0012 + 0.0001i];  % Change to TransformerData.Z_ser
               Y_shu_self_vec =  [Y_shu_self_vec; 0.5*(0.0012 + 0.0001i)]; % fix this shiiiiet
            end
        end
    end
    
    Z_ser_self(iNode, iNode) = sum(Z_ser_self_vec);
    Y_shu_self(iNode, iNode) = sum(Y_shu_self_vec);
end

Z_ser_tot = Z_ser_self+Z_ser_mutu;  % Total impedance, series
Y_ser_tot = 1./Z_ser_tot;   
Y_ser_tot(Z_ser_tot==0)=0;          % Total admittance, series <--- varför?????????
Y_shu_tot = Y_shu_self;             % Total admittance, shunt
Y_bus     = Y_ser_tot + Y_shu_tot;  % Bus admittance matrix

% clear some workspace
clear startNode endNode iNode iConnection Z_ser_self_vec Y_shu_self_vec