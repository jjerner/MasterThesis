% This script takes the previously setup nodes

fictive_data = 0;

if fictive_data == 1
    createBusInputs;
else
    % inputFile = 'INSERT FILE HERE';
    % inputdata = importdata(inputFile);
    disp(' ');
    disp(['Reading input data from: ', 'INSERT FILE HERE'])
end

U_prev = ones(length(Y_bus),1) .* U_guess;      % voltage vector

BusType = blanks(length(Y_bus))';               % Bus names as 2 chars [PQ, PV, SL] SL = Slack bus
BusType = repmat(BusType, 1, 2);

P_bus = nan(length(Y_bus),1);                   % Active effect in bus
Q_bus = nan(length(Y_bus),1);                   % Reactive effect in bus
theta_bus = zeros(length(Y_bus),1);             % phase shift at bus
U_bus = nan(length(Y_bus),1);                   % Voltage at bus


% Här blir de stökigt, ha så kul!

firstHighVoltageNodeFound = 0;
for ibus = 1:length(Y_bus)
    for row = 1:length(connectionNodes)
        for col = 1:2
            if ibus == connectionNodes(row,col) && isspace(BusType(ibus))
                char = connectionType(row,col);
                
                if char == 'H' && firstHighVoltageNodeFound == 0
                    firstHighVoltageNodeFound = 1;
                    BusType(ibus,:) = 'SL';
                    
                    
                elseif char == 'T'
                    BusType(ibus,:) = 'PQ';
                    
                elseif char == 'J' || char == 'H'
                    BusType(ibus,:) = 'PQ';
                    P_bus(ibus) = 0;
                    Q_bus(ibus) = 0;
                    
                elseif char == 'S'
                    BusType(ibus,:) = 'PQ';
                    P_bus(ibus) = 0;
                    Q_bus(ibus) = 0;
                    
                elseif char == 'L'
                    BusType(ibus,:) = 'PQ';
                    P_bus(ibus) = 1;
                    Q_bus(ibus) = 1;
                    
                else
                    error('Error when sorting Bus data, check "Setup Problem.m"')
                end
                
            end
        end
    end
end

% clear some workspace
clear firstHighVoltageNodeFound row col char ibus