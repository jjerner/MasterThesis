
clear

addpath('European_LV_CSV');
addpath('European_LV_CSV/Load Profiles');
addpath('European_LV_CSV/Solutions');
addpath('European_LV_CSV/Solutions/OpenDSS');
addpath('European_LV_CSV/Solutions/OpenDSS/Time Series');
addpath('European_LV_CSV/Solutions/GridLab-D');
addpath('European_LV_CSV/Solutions/GridLab-D/Time Series');
addpath('..');
j = 1i;
freq = 50;

% Read data
Transformer;
Cables;

% Setup arrays and add loads
AddConnectionType;
SetupArrays;

% INPUT
ELVinputs;
verificationProblem;

% CALC
pf = 0.95;

S_complex = createComplexPower(S_bus, pf, 0);

[U_hist,S_hist]=doSweepCalcs(Z_ser_tot, S_complex, U_bus, connectionBuses, busType, 1:1440);

% RESULTS

% comparasion data
load('GridLabData');

% plot Transformer lv side
powerFig = figure;
powerFig.Name = 'Powers';
plot(1:1440, real(S_hist(2,:).*TransformerData.S_base), 'b')
hold on
plot(1:1440, imag(S_hist(2,:).*TransformerData.S_base), 'r')
plot(1:1440, PowersTransformerSecondary(:,1), 'c--')
plot(1:1440, PowersTransformerSecondary(:,2), 'm--')
legend('Real Power', 'Imag Power', 'Real GridLab', 'Imag GridLab');
xlabel('Time [min]')
ylabel('Power [kW kVAR]')
hold off

% voltages
vFig = figure;
vFig.Name = 'Voltages';
subplot(3,1,1)
plot(1:1440, abs(U_hist(35,:).*252), 'b');  % load1 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad1(:,1) + VoltageLoad1(:,2)*j), 'r')
title('Load 1')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,2)
plot(1:1440, abs(U_hist(615,:).*252), 'b'); % load32 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad32(:,1) + VoltageLoad32(:,2)*j), 'r')
title('Load 32')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,3)
plot(1:1440, abs(U_hist(900,:).*252), 'b'); % load53 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad53(:,1) + VoltageLoad53(:,2)*j), 'r')
title('Load 53')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off


