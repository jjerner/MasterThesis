
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
Z_ser_self = zeros(Info.nBuses);    % Self impedance, series
Z_ser_mutu = zeros(Info.nBuses);    % Mutual impedance, series
Y_shu_self = zeros(Info.nBuses);    % Self admittance, shunt




% Mutual impedance/admittance (non-diagonal elements)
% Negative of sum of all admittances between bus ij
disp(' ')
disp('SETTING NON-DIAGONAL ELEMENTS.')
for iConnection = 1:length(connectionType)
        startBus = connectionBuses(iConnection,1);
        endBus = connectionBuses(iConnection,2);
        disp(' ');
        disp(['At buses: ', num2str(startBus), ',', num2str(endBus)]);
        
        if iConnection ~= Info.addedTransformerBusAtIndex(1)                    % if NOT at added trafo-bus
            if iConnection < Info.addedTransformerBusAtIndex(1)
                Z_ser_mutu(startBus,endBus) = CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                Z_ser_mutu(endBus,startBus) = CableData(iConnection).Z_ser / TransformerData.Z_prim_base;
                disp(['Series impedance added from Cable ', num2str(iConnection)])
            else
                Z_ser_mutu(startBus,endBus) = CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                Z_ser_mutu(endBus,startBus) = CableData(iConnection-1).Z_ser / TransformerData.Z_sec_base;
                disp(['Series impedance added from Cable ', num2str(iConnection-1)])
            end
        else
            Z_ser_mutu(startBus,endBus) = TransformerData.Z2k_pu*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2;
            Z_ser_mutu(endBus,startBus) = TransformerData.Z2k_pu*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2;
            disp('Impedance added from transformer');
        end
end

% Self impedance/admittance (diagonal elements)
% Sum of elements terminating at bus i
disp(' ')
disp('SETTING DIAGONAL ELEMENTS.')
disp(' ');
for iBus = 1:Info.nBuses
    disp(['At bus ', num2str(iBus)]);
    Z_ser_self_vec = [];
    Y_shu_self_vec = [];
    for iConnection = 1:length(connectionBuses)
        startBus = connectionBuses(iConnection,1);
        endBus = connectionBuses(iConnection,2);
        
        if iBus == startBus || iBus == endBus
            if iConnection ~= Info.addedTransformerBusAtIndex(1)                % if NOT at added trafo-bus
                if iConnection < Info.addedTransformerBusAtIndex(1)
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection).Z_ser/TransformerData.Z_prim_base];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection).Y_shu/(1/TransformerData.Z_prim_base)];
                    disp(['     - Cable ', num2str(iConnection)]);
                else
                    Z_ser_self_vec = [Z_ser_self_vec; CableData(iConnection-1).Z_ser/TransformerData.Z_sec_base];
                    Y_shu_self_vec = [Y_shu_self_vec; 0.5*CableData(iConnection-1).Y_shu/(1/TransformerData.Z_sec_base)];
                    disp(['     - Cable ', num2str(iConnection-1)]);
                end
            else
                if iBus == Info.addedTransformerBusAtIndex(1)        % if at HV side
                    Z_ser_self_vec =  [Z_ser_self_vec;...
                                        TransformerData.Z2k_pu*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2];
                    Y_shu_self_vec =  [Y_shu_self_vec; 0.5*TransformerData.Z0_pu];
                    disp('     - Transformer R2k in HV base');
                elseif iBus == Info.addedTransformerBusAtIndex(2)       % if at LV side
                    Z_ser_self_vec =  [Z_ser_self_vec; TransformerData.Z2k_pu];
                    Y_shu_self_vec =  [Y_shu_self_vec; 0];
                    disp('     - Transformer R2k in LV base');
                end
            end
        end
    end
    
    Z_ser_self(iBus, iBus) = sum(Z_ser_self_vec);
    Y_shu_self(iBus, iBus) = sum(Y_shu_self_vec);
end

Z_ser_tot = Z_ser_self+Z_ser_mutu;  % Total impedance, series
Y_ser_tot = 1./Z_ser_tot;   
Y_ser_tot(Z_ser_tot==0)=0;          % Total admittance, series
Y_shu_tot = Y_shu_self;             % Total admittance, shunt
Y_bus     = Y_ser_tot + Y_shu_tot;  % Bus admittance matrix

% clear some workspace
clear startBus endBus iBus iConnection Z_ser_self_vec Y_shu_self_vec