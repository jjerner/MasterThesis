function [V_S,I_S]=cableCalc(V_R,I_R,CableData,cableID)
% Calculates voltage and current at sending end of cable for specified
% voltage and current at receiving end.
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

% Voltage, sending end
V_inc=(V_R+CableData(cableID).Z_C*I_R)...
    *exp(CableData(cableID).gamma.*CableData(cableID).l)/2;        % Incident voltage [V]
V_ref=(V_R-CableData(cableID).Z_C*I_R)...
    *exp(-CableData(cableID).gamma.*CableData(cableID).l)/2;       % Reflected voltage [V]
V_S=V_inc+V_ref;                                                   % Sending voltage [V]

% Current, sending end
I_S=((V_R./CableData(cableID).Z_C+I_R)...
    *exp(CableData(cableID).gamma.*CableData(cableID).l)/2)...
    -((V_R./CableData(cableID).Z_C-I_R)...
    *exp(-CableData(cableID).gamma.*CableData(cableID).l)/2);      % Sending current [A]
end