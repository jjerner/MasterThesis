S_hist=verResultSet.S_hist;
U_hist=verResultSet.U_hist;

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

% plot Transfoermer diff
realDiff = real(S_hist(2,:)'.*TransformerData.S_base)-PowersTransformerSecondary(:,1);
imagDiff = imag(S_hist(2,:)'.*TransformerData.S_base)-PowersTransformerSecondary(:,2);
powerdiffFig = figure;
powerdiffFig.Name = 'Power diff';
subplot(2,1,1)
plot(1:1440, realDiff)
xlabel('Time [min]')
ylabel('Power Real difference')
subplot(2,1,2)
plot(1:1440, imagDiff)
xlabel('Time [min]')
ylabel('Power Imag difference')


% voltages
vFig = figure;
vFig.Name = 'Voltages';
subplot(3,1,1)
plot(1:1440, abs(U_hist(35,:)), 'b');  % load1 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad1(:,1) + VoltageLoad1(:,2)*j)./252, 'r')
title('Load 1')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,2)
plot(1:1440, abs(U_hist(615,:)), 'b'); % load32 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad32(:,1) + VoltageLoad32(:,2)*j)./252, 'r')
title('Load 32')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off

subplot(3,1,3)
plot(1:1440, abs(U_hist(900,:)), 'b'); % load53 TransformerData.U_sec_base./sqrt(3)
hold on
plot(1:1440, abs(VoltageLoad53(:,1) + VoltageLoad53(:,2)*j)./252, 'r')
title('Load 53')
xlabel('Time [min]')
ylabel('Voltage [V]')
legend('Our', 'GridLab');
hold off