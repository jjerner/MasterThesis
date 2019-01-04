function plotResults(resultSet,busIsLoad,loadsOnly)
    timeLine=resultSet.timeLine;
    if ~exist('loadsOnly','var'), loadsOnly = false; end      % Create load plots only is off by default 

    if ~loadsOnly
        figure;
        plot(timeLine,abs(resultSet.U_hist(:,timeLine)));
        title('Voltage (all)');

        figure;
        plot(timeLine,real(resultSet.S_hist(:,timeLine)));
        title('Active power (all)');

        figure;
        plot(timeLine,imag(resultSet.S_hist(:,timeLine)));
        title('Reactive power (all)');
    else
        figure;
        plot(timeLine,abs(resultSet.U_hist(busIsLoad,timeLine)));
        title('Voltage (loads)');

        figure;
        plot(timeLine,real(resultSet.S_hist(busIsLoad,timeLine)));
        title('Active power (loads)');

        figure;
        plot(timeLine,imag(resultSet.S_hist(busIsLoad,timeLine)));
        title('Reactive power (loads)');
    end
end