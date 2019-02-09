% Evenly distributed PV production

disp('Calculating PV power from model.');
P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';    % Get PV power from model [p.u.]

pvFactor = 1;
busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);
minAllowed = 230*0.9 / (TransformerData.U_sec_base/sqrt(3));
maxAllowed = 230*1.1 / (TransformerData.U_sec_base/sqrt(3));
minV = 1;
maxV = 1;
iPv = 0;
withinVoltageLimit = maxV<=maxAllowed && minV>=minAllowed;

whileLoop = true;
while withinVoltageLimit
%for iPv = 0:length(loadNumber)      % iPV - number of pv systems
    
    %Update waitbar
    waitbar(iPv/length(loadNumber), wh, ['Running Calculation: ',...
                       num2str(iPv),'/',num2str(length(loadNumber))]);
    
    %Setup analysis matrices
    S_ana=S_bus(:,1:end-1);                                   % S_analysis based of timeLine
    U_ana=U_bus(:,1:end-1);                                   % U_ana
    
    % %totalPV = iPv.*P_pv*pvFactor;                          % n systems per iteration
                                                              % distributed on all loads
    % %pvPerLoad = totalPV ./ length(loadNumber);
    
    pvPerLoad = P_pv*iPv*(1/20);
    
    S_ana(busIsLoad,:) = S_ana(busIsLoad,:) - pvPerLoad; % Added PV power to busses
    
    %run sweepcalc
    res = doSweepCalcs(Z_ser,Y_shu,S_ana,U_ana,connectionBuses,busType,timeLine);    % run solver
    
    if any(res.nItersVec == Settings.defaultMaxIter)
        % break if max itereations is reached in sweep calc, dont store
        % results of this iteration
        warning('Max iter reached in sweep calcs! Aborting!');
        break
    end
    
    
    
    %Analysis
    voltageVec = res.U_hist(busIsLoad, :);      % get all Load voltages
    %currentVec = res.I_hist;
    %powerVec = res.S_hist;
    voltageAbs = abs(voltageVec);
    
    %hitta max volt min volt och max deltaV
    [rowMaxLoad, timeMaxLoad] = find(voltageAbs == max(max(voltageAbs)));
    [rowMinLoad, timeMinLoad] = find(voltageAbs == min(min(voltageAbs)));
    
    iMaxLoad = loadNumber(rowMaxLoad);  % Max loadvoltage found at this bus number
    iMinLoad = loadNumber(rowMinLoad);  % Min loadvoltage found at this bus number
    
    %store ALL results in struct EvenDist, containing 0 to 100
    EvenDist(iPv+1).Results.U_hist = res.U_hist(busIsLoad,:);          % Kanske ska ta bort denna då det ÄTER! RAM-minne
    EvenDist(iPv+1).Results.S_hist = res.S_hist(busIsLoad,:);
    EvenDist(iPv+1).PvSystemsAdded = iPv;
    EvenDist(iPv+1).PvPowerPerLoad = pvPerLoad;
    
    %Store interesting points in EvenDist.Critical
    EvenDist(iPv+1).Critical.maxVoltage.Voltage = abs(voltageVec(rowMaxLoad, timeMaxLoad));
    EvenDist(iPv+1).Critical.maxVoltage.TimeStamp = timeMaxLoad;
    EvenDist(iPv+1).Critical.maxVoltage.BusNumber = iMaxLoad;
    
    EvenDist(iPv+1).Critical.minVoltage.Voltage = abs(voltageVec(rowMinLoad, timeMinLoad));
    EvenDist(iPv+1).Critical.minVoltage.TimeStamp = timeMinLoad;
    EvenDist(iPv+1).Critical.minVoltage.BusNumber = iMinLoad;
    
    [maxMean, rowMaxMean] = max(mean(abs(voltageVec), 2));
    EvenDist(iPv+1).Critical.maxMeanVoltage.Voltage = maxMean;
    EvenDist(iPv+1).Critical.maxMeanVoltage.BusNumer = loadNumber(rowMaxMean);
    
    [minMean, rowMinMean] = min(mean(abs(voltageVec), 2));
    EvenDist(iPv+1).Critical.minMeanVoltage.Voltage = minMean;
    EvenDist(iPv+1).Critical.minMeanVoltage.BusNumber = loadNumber(rowMinMean);
    
    
    if iPv == 0
        EvenDist(iPv+1).Critical.deltaV.Voltage = 0;
        EvenDist(iPv+1).Critical.deltaV.TimeStamp = 0;
        EvenDist(iPv+1).Critical.deltaV.BusNumber = 0;
    else
        % find max deltaV
        lastU = EvenDist(iPv).Results.U_hist;
        diffU = abs(voltageVec) - abs(lastU);
        [rowMaxDiff, timeMaxDiff] = find(diffU == max(max(diffU)));
        iMaxDiff = loadNumber(rowMaxDiff);
        
        EvenDist(iPv+1).Critical.deltaV.Voltage = abs(diffU(rowMaxDiff, timeMaxDiff));
        EvenDist(iPv+1).Critical.deltaV.TimeStamp = timeMaxDiff;
        EvenDist(iPv+1).Critical.deltaV.BusNumber = iMaxDiff;
    end
    
    if whileLoop
        iPv = iPv+1;

        minV = min(min(abs(voltageVec(rowMinLoad, timeMinLoad))));
        maxV = max(max(abs(voltageVec(rowMaxLoad, timeMaxLoad))));
        if isempty(minV)
            minV = 1;
        end
        if isempty(maxV)
            maxV = 1;
        end
        withinVoltageLimit = maxV<=maxAllowed && minV>=minAllowed;
        
        sizing = whos('EvenDist');
        if sizing.bytes > 1.0737e+09
            warning('EvenDist exceeds 1 GB of ram')
        end
        
    end
    
end




doPlot = 1;
if doPlot == 1
% Analysera EvenDist
critload = find(loadNumber == EvenDist(end).Critical.maxVoltage.BusNumber);
% Plot av fallet där kritisk spänning uppnåtts samt fallet utan produktion
% för eventuell jämförelse
figure;
sgtitle(['Critical Voltage and Power of bus ', num2str(EvenDist(end).Critical.maxVoltage.BusNumber)])
subplot(2,2,1)
plot(timeLine, abs(EvenDist(end).Results.U_hist(critload,:)))
title('U_{crit}')
subplot(2,2,3)
plot(timeLine, real(EvenDist(end).Results.S_hist(critload,:)))
title('S_{crit}')
subplot(2,2,2)
plot(timeLine, abs(EvenDist(1).Results.U_hist(critload,:)))
title('U_{0}')
subplot(2,2,4)
plot(timeLine, real(EvenDist(1).Results.S_hist(critload,:)))
title('S_{0}')


% Hitta unika kritiska bussar och sedan plotta spänningsökningen i extrempunkten
for asd = 2:length(EvenDist) % börja på 2 för att plats 1 är utan prod.
    criticalBuses(asd-1,1) = EvenDist(asd).Critical.maxVoltage.BusNumber;
    critTime(asd-1,1) = EvenDist(asd).Critical.maxVoltage.TimeStamp;
end

crit = [criticalBuses, critTime];

crit_unique = crit(1,:);
for asd = 1:size(crit,1)
    if ~ismember(crit(asd,:),crit_unique,'rows')
        crit_unique(end+1,:) = crit(asd,:);
    end
end

for iBus = 1:size(crit_unique,1)
    bus = crit_unique(iBus, 1);
    time = crit_unique(iBus, 2);
    critload = find(loadNumber == bus);
    
    for qwe = 1:length(EvenDist)
        voltage(qwe) = abs(EvenDist(qwe).Results.U_hist(critload,time)*TransformerData.U_sec_base/sqrt(3));
        prod(qwe) = EvenDist(qwe).PvPowerPerLoad(1,time)*(TransformerData.S_base/1000);
    end
    
    figure
    plot(prod, voltage)
    title(['Bus', num2str(bus), ' at time: ', num2str(time)])
    xlabel('PV-production [kW]')
    ylabel('Voltage [V]')
    
end



end















clear numCalcStr powerVec currentVec voltageVec lastU diffU rowMaxLoad rowMinLoad rowMaxDiff
clear timeMaxLoad timeMinLoad timeMaxDiff res iPv totalPV S_ana U_ana pvPerLoad