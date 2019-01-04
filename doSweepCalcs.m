function resultSet=doSweepCalcs(Z_ser_tot,S_ana,U_bus,connectionBuses,busType,timeLine)
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));
    nItersVec=zeros(1,length(timeLine));
    barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
    for iTime = 1:length(timeLine)
        waitbar(iTime/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
                iTime, length(timeLine)));

        [S_out,U_out,nIters] = solveFBSM(Z_ser_tot,S_ana(:,timeLine(iTime)),U_bus(:,timeLine(iTime)),...
                              connectionBuses,busType,1000,1e-3,0);

        S_hist(:,iTime) = S_out;
        U_hist(:,iTime) = U_out;
        nItersVec(iTime)=nIters;
    end
    close(barHandle)
    disp('Sweep calculation finished.');
    resultSet.U_hist=U_hist;
    resultSet.S_hist=S_hist;
    resultSet.nItersVec=nItersVec;
    resultSet.timeLine=timeLine;
end