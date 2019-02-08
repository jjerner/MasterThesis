


busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);

if ~all(any(selectedLoads' == loadNumber))
    % if input isnt a load node, abort
    error('selectedLoads contains bus that is not a loadbus')
end


%Update waitbar
waitbar(iter/length(loadNumber), wh, ['Running Calculation: ',...
        num2str(iter),'/',num2str(length(loadNumber))]);

%Setup analysis matrices
S_ana=S_bus(:,1:end-1);                                   % S_analysis based of timeLine
U_ana=U_bus(:,1:end-1);                                   % U_ana

pvPerLoad = P_pv*1;         % full pvLoad on selected loads, with a factor

S_ana(selectedLoads,:) = S_ana(selectedLoads,:) - pvPerLoad; % Added PV power to busses

%run sweepcalc
res = doSweepCalcs(Z_ser,Y_shu,S_ana,U_ana,connectionBuses,busType,timeLine);    % run solver

if any(res.nItersVec == Settings.defaultMaxIter)
    % break if max itereations is reached in sweep calc, dont store
    % results of this iteration
    warning('Max iter reached in sweep calcs!');
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

%store ALL results in struct SelectDist, containing 0 to 100
SelectDist(iter).Results.U_hist = res.U_hist(busIsLoad,:);          % Kanske ska ta bort denna då det ÄTER! RAM-minne
SelectDist(iter).Results.S_hist = res.S_hist(busIsLoad,:);
SelectDist(iter).PvSystemsAdded = iter;
SelectDist(iter).PvPowerPerLoad = pvPerLoad;
SelectDist(iter).PvAddedAt = selectedLoads;

%Store interesting points in SelectDist.Critical
SelectDist(iter).Critical.maxVoltage.Voltage = abs(voltageVec(rowMaxLoad, timeMaxLoad));
SelectDist(iter).Critical.maxVoltage.TimeStamp = timeMaxLoad;
SelectDist(iter).Critical.maxVoltage.BusNumber = iMaxLoad;

SelectDist(iter).Critical.minVoltage.Voltage = abs(voltageVec(rowMinLoad, timeMinLoad));
SelectDist(iter).Critical.minVoltage.TimeStamp = timeMinLoad;
SelectDist(iter).Critical.minVoltage.BusNumber = iMinLoad;

[maxMean, rowMaxMean] = max(mean(abs(voltageVec), 2));
SelectDist(iter).Critical.maxMeanVoltage.Voltage = maxMean;
SelectDist(iter).Critical.maxMeanVoltage.BusNumer = loadNumber(rowMaxMean);

[minMean, rowMinMean] = min(mean(abs(voltageVec), 2));
SelectDist(iter).Critical.minMeanVoltage.Voltage = minMean;
SelectDist(iter).Critical.minMeanVoltage.BusNumber = loadNumber(rowMinMean);


if iter == 1
    SelectDist(iter).Critical.deltaV.Voltage = 0;
    SelectDist(iter).Critical.deltaV.TimeStamp = 0;
    SelectDist(iter).Critical.deltaV.BusNumber = 0;
else
    % find max deltaV
    lastU = SelectDist(iter-1).Results.U_hist;
    diffU = abs(voltageVec) - abs(lastU);
    [rowMaxDiff, timeMaxDiff] = find(diffU == max(max(diffU)));
    iMaxDiff = loadNumber(rowMaxDiff);

    SelectDist(iter).Critical.deltaV.Voltage = abs(diffU(rowMaxDiff, timeMaxDiff));
    SelectDist(iter).Critical.deltaV.TimeStamp = timeMaxDiff;
    SelectDist(iter).Critical.deltaV.BusNumber = iMaxDiff;
end


% run checks
minV = min(min(abs(voltageVec(rowMinLoad, timeMinLoad))));
maxV = max(max(abs(voltageVec(rowMaxLoad, timeMaxLoad))));
if isempty(minV)
    minV = 1;
end
if isempty(maxV)
    maxV = 1;
end
withinVoltageLimit = maxV<=maxAllowed && minV>=minAllowed;




