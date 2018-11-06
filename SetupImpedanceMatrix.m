
%{
    Help file for setting up the impedance matrix with appropriate checks
    to ensure stability and correct indexes
%}

if length(CableData) ~= length(start2end_modified)
    disp('Gör om gör rätt!!! REEEEEEEEEEE!')
    error('Mismatch in CableData and nodes!')
end

Z_line = zeros(length(CableData)+1);
Y_chg = zeros(length(CableData)+1);
for iData = 1:length(CableData)
    startnode = start2end_modified(iData,1);
    endnode = start2end_modified(iData,2);
    
    Z_line(startnode, endnode) = -CableData(iData).Z;       % Setting non-diagonal elements (negative)
    Y_chg(startnode, endnode) = -CableData(iData).Y;        % Setting non-diagonal elements (negative)
end

% diagonal elements ( DETTA BLIR Y_bus???? fast impedancen från transformatorn saknas? )
for iBus = 1:length(Z_line)
    adjacent_impedance = [];
    adjacent_admittance = [];
    for iSum = 1:length(start2end_modified)
        if iBus == start2end_modified(iSum,1) || iBus == start2end_modified(iSum, 2)
            adjacent_impedance = [adjacent_impedance; CableData(iSum).Z];
            adjacent_admittance = [adjacent_admittance; CableData(iSum).Y];
        end
    end
    
    Z_line(iBus, iBus) = sum(adjacent_impedance);
    Y_chg(iBus, iBus) = sum(adjacent_admittance);
end