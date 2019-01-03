function plotResults(U_hist,S_hist,timeLine,busIsLoad,loadsOnly)
    if ~exist('loadsOnly','var'), loadsOnly = false; end      % Create load plots only is off by default 

    if ~loadsOnly
        figure;
        plot(timeLine,abs(U_hist(:,timeLine)));
        title('Voltage (all)');

        figure;
        plot(timeLine,real(S_hist(:,timeLine)));
        title('Active power (all)');

        figure;
        plot(timeLine,imag(S_hist(:,timeLine)));
        title('Reactive power (all)');
    else
        figure;
        plot(timeLine,abs(U_hist(busIsLoad,timeLine)));
        title('Voltage (loads)');

        figure;
        plot(timeLine,real(S_hist(busIsLoad,timeLine)));
        title('Active power (loads)');

        figure;
        plot(timeLine,imag(S_hist(busIsLoad,timeLine)));
        title('Reactive power (loads)');
    end
end