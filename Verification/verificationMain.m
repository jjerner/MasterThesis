
clear

addpath('European_LV_CSV');
addpath('European_LV_CSV/Load Profiles');
addpath('..');
j = 1i;
freq = 50;

% Read data
Transformer;
Cables;

% Setup arrays and add loads
AddConnectionType;
SetupArrays;

% inputs
ELVinputs;
verificationProblem;

pf = 0.95;

S_complex = createComplexPower(S_bus, pf, 0);

[U_hist,S_hist]=doSweepCalcs(Z_ser_tot, S_complex, U_bus, connectionBuses, busType, 1:1440);

% plot Transformer lv side
figure;
plot(1:1440, real(S_hist(2,:).*TransformerData.S_base))
hold on
plot(1:1440, imag(S_hist(2,:).*TransformerData.S_base))
hold off

% voltages
figure;
plot(1:1440, abs(U_hist(35,:).*TransformerData.U_sec_base./sqrt(3)), 'b');  % load1
hold on
plot(1:1440, abs(U_hist(615,:).*TransformerData.U_sec_base./sqrt(3)), 'r'); % load32
hold on
plot(1:1440, abs(U_hist(900,:).*TransformerData.U_sec_base./sqrt(3)), 'g'); % load53
hold off