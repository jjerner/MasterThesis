
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

% Preallocation 
Z_ser_self = zeros(nNodes);    % Self impedance, series
Z_ser_mutu = zeros(nNodes);    % Mutual impedance, series
Y_shu_self = zeros(nNodes);    % Self admittance, shunt




% Mutual impedance/admittance (non-diagonal elements)
% Negative of sum of all admittances between node ij
disp(' ')
disp('SETTING NON-DIAGONAL ELEMENTS.')
for iConnection = 1:length(connectionType)
        startNode = connectionNodes(iConnection,1);
        endNode = connectionNodes(iConnection,2);
        disp(' ');
        disp(['At nodes: ', num2str(startNode), ',', num2str(endNode)]);
        
        if iConnection ~= addedTransformerNodeAtIndex(1)                    % if NOT at added trafo-node
            if iConnection < addedTransformerNodeAtIndex(1)
                Z_ser_mutu(startNode,endNode) = -CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                Z_ser_mutu(endNode,startNode) = -CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                disp(['Series impedance added from Cable ', num2str(iConnection)])
            else
                Z_ser_mutu(startNode,endNode) = -CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                Z_ser_mutu(endNode,startNode) = -CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                disp(['Series impedance added from Cable ', num2str(iConnection-1)])
            end
        else
            Z_ser_mutu(startNode,endNode) = -TransformerData.Z2k_pu;
            Z_ser_mutu(endNode,startNode) = -TransformerData.Z2k_pu;
            disp('Impedance added from transformer');
        end
end

% Self impedance/admittance (diagonal elements)
% Sum of elements terminating at node i
disp(' ')
disp('SETTING DIAGONAL ELEMENTS.')
disp(' ');
for iNode = 1:nNodes
    disp(['At node ', num2str(iNode)]);
    Z_ser_self_vec = [];
    Y_shu_self_vec = [];
    for iConnection = 1:length(connectionNodes)
        startNode = connectionNodes(iConnection,1);
        endNode = connectionNodes(iConnection,2);
        
        if iNode == startNode || iNode == endNode
            if iConnection ~= addedTransformerNodeAtIndex(1)                % if NOT at added trafo-node
                if iConnection < addedTransformerNodeAtIndex(1)
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection).Z_ser/TransformerData.Z_prim_base];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection).Y_shu/(1/TransformerData.Z_prim_base)];
                    disp(['     - Cable ', num2str(iConnection)]);
                else
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection-1).Z_ser/TransformerData.Z_sec_base];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection-1).Y_shu/(1/TransformerData.Z_sec_base)];
                    disp(['     - Cable ', num2str(iConnection-1)]);
                end
            else
                if iNode == addedTransformerNodeAtIndex(1)        % if at HV side
                    Z_ser_self_vec =  [Z_ser_self_vec;...
                                        TransformerData.Z2k_pu*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2];
                    Y_shu_self_vec =  [Y_shu_self_vec; 0.5*TransformerData.Z0_pu];
                    disp('     - Transformer R2k in HV base');
                elseif iNode == addedTransformerNodeAtIndex(2)       % if at LV side
                    Z_ser_self_vec =  [Z_ser_self_vec; TransformerData.Z2k_pu];
                    Y_shu_self_vec =  [Y_shu_self_vec; 0];
                    disp('     - Transformer R2k in LV base');
                end
            end
        end
    end
    
    Z_ser_self(iNode, iNode) = sum(Z_ser_self_vec);
    Y_shu_self(iNode, iNode) = sum(Y_shu_self_vec);
end

Z_ser_tot = Z_ser_self+Z_ser_mutu;  % Total impedance, series
Y_ser_tot = 1./Z_ser_tot;   
Y_ser_tot(Z_ser_tot==0)=0;          % Total admittance, series
Y_shu_tot = Y_shu_self;             % Total admittance, shunt
Y_bus     = Y_ser_tot + Y_shu_tot;  % Bus admittance matrix

% clear some workspace
clear startNode endNode iNode iConnection Z_ser_self_vec Y_shu_self_vec