S_hist=resultSet.S_hist;
U_hist=resultSet.U_hist;

% plot Transformer lv side
powerFig = figure;
powerFig.Name = 'Powers';
plot(timeLine, real(S_hist(2,:).*TransformerData.S_base), 'b')
hold on
plot(timeLine, imag(S_hist(2,:).*TransformerData.S_base), 'r')
plot(timeLine, PowersTransformerSecondary(timeLine,1), 'c--')
plot(timeLine, PowersTransformerSecondary(timeLine,2), 'm--')
legend('Real Power', 'Imag Power', 'Real GridLab', 'Imag GridLab');
xlabel('Time [min]')
ylabel('Power [kW kVAR]')
hold off

% plot Transformer diff
realDiff = real(S_hist(2,:)'.*TransformerData.S_base)-PowersTransformerSecondary(timeLine,1);
imagDiff = imag(S_hist(2,:)'.*TransformerData.S_base)-PowersTransformerSecondary(timeLine,2);
powerdiffFig = figure;
powerdiffFig.Name = 'Power diff';
subplot(2,1,1)
plot(timeLine, realDiff)
xlabel('Time [min]')
ylabel('Power Real difference')
subplot(2,1,2)
plot(timeLine, imagDiff)
xlabel('Time [min]')
ylabel('Power Imag difference')


% voltages
vFig = figure;
vFig.Name = 'Voltages';
title('Voltages');
subplot(3,1,1)
plot(timeLine, abs(U_hist(35,:)), 'b');  % load1 TransformerData.U_sec_base./sqrt(3)
hold on
plot(timeLine, abs(VoltageLoad1(timeLine,1) + VoltageLoad1(timeLine,2)*j)./252, 'r')
title('Load 1')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,2)
plot(timeLine, abs(U_hist(615,:)), 'b'); % load32 TransformerData.U_sec_base./sqrt(3)
hold on
plot(timeLine, abs(VoltageLoad32(timeLine,1) + VoltageLoad32(timeLine,2)*j)./252, 'r')
title('Load 32')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,3)
plot(timeLine, abs(U_hist(900,:)), 'b'); % load53 TransformerData.U_sec_base./sqrt(3)
hold on
plot(timeLine, abs(VoltageLoad53(timeLine,1) + VoltageLoad53(timeLine,2)*j)./252, 'r')
title('Load 53')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

% voltage difference
U_diff_L1=abs(U_hist(35,:))-transpose(abs(VoltageLoad1(timeLine,1) + VoltageLoad1(timeLine,2)*j)./252);
U_diff_L32=abs(U_hist(615,:))-transpose(abs(VoltageLoad32(timeLine,1) + VoltageLoad32(timeLine,2)*j)./252);
U_diff_L53=abs(U_hist(900,:))-transpose(abs(VoltageLoad53(timeLine,1) + VoltageLoad53(timeLine,2)*j)./252);

vDiffFig = figure;
vDiffFig.Name = 'Voltage difference';
subplot(3,1,1)
plot(timeLine, U_diff_L1, 'r')
title('Load 1')
xlabel('Time [min]')
ylabel('Voltage [V]')

subplot(3,1,2)
plot(timeLine, U_diff_L32, 'r')
title('Load 32')
xlabel('Time [min]')
ylabel('Voltage [V]')

subplot(3,1,3)
plot(timeLine, U_diff_L53, 'r')
title('Load 53')
xlabel('Time [min]')
ylabel('Voltage [V]')

hold off