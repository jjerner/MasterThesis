function U_anaRes=analyzeVoltage(U_hist,busIsLoad)
    % Voltage analysis
    % Prints to command window
    [maxVoltageVec,maxVoltageTimeVec]=max(abs(U_hist),[],2);   % Max voltage for each bus
    [minVoltageVec,minVoltageTimeVec]=min(abs(U_hist),[],2);   % Min voltage for each bus

    [maxVoltage,maxVoltageBusNr]=max(maxVoltageVec);           % Max voltage and bus number
    [minVoltage,minVoltageBusNr]=min(minVoltageVec);           % Min voltage and bus number

    [maxLoadVoltage,maxLoadVoltageBusNr]=max(maxVoltageVec(busIsLoad));   % Max load voltage and bus number*
    [minLoadVoltage,minLoadVoltageBusNr]=min(minVoltageVec(busIsLoad));   % Min load voltage and bus number*
    % *=numbered according to load buses only

    allBusNrVec=1:size(U_hist,1);
    loadBusNrVec=allBusNrVec(busIsLoad);
    maxLoadVoltageBusNr=loadBusNrVec(maxLoadVoltageBusNr);     % Change to global bus numbering
    minLoadVoltageBusNr=loadBusNrVec(minLoadVoltageBusNr);     % Change to global bus numbering

    maxVoltageTimeStep=maxVoltageTimeVec(maxVoltageBusNr);     % Time (col) for max voltage
    minVoltageTimeStep=minVoltageTimeVec(minVoltageBusNr);     % Time (col) for min voltage
    maxLoadVoltageTimeStep=maxVoltageTimeVec(maxLoadVoltageBusNr);     % Time (col) for max load voltage
    minLoadVoltageTimeStep=minVoltageTimeVec(minLoadVoltageBusNr);     % Time (col) for min load voltage

    fprintf('Maximum voltage: %g at (%d,%d)\n',maxVoltage,maxVoltageBusNr,maxVoltageTimeStep);
    fprintf('Minimum voltage: %g at (%d,%d)\n',minVoltage,minVoltageBusNr,minVoltageTimeStep);
    fprintf('Maximum load voltage: %g at (%d,%d)\n',maxLoadVoltage,maxLoadVoltageBusNr,maxLoadVoltageTimeStep);
    fprintf('Minimum load voltage: %g at (%d,%d)\n',minLoadVoltage,minLoadVoltageBusNr,minLoadVoltageTimeStep);

    % fprintf('Minimum voltage difference: %g\n',minLoadVdiff);
    % fprintf('Maximum voltage difference: %g\n',maxLoadVdiff);
    
    U_anaRes.all.maxVoltage=maxVoltage;
    U_anaRes.all.maxVoltageBusNr=maxVoltageBusNr;
    U_anaRes.all.maxVoltageTimeStep=maxVoltageTimeStep;
    U_anaRes.all.minVoltage=minVoltage;
    U_anaRes.all.minVoltageBusNr=minVoltageBusNr;
    U_anaRes.all.minVoltageTimeStep=minVoltageTimeStep;
    U_anaRes.loads.maxVoltage=maxLoadVoltage;
    U_anaRes.loads.maxVoltageBusNr=maxLoadVoltageBusNr;
    U_anaRes.loads.maxVoltageTimeStep=maxLoadVoltageTimeStep;
    U_anaRes.loads.minVoltage=minLoadVoltage;
    U_anaRes.loads.minVoltageBusNr=minLoadVoltageBusNr;
    U_anaRes.loads.minVoltageTimeStep=minLoadVoltageTimeStep;
end