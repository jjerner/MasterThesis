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
    
    case location
        switch
    % inputFile = 'INSERT FILE HERE';
    % inputdata = importdata(inputFile);
end

U_prev = ones(length(Y_bus),1) .* U_guess;      % voltage vector

busType = blanks(length(Y_bus))';               % Bus names as 2 chars [PQ, PV, SL] SL = Slack bus
busType = repmat(busType, 1, 2);

P_bus = nan(length(Y_bus),1);                   % Active effect in bus
Q_bus = nan(length(Y_bus),1);                   % Reactive effect in bus
theta_bus = zeros(length(Y_bus),1);             % phase shift at bus
U_bus = nan(length(Y_bus),1);                   % Voltage at bus
I_bus = nan(length(Y_bus),1);                   % Current at bus


% Här blir de stökigt, ha så kul!
% Need to add known parameter data to bus types.

firstHighVoltageBusFound = 0;
for ibus = 1:length(Y_bus)
    for row = 1:length(connectionBuses)
        for col = 1:2
            if ibus == connectionBuses(row,col) && isspace(busType(ibus))
                char = connectionType(row,col);
                
                if char == 'H' || char == 'T' && firstHighVoltageBusFound == 0
                    firstHighVoltageBusFound = 1;
                    busType(ibus,:) = 'SL';
                    U_bus(ibus) = 1;
                    theta_bus(ibus) = 0;
                    
                elseif char == 'T'
                    busType(ibus,:) = 'PQ';
                    
                elseif char == 'J' || char == 'H'
                    busType(ibus,:) = 'PQ';
                    P_bus(ibus) = 0;
                    Q_bus(ibus) = 0;
                    
                elseif char == 'S'
                    busType(ibus,:) = 'PQ';
                    P_bus(ibus) = 0;
                    Q_bus(ibus) = 0;
                    
                elseif char == 'L'
                    busType(ibus,:) = 'PQ';
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
clear firstHighVoltageBusFound row col char ibus