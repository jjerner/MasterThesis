function resultSet=doSweepCalcs(Z_ser_tot,S_ana,U_bus,connectionBuses,busType,timeLine)
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));
    I_hist = zeros(size(connectionBuses,1), length(timeLine));
    nItersVec=zeros(1,length(timeLine));
    barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
    for iTime = 1:length(timeLine)
        waitbar(iTime/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
                iTime, length(timeLine)));

        solverRes = solveFBSM(Z_ser_tot,S_ana(:,timeLine(iTime)),U_bus(:,timeLine(iTime)),...
                              connectionBuses,busType,1000,1e-3,0);

        S_hist(:,iTime) = solverRes.S_out;
        U_hist(:,iTime) = solverRes.U_out;
        I_hist(:,iTime) = solverRes.I_out;
        nItersVec(iTime)= solverRes.nIters;
    end
    close(barHandle)
    disp('Sweep calculation finished.');
    resultSet.U_hist=U_hist;
    resultSet.S_hist=S_hist;
    resultSet.I_hist=I_hist;
    resultSet.nItersVec=nItersVec;
    resultSet.timeLine=timeLine;
end