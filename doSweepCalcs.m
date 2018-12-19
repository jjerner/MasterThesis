function [U_hist,S_hist]=doSweepCalcs(Z_ser_tot,S_ana,U_bus,connectionBuses,busType,timeLine)
    S_hist = zeros(size(S_ana,1), length(timeLine));
    U_hist = zeros(size(U_bus,1), length(timeLine));

    barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
    for iter = 1:length(timeLine)
        waitbar(iter/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
                iter, length(timeLine)));

        [S_out, U_out] = solveFBSM(Z_ser_tot,S_ana(:,timeLine(iter)),U_bus(:,timeLine(iter)),...
                              connectionBuses,busType,1000,1e-3,0);

        S_hist(:,iter) = S_out;
        U_hist(:,iter) = U_out;
    end
    close(barHandle)
    disp('Sweep calculation finished.');
end