% Evenly distributed PV production

disp('Calculating PV power from model.');
P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';    % Get PV power from model [p.u.]
P_pv=P_pv(timeLine);                                    % Set correct timeline

busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);

for iPv = 0:length(loadNumber)      % iPV - number of pv systems
    
    %Update waitbar
    waitbar(iPv/length(loadNumber), wh, ['Running Calculation: ',...
                       num2str(iPv),'/',num2str(length(loadNumber))]);
    
    %Setup analysis matrices
    S_ana=S_bus(1:Info.nBuses, timeLine);                   % S_analysis based of timeLine
    U_ana=U_bus(1:Info.nBuses, timeLine);                   % U_ana
    
    totalPV = iPv.*P_pv;               
    pvPerLoad = totalPV ./ length(loadNumber);
    
    S_ana(busIsLoad,:) = S_ana(busIsLoad,:) - pvPerLoad; % Added PV power to busses
    
    %run sweepcalc
    res = doSweepCalcs(Z_ser,Y_shu,S_ana,U_ana,connectionBuses,busType,timeLine);    % run solver
    
    if any(res.nItersVec == Settings.defaultMaxIter)
        % break if max itereations is reached in sweep calc, dont store
        % results of this iteration
        break
    end
    
    
    
    %Analysis
    voltageVec = res.U_hist(busIsLoad, :);      % get all Load voltages
    %currentVec = res.I_hist;
    %powerVec = res.S_hist;
    
    %hitta max volt min volt och max deltaV
    [rowMaxLoad, timeMaxLoad] = find(voltageVec == max(max(voltageVec)));
    [rowMinLoad, timeMinLoad] = find(voltageVec == min(min(voltageVec)));
    
    iMaxLoad = loadNumber(rowMaxLoad);  % Max loadvoltage found at this bus number
    iMinLoad = loadNumber(rowMinLoad);  % Min loadvoltage found at this bus number
    
    %store ALL results in struct EvenDist, containing 0 to 100
    EvenDist(iPv+1).Results = res;          % Kanske ska ta bort denna då det ÄTER! RAM-minne
    EvenDist(iPv+1).PvSystemsAdded = iPv;
    EvenDist(iPv+1).PvPowerPerLoad = pvPerLoad;
    
    %Store interesting points in EvenDist.Critical
    EvenDist(iPv+1).Critical.maxVoltage.Voltage = voltageVec(rowMaxLoad, timeMaxLoad);
    EvenDist(iPv+1).Critical.maxVoltage.BusNumber = iMaxLoad;
    
    EvenDist(iPv+1).Critical.minVoltage.Voltage = voltageVec(rowMinLoad, timeMinLoad);
    EvenDist(iPv+1).Critical.minVoltage.BusNumber = iMinLoad;
    
    if iPv == 0
        EvenDist(iPv+1).Critical.deltaV.Voltage = 0;
        EvenDist(iPv+1).Critical.deltaV.BusNumber = 0;
    else
        % find max deltaV
        lastU = EvenDist(iPv).Results.U_hist(busIsLoad, :);
        diffU = voltageVec - lastU;
        [rowMaxDiff, timeMaxDiff] = find(diffU == max(max(diffU)));
        iMaxDiff = loadNumber(rowMaxDiff);
        
        EvenDist(iPv+1).Critical.deltaV.Voltage = diffU(rowMaxDiff, timeMaxDiff);
        EvenDist(iPv+1).Critical.deltaV.BusNumber = iMaxDiff;
    end
 
    
end


% Analysera EvenDist




clear numCalcStr powerVec currentVec voltageVec lastU diffU rowMaxLoad rowMinLoad rowMaxDiff
clear timeMaxLoad timeMinLoad timeMaxDiff res iPv totalPV S_ana U_ana pvPerLoad