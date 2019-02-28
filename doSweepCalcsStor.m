function resultSet=doSweepCalcsStor(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,waitBar,shuntCap)
    global Settings;
    maxIter = Settings.defaultMaxIter;    % Default value for maximum number of iterations
    convEps = Settings.defaultConvEps;    % Default convergence limit
    doPlot  = Settings.defaultConvPlots;  % Default value for plot creation
    if ~exist('waitBar','var'),  waitBar  = Settings.defaultWaitBar;   end    % Default value for waitbar
    if ~exist('shuntCap','var'), shuntCap = Settings.defaultShuntCap;  end    % Default value for shunt capacitance
    
    tic;
    
    storageBusNr=[114 120];                 % Place storage at bus number
    storageSize=[30e3 30e3];                % Size of energy storage [Wh]
    storageDefChgPower=[1.1e3 1.9e3];    % Charging power of energy storage [W]
    storageInitialSoC=[0 0];                % Initial energy storage state of charge [-]
    storageCharging=ones(length(storageBusNr),length(timeLine));
    storageSoC=nan(length(storageBusNr),length(timeLine));
    
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));
    U_delta = zeros(size(connectionBuses,1), length(timeLine));
    I_hist = zeros(size(connectionBuses,1), length(timeLine));
    nItersVec=zeros(1,length(timeLine));
    if waitBar
       barHandle = waitbar(0, '1', 'Name', 'Calculating'); 
    end
    for iTime = 1:length(timeLine)
        if waitBar
            waitbar(iTime/length(timeLine), barHandle,...
                sprintf('Sweep calculation %d/%d',iTime,length(timeLine)));
        end
        
        for iStor=1:length(storageBusNr)
            if iTime > 1 && storageSoC(iStor,iTime-1) >= 1
                % Immediate discharge if full
                storageSoC(iStor,iTime) = 0;
                storageDischargedAt(iStor,iTime)=true;
            elseif iTime > 1 && storageSoC(iStor,iTime-1) < 1
                % Not discharging
                storageSoC(iStor,iTime) = storageSoC(iStor,iTime-1);
                storageDischargedAt(iStor,iTime)=false;
            end

            if storageCharging(iStor,iTime)
                S_ana(storageBusNr(iStor),iTime)=S_ana(storageBusNr(iStor),timeLine(iTime))+storageDefChgPower(iStor)/5e5;
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
    resultSet.storageBusNr=storageBusNr;
    resultSet.storageSize=storageSize;
    resultSet.storageDefChargePower=storageDefChgPower;
    resultSet.storageInitialSoC=storageInitialSoC;
    resultSet.storageCharging=storageCharging;
    resultSet.storageSoC=storageSoC;
    resultSet.storageActualChgPower=storageActualChgPower;
    resultSet.storageMaxChgPower=storageMaxChgPower;
end