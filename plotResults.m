function plotResults(resultSet,busIsLoad,loadsOnly)
    timeLine=resultSet.timeLine;
    dataTimeLine=1:length(timeLine);
    if ~exist('loadsOnly','var'), loadsOnly = false; end      % Create load plots only is off by default 

    if ~loadsOnly
        figure;
        plot(timeLine,abs(resultSet.U_hist(:,dataTimeLine)));
        title('Voltage (all)');

        figure;
        plot(timeLine,real(resultSet.S_hist(:,dataTimeLine)));
        title('Active power (all)');

        figure;
        plot(timeLine,imag(resultSet.S_hist(:,dataTimeLine)));
        title('Reactive power (all)');
    else
        figure;
        plot(timeLine,abs(resultSet.U_hist(busIsLoad,dataTimeLine)));
        title('Voltage (loads)');

        figure;
        plot(timeLine,real(resultSet.S_hist(busIsLoad,dataTimeLine)));
        title('Active power (loads)');

        figure;
        plot(timeLine,imag(resultSet.S_hist(busIsLoad,dataTimeLine)));
        title('Reactive power (loads)');
    end
end