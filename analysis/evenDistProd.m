% Evenly distributed PV production

disp('Calculating PV power from model.');
P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';    % Get PV power from model [p.u.]
P_pv=P_pv(timeLine);                                    % Set correct timeline

busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);
S_ana=S_bus(1:Info.nBuses, timeLine);                   % S_analysis based of timeLine
U_ana=U_bus(1:Info.nBuses, timeLine);                   % U_ana

for iPv = 1:length(loadNumber)  % iPV - number of pv systems
    totalPV = iPv.*P_pv;               
    pvPerLoad = totalPV ./ length(loadNumber);
    
    S_ana(busIsLoad,:) = S_ana(busIsLoad,:) - pvPerLoad; % Added PV power to busses
    
    res = doSweepCalcs(Z_ser,Y_shu,S_ana,U_ana,connectionBuses,busType,timeLine);    % run solver
    
    if any(res.nItersVec == Settings.defaultMaxIter)
        break
    end
    
    Dist(iPv).iteration = iPv;   % Store results
    Dist(iPv).Results = res;
    
end


% Analysera Dist!
% // code here //