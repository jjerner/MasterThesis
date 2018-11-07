% This script takes the previously setup nodes

fictive_data = 1;

if fictive_data == 1
    createBusInputs;
end

U_prev = ones(length(Y_shu),1) .* U_guess;      % voltage vector

BusType = blanks(length(Z_ser))';               % Bus names as 2 chars [PQ, PV, SL] SL = Slack bus
BusType = repmat(BusType, 1, 2);

P_bus = nan(length(Z_ser),1);                   % Active effect in bus
Q_bus = nan(length(Z_ser),1);                   % Reactive effect in bus
theta_bus = zeros(length(Z_ser),1);             % phase shift at bus
U_bus = nan(length(Z_ser),1);                   % Voltage at bus


% Här blir de stökigt, ha så kul!

firstHighVoltageNodeFound = 0;
for ibus = 1:length(Z_ser)
    for row = 1:length(start2end_modified)
        for col = 1:2
            if ibus == start2end_modified(row,col) && isspace(BusType(ibus))
                char = nodeType(row,col);
                
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