%% Reset power to input
S_ana=S_bus;
disp('All bus powers reset to input values.');

%% Change power factor
setPowerFactor=false;
newPowerFactor=0.8;
newPowerFactorLeading=false;
if ~exist('S_ana','var'), S_ana = S_bus; end            % Powers for analysis set to inputs
if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
    disp('Load input contains only active powers.');
else
    disp('Load input contains both active and reactive powers.');
end

if setPowerFactor
    S_ana(busIsLoad,:)=createComplexPower(S_ana(busIsLoad,:),newPowerFactor,newPowerFactorLeading);
    fprintf('Power factor for all loads changed to %g',newPowerFactor)
    if newPowerFactorLeading, fprintf(' leading.\n'); else, fprintf(' lagging.\n'); end
else
    disp('Power factor unchanged.');
end

%% Add DG power

if ~exist('S_ana','var'), S_ana = S_bus; end
productionAtBus=[118;120];          % Bus nr to add production to
productionAtTime=70:170;            % Time interval for production
productionPower=[1e-3;1e-2];        % Power [p.u.]

S_ana(productionAtBus,productionAtTime)=S_ana(productionAtBus,productionAtTime)...
    -productionPower;
fprintf('Added %g p.u. production at node %d\n',[productionPower productionAtBus]');

%% Run sweep calculation

if ~exist('S_ana','var'), S_ana = S_bus; end

% Set timeline
tJan = 1:24*31;
tFeb = 1+(24*31):24*(28+31);
tMar = 1+(24*(31+28)):24*(31+28+31);
tJFM = [tJan tFeb tMar];
tAll = 1:length(Input(1).values);

timeLine = tJan;

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

% figure;
% for iPlotU = 1:size(U_hist(busIsLoad,:), 1)
%     plot(abs(U_hist(iPlotU,:)))
%     title('Voltage')
%     ylabel('voltage [pu]')
%     xlabel('time [h]')
%     hold on
% end
% 
% figure;
% for iPlotP = 1:size(S_hist, 1)
%     plot(real(S_hist(iPlotP,:)))
%     title('Active Power')
%     hold on
% end
% 
% figure;
% for iPlotQ = 1:size(S_hist, 1)
%     plot(imag(S_hist(iPlotQ,:)))
%     title('Reactive Power')
%     hold on
% end

%% Plot all

figure;
plot(timeLine,abs(U_hist));
title('Voltage (all)');

figure;
plot(timeLine,P_hist);
title('Active power (all)');

figure;
plot(timeLine,Q_hist);
title('Reactive power (all)');

%% Plot loads only

figure;
plot(timeLine,abs(U_hist(busIsLoad,:)));
title('Voltage (loads)');

figure;
plot(timeLine,P_hist(busIsLoad,:));
title('Active power (loads)');

figure;
plot(timeLine,Q_hist(busIsLoad,:));
title('Reactive power (loads)');

%% Analyze voltages

[maxVoltageVec,maxVoltageTimeVec]=max(abs(U_hist),[],2);   % Max voltage for each bus
[minVoltageVec,minVoltageTimeVec]=min(abs(U_hist),[],2);   % Min voltage for each bus

[maxVoltage,maxVoltageBusNr]=max(maxVoltageVec);           % Max voltage and bus number
[minVoltage,minVoltageBusNr]=min(minVoltageVec);           % Min voltage and bus number

[maxLoadVoltage,maxLoadVoltageBusNr]=max(maxVoltageVec(busIsLoad));   % Max load voltage and bus number*
[minLoadVoltage,minLoadVoltageBusNr]=min(minVoltageVec(busIsLoad));   % Min load voltage and bus number*
% *=numbered according to load buses only

allBusNrVec=1:nBuses;
loadBusNrVec=allBusNrVec(busIsLoad);
maxLoadVoltageBusNr=loadBusNrVec(maxLoadVoltageBusNr);     % Change to global bus numbering
minLoadVoltageBusNr=loadBusNrVec(minLoadVoltageBusNr);     % Change to global bus numbering

maxVoltageTimeStep=maxVoltageTimeVec(maxVoltageBusNr);     % Time (col) for max voltage
minVoltageTimeStep=minVoltageTimeVec(minVoltageBusNr);     % Time (col) for min voltage
maxLoadVoltageTimeStep=maxVoltageTimeVec(maxLoadVoltageBusNr);     % Time (col) for max load voltage
minLoadVoltageTimeStep=minVoltageTimeVec(minLoadVoltageBusNr);     % Time (col) for min load voltage

fprintf('Maximum voltage: %g at (%d,%d)\n',maxVoltage,maxVoltageBusNr,maxVoltageTimeStep);
fprintf('Minimum voltage: %g at (%d,%d)\n',minVoltage,minVoltageBusNr,minVoltageTimeStep);
fprintf('Maximum load voltage: %g at (%d,%d)\n',maxLoadVoltage,maxLoadVoltageBusNr,maxLoadVoltageTimeStep);
fprintf('Minimum load voltage: %g at (%d,%d)\n',minLoadVoltage,minLoadVoltageBusNr,minLoadVoltageTimeStep);

% fprintf('Minimum voltage difference: %g\n',minLoadVdiff);
% fprintf('Maximum voltage difference: %g\n',maxLoadVdiff);