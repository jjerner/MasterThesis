function [V_S,I_S]=cableCalc(V_R,I_R,CableData,cableID)
% Calculates voltage and current at sending end of cable for specified
% voltage and current at receiving end using lumped parameter pi equivalent
% model.
% 
% Inputs:
% V_R: Voltage at receiving end [V]
% I_R: Current at receiving end [A]
% CableData: Struct containing cable parameters.
% cableID: Integer specifying which cable in the struct.
%
% Outputs:
% V_S: Voltage at sending end [V]
% I_S: Current at sending end [A]

% Voltage, sending end [V]
V_S=CableData(cableID).Z*(V_R*(CableData(cableID).Y/2)+I_R)+V_R;
% Current, sending end [A]
I_S=(CableData(cableID).Y/2)*V_S+(CableData(cableID).Y/2)*V_R+I_R;
end