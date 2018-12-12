%{
j=1i;
busTypes=['SL';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ'];
V_0=ones(length(busTypes),1);
P_inj=[NaN NaN NaN NaN 1 1.05 NaN 1 1.1 0 0.9 1 1.05 0.8];
Q_inj=[NaN NaN NaN NaN 0.1 0 NaN 0 0 0 0 0.1 0 0];
S_in=P_inj+j*Q_inj;
%gsres=solveGS(Y_bus,busTypes,V_0,P_inj,Q_inj,1,1)
[S_out,U_out]=fbsm(Z_ser_tot,S_in,V_0,connectionBuses,busType,50,1e-3,1)

%}
%% Load power factor
setPowerFactor=true;
newPowerFactor=0.8;
newPowerFactorLeading=false;
S_ana=S_bus;            % Powers for analysis set to inputs
if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
    disp('Note: Load input contains only active powers.');
else
    disp('Note: Load input contains both active and reactive powers.');
end

if setPowerFactor
    S_ana(busIsLoad,:)=createComplexPower(S_ana(busIsLoad,:),newPowerFactor,newPowerFactorLeading);
    fprintf('Note: Power factor for all loads changed to %g',newPowerFactor)
    if newPowerFactorLeading, fprintf(' leading.\n'); else, fprintf(' lagging.\n'); end
else
    disp('Note: Power factor unchanged.');
end

%% Hallonvägen

%main
%[S_out2,U_out2]=fbsm(Z_ser_tot, S_bus(:,1), U_bus(:,1), connectionBuses, busType, 100, 1e-3, 1)

%month
jan = 1:24*31;
feb = 1+(24*31):24*(28+31);
mar = 1+(24*(31+28)):24*(31+28+31);
JFM = [jan feb mar];

timeLine = JFM;

S_hist = zeros(size(S_bus,1), length(timeLine));
U_hist = zeros(size(U_bus,1), length(timeLine));

barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
for iter = 1:length(timeLine)
    waitbar(iter/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
            iter, length(timeLine)));
        
    [S_out, U_out] = fbsm(Z_ser_tot, S_ana(:,timeLine(iter)), U_bus(:,timeLine(iter)),...
                          connectionBuses, busType, 1000, 1e-3, 0);
    
    S_hist(:,iter) = S_out;
    U_hist(:,iter) = U_out;
end
close(barHandle)
disp('Sweep calculation finished.');

P_hist = real(S_hist);
Q_hist = imag(S_hist);

%% plots

figure;
for iPlotU = 1:size(U_hist(busIsLoad,:), 1)
    plot(abs(U_hist(iPlotU,:)))
    title('Voltage')
    ylabel('voltage [pu]')
    xlabel('time [h]')
    hold on
end

figure;
for iPlotP = 1:size(S_hist, 1)
    plot(real(S_hist(iPlotP,:)))
    title('Active Power')
    hold on
end

figure;
for iPlotQ = 1:size(S_hist, 1)
    plot(imag(S_hist(iPlotQ,:)))
    title('Reactive Power')
    hold on
end

%% Analyze loads

figure;
plot(timeLine,abs(U_hist(busIsLoad,:)));
title('Voltage (loads)');

figure;
plot(timeLine,P_hist(busIsLoad,:));
title('Active power (loads)');

figure;
plot(timeLine,Q_hist(busIsLoad,:));
title('Reactive power (loads)');

minLoadVoltage=min(min(abs(U_hist(busIsLoad,:))));
maxLoadVoltage=max(max(abs(U_hist(busIsLoad,:))));
minLoadVdiff=min(max(abs(U_hist(busIsLoad,:)),[],2)-min(abs(U_hist(busIsLoad,:)),[],2));
maxLoadVdiff=max(max(abs(U_hist(busIsLoad,:)),[],2)-min(abs(U_hist(busIsLoad,:)),[],2));

fprintf('Minimum load voltage: %g\n',minLoadVoltage);
fprintf('Maximum load voltage: %g\n',maxLoadVoltage);
fprintf('Minimum load voltage difference: %g\n',minLoadVdiff);
fprintf('Maximum load voltage difference: %g\n',maxLoadVdiff);