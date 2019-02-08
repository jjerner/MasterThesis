% Load power factor analysis

main;
timeLine=1:8760;

% Test with power factor 1
S_ana=S_bus;
resultSet_def=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 lagging
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,0);
resultSet_lagg=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 leading
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,1);
resultSet_lead=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Plots
busesToPlot=114;
plotTimeLine=90:135;

figure;
hold on;
plot(plotTimeLine,abs(resultSet_def.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
plot(plotTimeLine,abs(resultSet_lagg.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
plot(plotTimeLine,abs(resultSet_lead.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
title('Voltage');
xlabel('Timeline [h]');
ylabel('Voltage (line-to-neutral) [V]');
legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_U.png');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_U','epsc');

figure;
hold on;
plot(plotTimeLine,real(resultSet_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,real(resultSet_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,real(resultSet_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
title('Active power');
xlabel('Timeline [h]');
ylabel('Active power [W]');
legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_P.png');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_P','epsc');

figure;
hold on;
plot(plotTimeLine,imag(resultSet_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,imag(resultSet_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,imag(resultSet_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
title('Reactive power');
xlabel('Timeline [h]');
ylabel('Reactive power [VAr]');
legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_Q.png');
saveas(gcf,'analysis/fig/loadPowerFactorAnalysis_Q','epsc');