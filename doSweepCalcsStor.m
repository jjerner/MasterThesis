function resultSet=doSweepCalcsStor(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,waitBar,shuntCap,busIsLoad,TransformerData)
    global Settings;
    maxIter = Settings.defaultMaxIter;    % Default value for maximum number of iterations
    convEps = Settings.defaultConvEps;    % Default convergence limit
    doPlot  = Settings.defaultConvPlots;  % Default value for plot creation
    if ~exist('waitBar','var'),  waitBar  = Settings.defaultWaitBar;   end    % Default value for waitbar
    if ~exist('shuntCap','var'), shuntCap = Settings.defaultShuntCap;  end    % Default value for shunt capacitance
    
    tic;
    
    % Help variables
    busNumbers=1:size(Z_ser,1);
    loadBusNumbers=busNumbers(busIsLoad);
    
    % Settings for each energy storage

    % One small energy storage at each load
    storageBusNr=loadBusNumbers;                            % Place storage at bus number(s)
    storageSize=ones(size(loadBusNumbers))*20e3;            % Size of energy storage [Wh]
    storageDefChgPower=ones(size(loadBusNumbers))*1e3;      % Charging power of energy storage [W]
    storageInitialSoC=ones(size(loadBusNumbers))*0;         % Initial energy storage state of charge [-]
    
% One large energy storage at the transformer
%     storageBusNr=2;               % Place storage at bus number(s)
%     storageSize=500e3;            % Size of energy storage [Wh]
%     storageDefChgPower=20e3;      % Charging power of energy storage [W]
%     storageInitialSoC=0;          % Initial energy storage state of charge [-]
    
    
    storageCharging=false(length(storageBusNr),length(timeLine));
    storageSoC=nan(length(storageBusNr),length(timeLine));
    
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));
    U_delta = zeros(size(connectionBuses,1), length(timeLine));
    I_hist = zeros(size(connectionBuses,1), length(timeLine));
    nItersVec=zeros(1,length(timeLine));
    if waitBar
       barHandle = waitbar(0, '1', 'Name', 'Calculating'); 
    end
    
    % Loop over each time step in the timeline
    for iTime = 1:length(timeLine)
        if waitBar
            waitbar(iTime/length(timeLine), barHandle,...
                sprintf('Sweep calculation %d/%d',iTime,length(timeLine)));
        end
        
        % Do calculation without energy storage
        solverRes = solveFBSM(Z_ser,Y_shu,S_ana(:,timeLine(iTime)),...
        U_bus(:,timeLine(iTime)),connectionBuses,busType,...
        maxIter,convEps,doPlot,shuntCap);
        S_hist(:,iTime)  = solverRes.S_out;
        S_loss(:,iTime)  = solverRes.S_loss;
        U_hist(:,iTime)  = solverRes.U_out;
        U_delta(:,iTime) = solverRes.U_delta;
        I_hist(:,iTime)  = solverRes.I_out;
        S_shu1(:,iTime)  = solverRes.S_shu1;
        S_shu2(:,iTime)  = solverRes.S_shu2;
        nItersVec(iTime) = solverRes.nIters;
        
        % Loop over all energy storages
        for iStor=1:length(storageBusNr)
            
            % Check if current storage is full
            if iTime > 1 && storageSoC(iStor,iTime-1) >= 1
                % Immediate discharge if full
                storageSoC(iStor,iTime) = 0;
                storageDischargedAt(iStor,iTime)=true;
            elseif iTime > 1 && storageSoC(iStor,iTime-1) < 1
                % Discharge not needed
                storageSoC(iStor,iTime) = storageSoC(iStor,iTime-1);
                storageDischargedAt(iStor,iTime)=false;
            end
            
            % Criterion for charging
            if abs(U_hist(storageBusNr(iStor),iTime)) >= (245*sqrt(3))/TransformerData.U_sec_base
                storageCharging(iStor,iTime) = true;
            else
                storageCharging(iStor,iTime) = false;
            end
            
            % Change S_ana if current storage should charge at current time step
            if storageCharging(iStor,iTime)
                fprintf('Storage at bus %d charging at time %d (voltage %.1f V).\n',storageBusNr(iStor),timeLine(iTime),abs(U_hist(storageBusNr(iStor),iTime))*TransformerData.U_sec_base/sqrt(3));
                S_ana(storageBusNr(iStor),iTime)=S_ana(storageBusNr(iStor),timeLine(iTime))+storageDefChgPower(iStor)/TransformerData.S_base;
                if iTime == 1
                    storageMaxChgPower(iStor,iTime)=storageSize(iStor)*(1-storageSoC(iStor,iTime));
                    if storageMaxChgPower(iStor,iTime) < storageDefChgPower(iStor)
                        storageSoC(iStor,iTime)=storageInitialSoC(iStor)+storageMaxChgPower(iStor,iTime)/storageSize(iStor);
                        storageActualChgPower(iStor,iTime)=storageMaxChgPower(iStor,iTime);
                    else
                        storageSoC(iStor,iTime)=storageInitialSoC(iStor)+storageDefChgPower(iStor)/storageSize(iStor);
                        storageActualChgPower(iStor,iTime)=storageDefChgPower(iStor);
                    end
                elseif iTime > 1
                    storageMaxChgPower(iStor,iTime)=storageSize(iStor)*(1-storageSoC(iStor,iTime));
                    if storageMaxChgPower(iStor,iTime) < storageDefChgPower(iStor)
                        storageSoC(iStor,iTime)=storageSoC(iStor,iTime)+storageMaxChgPower(iStor,iTime)/storageSize(iStor);
                    else
                        storageSoC(iStor,iTime)=storageSoC(iStor,iTime)+storageDefChgPower(iStor)/storageSize(iStor);
                    end
                end  
            end
        end
        
        if any(storageCharging(:,iTime))
            % Do calculation with energy storage
            solverRes = solveFBSM(Z_ser,Y_shu,S_ana(:,timeLine(iTime)),...
            U_bus(:,timeLine(iTime)),connectionBuses,busType,...
            maxIter,convEps,doPlot,shuntCap);
            S_hist(:,iTime)  = solverRes.S_out;
            S_loss(:,iTime)  = solverRes.S_loss;
            U_hist(:,iTime)  = solverRes.U_out;
            U_delta(:,iTime) = solverRes.U_delta;
            I_hist(:,iTime)  = solverRes.I_out;
            S_shu1(:,iTime)  = solverRes.S_shu1;
            S_shu2(:,iTime)  = solverRes.S_shu2;
            nItersVec(iTime) = solverRes.nIters;
        end
    end
    if waitBar
        close(barHandle);
    end
    calcTime=toc;
    fprintf('Sweep calculation finished. Calculation time %.1f s.\n',calcTime);
    resultSet.U_hist=U_hist;
    resultSet.U_delta=U_delta;
    resultSet.S_hist=S_hist;
    resultSet.S_loss=S_loss;
    resultSet.I_hist=I_hist;
    resultSet.S_shu1=S_shu1;
    resultSet.S_shu2=S_shu2;
    resultSet.nItersVec=nItersVec;
    resultSet.timeLine=timeLine;
    resultSet.calcTime=calcTime;
    if any(storageCharging)
        resultSet.storageBusNr=storageBusNr;
        resultSet.storageSize=storageSize;
        resultSet.storageDefChargePower=storageDefChgPower;
        resultSet.storageInitialSoC=storageInitialSoC;
        resultSet.storageCharging=storageCharging;
        resultSet.storageSoC=storageSoC;
        resultSet.storageActualChgPower=storageActualChgPower;
        resultSet.storageMaxChgPower=storageMaxChgPower;
    end
end