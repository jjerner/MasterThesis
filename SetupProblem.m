% Define buses etc.

busType = blanks(length(Y_bus))';               % Bus names as 2 chars [PQ, PV, SL] SL = Slack bus
busType = repmat(busType, 1, 2);

S_bus = zeros(length(Y_bus),length(InputData(1).values));   % Power in bus
U_bus = ones(length(Y_bus),length(InputData(1).values));    % Voltage at bus
busIsLoad = false(length(Y_bus),1);

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
                    U_bus(iBus,:) = 1;
                    
                elseif char == 'T'
                    busType(iBus,:) = 'PQ';
                    U_bus(iBus,:) = Settings.U_t_guess;
                    
                elseif char == 'J' || char == 'H'
                    busType(iBus,:) = 'PQ';
                    U_bus(iBus,:) = Settings.U_j_guess;
                    %S_bus(iBus) = 0;
                    
                elseif char == 'S'
                    busType(iBus,:) = 'PQ';
                    U_bus(iBus,:) = Settings.U_j_guess;
                    %S_bus(iBus) = 0;
                    
                elseif char == 'L'
                    busType(iBus,:) = 'PQ';
                    U_bus(iBus,:) = Settings.U_l_guess;
                    busIsLoad(iBus) = true;
                    nameOfBus = connectionName{iRow, iCol};
                    nameOfBus = str2double(nameOfBus);
                    
                    referenceFound = 0;
                    for iInput = 1:length(InputData)
                        if nameOfBus == InputData(iInput).reference
                            referenceFound = 1;
                            break
                        end
                    end
                    
                    if referenceFound == 0
                        warning(['Cannot find data for load reference: ', num2str(nameOfBus)]); 
                        S_bus(iBus,:) = 1;
                    elseif referenceFound == 1
                        S_bus(iBus,:) = (InputData(iInput).values'.*1000)./(3*TransformerData.S_base);
                    end
                    
                else
                    error('Error when sorting bus data, check "SetupProblem.m"')
                end
                
            end
        end
    end
end

% clear some workspace
clear firstHighVoltageBusFound iRow iCol iBus char nameOfBus referenceFound iInput