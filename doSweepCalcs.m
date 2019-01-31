function resultSet=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,waitBar)
    if ~exist('waitBar','var'), waitBar = true; end    % Default value for waitbar
    global Settings;
    tic;
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
        solverRes = solveFBSM(Z_ser,Y_shu,S_ana(:,timeLine(iTime)),...
            U_bus(:,timeLine(iTime)),connectionBuses,busType,...
            Settings.defaultMaxIter,Settings.defaultConvEps,0);
        S_hist(:,iTime)  = solverRes.S_out;
        S_loss(:,iTime)  = solverRes.S_loss;
        U_hist(:,iTime)  = solverRes.U_out;
        U_delta(:,iTime) = solverRes.U_delta;
        I_hist(:,iTime)  = solverRes.I_out;
        Q_shu1(:,iTime)  = solverRes.Q_shu1;
        Q_shu2(:,iTime)  = solverRes.Q_shu2;
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
    resultSet.I_hist=I_hist;
    resultSet.Q_shu1=Q_shu1;
    resultSet.Q_shu2=Q_shu2;
    resultSet.nItersVec=nItersVec;
    resultSet.timeLine=timeLine;
    resultSet.calcTime=calcTime;
end