function resultSet=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine)
    tic;
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));
    I_hist = zeros(size(connectionBuses,1), length(timeLine));
    nItersVec=zeros(1,length(timeLine));
    barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
    for iTime = 1:length(timeLine)
        waitbar(iTime/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
                iTime, length(timeLine)));

        solverRes = solveFBSM(Z_ser,Y_shu,S_ana(:,timeLine(iTime)),U_bus(:,timeLine(iTime)),...
                              connectionBuses,busType,1000,1e-3,0);

        S_hist(:,iTime) = solverRes.S_out;
        S_loss(:,iTime) = solverRes.S_loss;
        U_hist(:,iTime) = solverRes.U_out;
        U_loss(:,iTime) = solverRes.U_out;
        I_hist(:,iTime) = solverRes.I_out;
        Q_shu1(:,iTime) = solverRes.Q_shu1;
        Q_shu2(:,iTime) = solverRes.Q_shu2;
        nItersVec(iTime)= solverRes.nIters;
    end
    close(barHandle);
    calcTime=toc;
    fprintf('Sweep calculation finished. Calculation time %.1f s.\n',calcTime);
    resultSet.U_hist=U_hist;
    resultSet.S_hist=S_hist;
    resultSet.I_hist=I_hist;
    resultSet.Q_shu1=Q_shu1;
    resultSet.Q_shu2=Q_shu2;
    resultSet.nItersVec=nItersVec;
    resultSet.timeLine=timeLine;
    resultSet.calcTime=calcTime;
    
end