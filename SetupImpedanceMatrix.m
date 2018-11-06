
%{
    Help file for setting up the impedance matrix with appropriate checks
    to ensure stability and correct indexes
%}

if length(CableData) ~= length(start2end)
    disp('Gör om gör rätt')
    error('Missmatch in CableData and nodes!')
end

Z = zeros(length(CableData), 1);
for iData = 1:length(CableData)
   Z(iData,1) = CableData.Z; 
end

