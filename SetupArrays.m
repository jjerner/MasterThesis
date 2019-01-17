% Setup arrays, FBSM version
%{
    Help file for setting up the impedance & admittance matrices with appropriate checks
    to ensure stability and correct indexes
%}

if min(min(connectionBuses)) ~= 1
   error('Conenction index does not start at 1, Check "connectionBuses"');
elseif max(max(connectionBuses)) > length(connectionBuses)+1
    error('Connection index exceeds its limit, Check "connectionBuses"');
end

Info.nCables = length(CableData);
Info.nTransformers = length(TransformerData);
Info.nBuses = Info.nCables + Info.nTransformers + 1;

% Preallocation 
Z_ser = zeros(Info.nBuses);    % Seris impedance
Y_shu = zeros(Info.nBuses);    % Shunt admittance

disp(' ')
disp('SETTING NON-DIAGONAL ELEMENTS.')
for iConnection = 1:length(connectionType)
        startBus = connectionBuses(iConnection,1);
        endBus = connectionBuses(iConnection,2);
        disp(' ');
        disp(['Between bus ', num2str(startBus), ' and bus ', num2str(endBus) ':']);
        
        if startBus ~= Info.addedTransformerBusAtIndex(1)
            % Not at transformer bus
            if startBus < Info.addedTransformerBusAtIndex(1)
                % High voltage buses
                Z_ser(startBus,endBus) = CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                Z_ser(endBus,startBus) = CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                Y_shu(startBus,endBus) = CableData(iConnection).Y_shu / TransformerData.Z_prim_base;
                Y_shu(endBus,startBus) = CableData(iConnection).Y_shu / TransformerData.Z_prim_base;
                disp(['Z_ser and Y_shu from cable ', num2str(iConnection)])
            else
                % Low voltage buses
                Z_ser(startBus,endBus) = CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                Z_ser(endBus,startBus) = CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                Y_shu(startBus,endBus) = CableData(iConnection-1).Y_shu / TransformerData.Z_sec_base;
                Y_shu(endBus,startBus) = CableData(iConnection-1).Y_shu / TransformerData.Z_sec_base;
                disp(['Z_ser and Y_shu from cable ', num2str(iConnection-1)])
            end
        else
            % At transformer bus
            Z_ser(startBus,endBus) = TransformerData.Z2k_pu;
            Z_ser(endBus,startBus) = TransformerData.Z2k_pu;
            disp('Z_ser from transformer');
        end
end
disp(' ');
disp('Successfully set up series impedance and shunt admittance matrices.');
disp(' ');

% clear some workspace
clear startBus endBus iBus iConnection Z_ser_self_vec Y_shu_self_vec