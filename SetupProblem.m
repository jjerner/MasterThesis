% This script takes the previously setup buses

fictive_data = 0;
solar_data = 0;             % Set solar 

if fictive_data == 1
    disp(' ')
    disp('Creating fictional input data.');
    
    createBusInputs;
else
    disp(' ');
    disp(['Reading input data from: ', 'INSERT FILE HERE'])
    
    switch location
        case 'Amundstorp'
            filePath = 'data/Inputs/T317';
        case 'Hallonvägen'
            filePath = 'data/Inputs/T085';
    end
    
    % inputdata = importdata(inputFile);
    
end

U_prev = ones(length(Y_bus),1) .* U_guess;      % voltage vector

busType = blanks(length(Y_bus))';               % Bus names as 2 chars [PQ, PV, SL] SL = Slack bus
busType = repmat(busType, 1, 2);

P_bus = nan(length(Y_bus),1);                   % Active power in bus
Q_bus = nan(length(Y_bus),1);                   % Reactive power in bus
U_bus = nan(length(Y_bus),1);                   % Voltage at bus
I_bus = nan(length(Y_bus),1);                   % Current at bus


% Här blir de stökigt, ha så kul!
% Need to add known parameter data to bus types.

firstHighVoltageBusFound = 0;
for iBus = 1:length(Y_bus)
    for iRow = 1:length(connectionBuses)
        for iCol = 1:2
            if iBus == connectionBuses(iRow,iCol) && isspace(busType(iBus))
                char = connectionType(iRow,iCol);
                
                if char == 'H' || char == 'T' && firstHighVoltageBusFound == 0
                    firstHighVoltageBusFound = 1;
                    busType(iBus,:) = 'SL';
                    U_bus(iBus) = 1;
                    
                elseif char == 'T'
                    busType(iBus,:) = 'PQ';
                    
                elseif char == 'J' || char == 'H'
                    busType(iBus,:) = 'PQ';
                    P_bus(iBus) = 0;
                    Q_bus(iBus) = 0;
                    
                elseif char == 'S'
                    busType(iBus,:) = 'PQ';
                    P_bus(iBus) = 0;
                    Q_bus(iBus) = 0;
                    
                elseif char == 'L'
                    busType(iBus,:) = 'PQ';
                    P_bus(iBus) = 1;
                    Q_bus(iBus) = 1;
                    
                else
                    error('Error when sorting bus data, check "SetupProblem.m"')
                end
                
            end
        end
    end
end

% clear some workspace
clear firstHighVoltageBusFound iRow iCol iBus char