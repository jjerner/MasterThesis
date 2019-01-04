function anaRes=analyzeUandS(resultSet,busIsLoad)
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
    
    %% Active power
    
    [maxActivePowerVec,maxActivePowerTimeVec]=max(real(resultSet.S_hist),[],2);   % Max active power for each bus
    [minActivePowerVec,minActivePowerTimeVec]=min(real(resultSet.S_hist),[],2);   % Min active power for each bus

    [maxActivePower,maxActivePowerBusNr]=max(maxActivePowerVec);           % Max active power and bus number
    [minActivePower,minActivePowerBusNr]=min(minActivePowerVec);           % Min active power and bus number

    [maxLoadActivePower,maxLoadActivePowerBusNr]=max(maxActivePowerVec(busIsLoad));   % Max load active power and bus number*
    [minLoadActivePower,minLoadActivePowerBusNr]=min(minActivePowerVec(busIsLoad));   % Min load active power and bus number*
    % *=numbered according to load buses only

    allBusNrVec=1:size(resultSet.S_hist,1);
    loadBusNrVec=allBusNrVec(busIsLoad);
    maxLoadActivePowerBusNr=loadBusNrVec(maxLoadActivePowerBusNr);     % Change to global bus numbering
    minLoadActivePowerBusNr=loadBusNrVec(minLoadActivePowerBusNr);     % Change to global bus numbering

    maxActivePowerTimeStep=maxActivePowerTimeVec(maxActivePowerBusNr);     % Time (col) for max active power
    minActivePowerTimeStep=minActivePowerTimeVec(minActivePowerBusNr);     % Time (col) for min active power
    maxLoadActivePowerTimeStep=maxActivePowerTimeVec(maxLoadActivePowerBusNr);     % Time (col) for max load active power
    minLoadActivePowerTimeStep=minActivePowerTimeVec(minLoadActivePowerBusNr);     % Time (col) for min load active power

    % Prints to command window
    fprintf('Maximum active power: %g at bus %d, time %d\n',maxActivePower,maxActivePowerBusNr,maxActivePowerTimeStep);
    fprintf('Minimum active power: %g at bus %d, time %d\n',minActivePower,minActivePowerBusNr,minActivePowerTimeStep);
    fprintf('Maximum load active power: %g at bus %d, time %d\n',maxLoadActivePower,maxLoadActivePowerBusNr,maxLoadActivePowerTimeStep);
    fprintf('Minimum load active power: %g at bus %d, time %d\n',minLoadActivePower,minLoadActivePowerBusNr,minLoadActivePowerTimeStep);

    % fprintf('Minimum active power difference: %g\n',minLoadVdiff);
    % fprintf('Maximum active power difference: %g\n',maxLoadVdiff);
    
    anaRes.all.maxActivePower=maxActivePower;
    anaRes.all.maxActivePowerBusNr=maxActivePowerBusNr;
    anaRes.all.maxActivePowerTimeStep=maxActivePowerTimeStep;
    anaRes.all.minActivePower=minActivePower;
    anaRes.all.minActivePowerBusNr=minActivePowerBusNr;
    anaRes.all.minActivePowerTimeStep=minActivePowerTimeStep;
    anaRes.loads.maxActivePower=maxLoadActivePower;
    anaRes.loads.maxActivePowerBusNr=maxLoadActivePowerBusNr;
    anaRes.loads.maxActivePowerTimeStep=maxLoadActivePowerTimeStep;
    anaRes.loads.minActivePower=minLoadActivePower;
    anaRes.loads.minActivePowerBusNr=minLoadActivePowerBusNr;
    anaRes.loads.minActivePowerTimeStep=minLoadActivePowerTimeStep;
    
    %% Reactive power
    
    [maxReactivePowerVec,maxReactivePowerTimeVec]=max(real(resultSet.S_hist),[],2);   % Max reactive power for each bus
    [minReactivePowerVec,minReactivePowerTimeVec]=min(real(resultSet.S_hist),[],2);   % Min reactive power for each bus

    [maxReactivePower,maxReactivePowerBusNr]=max(maxReactivePowerVec);           % Max reactive power and bus number
    [minReactivePower,minReactivePowerBusNr]=min(minReactivePowerVec);           % Min reactive power and bus number

    [maxLoadReactivePower,maxLoadReactivePowerBusNr]=max(maxReactivePowerVec(busIsLoad));   % Max load reactive power and bus number*
    [minLoadReactivePower,minLoadReactivePowerBusNr]=min(minReactivePowerVec(busIsLoad));   % Min load reactive power and bus number*
    % *=numbered according to load buses only

    allBusNrVec=1:size(resultSet.S_hist,1);
    loadBusNrVec=allBusNrVec(busIsLoad);
    maxLoadReactivePowerBusNr=loadBusNrVec(maxLoadReactivePowerBusNr);     % Change to global bus numbering
    minLoadReactivePowerBusNr=loadBusNrVec(minLoadReactivePowerBusNr);     % Change to global bus numbering

    maxReactivePowerTimeStep=maxReactivePowerTimeVec(maxReactivePowerBusNr);     % Time (col) for max reactive power
    minReactivePowerTimeStep=minReactivePowerTimeVec(minReactivePowerBusNr);     % Time (col) for min reactive power
    maxLoadReactivePowerTimeStep=maxReactivePowerTimeVec(maxLoadReactivePowerBusNr);     % Time (col) for max load reactive power
    minLoadReactivePowerTimeStep=minReactivePowerTimeVec(minLoadReactivePowerBusNr);     % Time (col) for min load reactive power

    % Prints to command window
    fprintf('Maximum reactive power: %g at bus %d, time %d\n',maxReactivePower,maxReactivePowerBusNr,maxReactivePowerTimeStep);
    fprintf('Minimum reactive power: %g at bus %d, time %d\n',minReactivePower,minReactivePowerBusNr,minReactivePowerTimeStep);
    fprintf('Maximum load reactive power: %g at bus %d, time %d\n',maxLoadReactivePower,maxLoadReactivePowerBusNr,maxLoadReactivePowerTimeStep);
    fprintf('Minimum load reactive power: %g at bus %d, time %d\n',minLoadReactivePower,minLoadReactivePowerBusNr,minLoadReactivePowerTimeStep);

    % fprintf('Minimum reactive power difference: %g\n',minLoadVdiff);
    % fprintf('Maximum reactive power difference: %g\n',maxLoadVdiff);
    
    anaRes.all.maxReactivePower=maxReactivePower;
    anaRes.all.maxReactivePowerBusNr=maxReactivePowerBusNr;
    anaRes.all.maxReactivePowerTimeStep=maxReactivePowerTimeStep;
    anaRes.all.minReactivePower=minReactivePower;
    anaRes.all.minReactivePowerBusNr=minReactivePowerBusNr;
    anaRes.all.minReactivePowerTimeStep=minReactivePowerTimeStep;
    anaRes.loads.maxReactivePower=maxLoadReactivePower;
    anaRes.loads.maxReactivePowerBusNr=maxLoadReactivePowerBusNr;
    anaRes.loads.maxReactivePowerTimeStep=maxLoadReactivePowerTimeStep;
    anaRes.loads.minReactivePower=minLoadReactivePower;
    anaRes.loads.minReactivePowerBusNr=minLoadReactivePowerBusNr;
    anaRes.loads.minReactivePowerTimeStep=minLoadReactivePowerTimeStep;
end