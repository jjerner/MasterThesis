% Evenly distributed PV production

disp('Calculating PV power from model.');
P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';    % Get PV power from model [p.u.]
P_pv=P_pv(timeLine);                                    % Set correct timeline

busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);

numCalcStr = num2str(length(loadNumber));
for iPv = 1:length(loadNumber)  % iPV - number of pv systems
    
    %Update waitbar
    waitbar(iPv/length(loadNumber), wh, ['Running Calculation: ',...
                       num2str(iPv),'/',numCalcStr]);
    
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
    
    %store results
    Dist(iPv).iteration = iPv;
    Dist(iPv).Results = res;
    
end


% Analysera Dist

% find loadbus with highest voltage (assumed to be in the last iteration where
% p_pv is the highest
% find loadbus with lowest voltage (assumed to be in the first iteration where
% p_pv is the lowest

U_max_load = Dist(iPv).Results.U_hist(busIsLoad,:);
U_min_load = Dist(1).Results.U_hist(busIsLoad,:);
S_max_load = Dist(iPv).Results.S_hist(busIsLoad,:);
[rowMaxLoad, timeMaxLoad] = find(U_max_load == max(max(U_max_load)));
[rowMinLoad, timeMinLoad] = find(U_min_load == min(min(U_min_load)));
[rowMaxProd, timeMaxProd] = find(S_max_load == min(min(S_max_load))); % max production -> lowest S total

iMaxLoad = loadNumber(rowMaxLoad);  % Max loadvoltage found at this bus number
iMinLoad = loadNumber(rowMinLoad);  % Min loadvoltage found at this bus number
iMaxProd = loadNumber(rowMaxProd);  % Max productionload

U_max_pu = U_max_load(rowMaxLoad, :);
U_min_pu = U_min_load(rowMinLoad, :);
U_max = U_max_pu*(TransformerData.U_sec_base/sqrt(3));
U_min = U_min_pu*(TransformerData.U_sec_base/sqrt(3));

allowedMax = repmat(230*1.1,1, length(timeLine));
allowedMin = repmat(230*0.9,1, length(timeLine));

figure
subplot(2,1,1)
plot(timeLine, abs(U_max))
hold on
plot(timeLine, allowedMax, 'r--')
title(['Max voltage at load ', num2str(iMaxLoad)])
xlabel('Time [h]')
ylabel('Voltage, U_f, [V]')
subplot(2,1,2)
plot(timeLine, abs(U_min))
hold on
plot(timeLine, allowedMin, 'r--')
title(['Min voltage at load ', num2str(iMinLoad)])
xlabel('Time [h]')
ylabel('Voltage, U_f, [V]')







clear numCalcStr