
%{
    Help file for setting up the impedance matrix with appropriate checks
    to ensure stability and correct indexes
%}

if length(CableData) ~= length(start2end_modified)
    disp('G�r om g�r r�tt!!! REEEEEEEEEEE!')
    error('Mismatch in CableData and nodes!')
end

Z_ser = zeros(length(CableData)+1);
Y_shu = zeros(length(CableData)+1);
for iData = 1:length(CableData)
    startnode = start2end_modified(iData,1);
    endnode = start2end_modified(iData,2);
    
    Z_ser(startnode, endnode) = -CableData(iData).Z_ser;        % Setting non-diagonal elements (negative)
    Z_ser(endnode, startnode) = -CableData(iData).Z_ser;        
    Y_shu(startnode, endnode) = -CableData(iData).Y_shu;        % Setting non-diagonal elements (negative)
    Y_shu(endnode, startnode) = -CableData(iData).Y_shu;
end

% diagonal elements ( DETTA BLIR Y_bus???? fast impedancen (+mer) fr�n transformatorn saknas? )
for iBus = 1:length(Z_ser)
    adjacent_impedance = [];
    adjacent_admittance = [];
    for iSum = 1:length(start2end_modified)
        if iBus == start2end_modified(iSum,1) || iBus == start2end_modified(iSum, 2)
            adjacent_impedance = [adjacent_impedance; CableData(iSum).Z_ser];
            adjacent_admittance = [adjacent_admittance; CableData(iSum).Y_shu];
        end
    end
    
    Z_ser(iBus, iBus) = sum(adjacent_impedance);
    Y_shu(iBus, iBus) = sum(adjacent_admittance);
end

Y_ser = 1./Z_ser;
Z_shu = 1./Y_shu;

% clear some workspace
clear startnode endnode iData iBus iSum