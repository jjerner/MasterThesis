function anaRes=analyzeVoltage(resultSet,busIsLoad)
    %% Voltage
    
    [maxVoltageVec,maxVoltageTimeVec]=max(abs(resultSet.U_hist),[],2);   % Max voltage for each bus
    [minVoltageVec,minVoltageTimeVec]=min(abs(resultSet.U_hist),[],2);   % Min voltage for each bus

    [maxVoltage,maxVoltageBusNr]=max(maxVoltageVec);           % Max voltage and bus number
    [minVoltage,minVoltageBusNr]=min(minVoltageVec);           % Min voltage and bus number

    [maxLoadVoltage,maxLoadVoltageBusNr]=max(maxVoltageVec(busIsLoad));   % Max load voltage and bus number*
    [minLoadVoltage,minLoadVoltageBusNr]=min(minVoltageVec(busIsLoad));   % Min load voltage and bus number*
    % *=numbered according to load buses only

    allBusNrVec=1:size(resultSet.U_hist,1);
    loadBusNrVec=allBusNrVec(busIsLoad);
    maxLoadVoltageBusNr=loadBusNrVec(maxLoadVoltageBusNr);     % Change to global bus numbering
    minLoadVoltageBusNr=loadBusNrVec(minLoadVoltageBusNr);     % Change to global bus numbering

    maxVoltageTimeStep=maxVoltageTimeVec(maxVoltageBusNr);     % Time (col) for max voltage
    minVoltageTimeStep=minVoltageTimeVec(minVoltageBusNr);     % Time (col) for min voltage
    maxLoadVoltageTimeStep=maxVoltageTimeVec(maxLoadVoltageBusNr);     % Time (col) for max load voltage
    minLoadVoltageTimeStep=minVoltageTimeVec(minLoadVoltageBusNr);     % Time (col) for min load voltage

    % Prints to command window
    fprintf('Maximum voltage: %g at bus %d, time %d\n',maxVoltage,maxVoltageBusNr,maxVoltageTimeStep);
    fprintf('Minimum voltage: %g at bus %d, time %d\n',minVoltage,minVoltageBusNr,minVoltageTimeStep);
    fprintf('Maximum load voltage: %g at bus %d, time %d\n',maxLoadVoltage,maxLoadVoltageBusNr,maxLoadVoltageTimeStep);
    fprintf('Minimum load voltage: %g at bus %d, time %d\n',minLoadVoltage,minLoadVoltageBusNr,minLoadVoltageTimeStep);

    % fprintf('Minimum voltage difference: %g\n',minLoadVdiff);
    % fprintf('Maximum voltage difference: %g\n',maxLoadVdiff);
    
    anaRes.all.maxVoltage=maxVoltage;
    anaRes.all.maxVoltageBusNr=maxVoltageBusNr;
    anaRes.all.maxVoltageTimeStep=maxVoltageTimeStep;
    anaRes.all.minVoltage=minVoltage;
    anaRes.all.minVoltageBusNr=minVoltageBusNr;
    anaRes.all.minVoltageTimeStep=minVoltageTimeStep;
    anaRes.loads.maxVoltage=maxLoadVoltage;
    anaRes.loads.maxVoltageBusNr=maxLoadVoltageBusNr;
    anaRes.loads.maxVoltageTimeStep=maxLoadVoltageTimeStep;
    anaRes.loads.minVoltage=minLoadVoltage;
    anaRes.loads.minVoltageBusNr=minLoadVoltageBusNr;
    anaRes.loads.minVoltageTimeStep=minLoadVoltageTimeStep;
    
    %% Power
    
    [maxPowerVec,maxPowerTimeVec]=max(real(resultSet.S_hist),[],2);   % Max power for each bus
    [minPowerVec,minPowerTimeVec]=min(real(resultSet.S_hist),[],2);   % Min power for each bus

    [maxPower,maxPowerBusNr]=max(maxPowerVec);           % Max power and bus number
    [minPower,minPowerBusNr]=min(minPowerVec);           % Min power and bus number

    [maxLoadPower,maxLoadPowerBusNr]=max(maxPowerVec(busIsLoad));   % Max load power and bus number*
    [minLoadPower,minLoadPowerBusNr]=min(minPowerVec(busIsLoad));   % Min load power and bus number*
    % *=numbered according to load buses only

    allBusNrVec=1:size(resultSet.S_hist,1);
    loadBusNrVec=allBusNrVec(busIsLoad);
    maxLoadPowerBusNr=loadBusNrVec(maxLoadPowerBusNr);     % Change to global bus numbering
    minLoadPowerBusNr=loadBusNrVec(minLoadPowerBusNr);     % Change to global bus numbering

    maxPowerTimeStep=maxPowerTimeVec(maxPowerBusNr);     % Time (col) for max power
    minPowerTimeStep=minPowerTimeVec(minPowerBusNr);     % Time (col) for min power
    maxLoadPowerTimeStep=maxPowerTimeVec(maxLoadPowerBusNr);     % Time (col) for max load power
    minLoadPowerTimeStep=minPowerTimeVec(minLoadPowerBusNr);     % Time (col) for min load power

    % Prints to command window
    fprintf('Maximum power: %g at bus %d, time %d\n',maxPower,maxPowerBusNr,maxPowerTimeStep);
    fprintf('Minimum power: %g at bus %d, time %d\n',minPower,minPowerBusNr,minPowerTimeStep);
    fprintf('Maximum load power: %g at bus %d, time %d\n',maxLoadPower,maxLoadPowerBusNr,maxLoadPowerTimeStep);
    fprintf('Minimum load power: %g at bus %d, time %d\n',minLoadPower,minLoadPowerBusNr,minLoadPowerTimeStep);

    % fprintf('Minimum power difference: %g\n',minLoadVdiff);
    % fprintf('Maximum power difference: %g\n',maxLoadVdiff);
    
    anaRes.all.maxPower=maxPower;
    anaRes.all.maxPowerBusNr=maxPowerBusNr;
    anaRes.all.maxPowerTimeStep=maxPowerTimeStep;
    anaRes.all.minPower=minPower;
    anaRes.all.minPowerBusNr=minPowerBusNr;
    anaRes.all.minPowerTimeStep=minPowerTimeStep;
    anaRes.loads.maxPower=maxLoadPower;
    anaRes.loads.maxPowerBusNr=maxLoadPowerBusNr;
    anaRes.loads.maxPowerTimeStep=maxLoadPowerTimeStep;
    anaRes.loads.minPower=minLoadPower;
    anaRes.loads.minPowerBusNr=minLoadPowerBusNr;
    anaRes.loads.minPowerTimeStep=minLoadPowerTimeStep;
end