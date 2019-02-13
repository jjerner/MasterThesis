% Shunt capacitor analysis

main;
timeLine=1:744;

%% Without shunt capacitors

% Test with power factor 1
S_ana=S_bus;
resultSet_noshunt_def=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,0);

% Test with power factor 0.8 lagging
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,0);
resultSet_noshunt_lagg=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,0);

% Test with power factor 0.8 leading
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,1);
resultSet_noshunt_lead=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,0);

%% With shunt capacitors

% Test with power factor 1
S_ana=S_bus;
resultSet_shunt_def=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,1);

% Test with power factor 0.8 lagging
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,0);
resultSet_shunt_lagg=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,1);

% Test with power factor 0.8 leading
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,1);
resultSet_shunt_lead=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,1);

%% Plots

busesToPlot=1;
plotTimeLine=90:135;

figure;
hold on;
plot(plotTimeLine,abs(resultSet_noshunt_def.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
%plot(plotTimeLine,abs(resultSet_noshunt_lagg.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
%plot(plotTimeLine,abs(resultSet_noshunt_lead.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
plot(plotTimeLine,abs(resultSet_shunt_def.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
%plot(plotTimeLine,abs(resultSet_shunt_lagg.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
%plot(plotTimeLine,abs(resultSet_shunt_lead.U_hist(busesToPlot,plotTimeLine)).*TransformerData.U_sec_base/sqrt(3));
title('Voltage');
xlabel('Timeline [h]');
ylabel('Voltage (line-to-neutral) [V]');
%legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/shuntCapAnalysis_U.png');
saveas(gcf,'analysis/fig/shuntCapAnalysis_U','epsc');

figure;
hold on;
plot(plotTimeLine,real(resultSet_noshunt_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,real(resultSet_noshunt_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,real(resultSet_noshunt_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,real(resultSet_shunt_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,real(resultSet_shunt_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,real(resultSet_shunt_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
title('Active power');
xlabel('Timeline [h]');
ylabel('Active power [W]');
%legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/shuntCapAnalysis_P.png');
saveas(gcf,'analysis/fig/shuntCapAnalysis_P','epsc');

figure;
hold on;
plot(plotTimeLine,imag(resultSet_noshunt_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,imag(resultSet_noshunt_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,imag(resultSet_noshunt_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
plot(plotTimeLine,imag(resultSet_shunt_def.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,imag(resultSet_shunt_lagg.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
%plot(plotTimeLine,imag(resultSet_shunt_lead.S_hist(busesToPlot,plotTimeLine)).*TransformerData.S_base);
title('Reactive power');
xlabel('Timeline [h]');
ylabel('Reactive power [VAr]');
%legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/shuntCapAnalysis_Q_tot.png');
saveas(gcf,'analysis/fig/shuntCapAnalysis_Q_tot','epsc');

% Total reactive power from shunt capacitors (sum of all connections)
plotTimeLine=90:135;
figure;
hold on;
plot(plotTimeLine,TransformerData.S_base.*imag(sum(resultSet_shunt_def.S_shu1(:,plotTimeLine)+resultSet_shunt_def.S_shu2(:,plotTimeLine),1)));
plot(plotTimeLine,TransformerData.S_base.*imag(sum(resultSet_shunt_lagg.S_shu1(:,plotTimeLine)+resultSet_shunt_lagg.S_shu2(:,plotTimeLine),1)));
plot(plotTimeLine,TransformerData.S_base.*imag(sum(resultSet_shunt_lead.S_shu1(:,plotTimeLine)+resultSet_shunt_lead.S_shu2(:,plotTimeLine),1)));
title('Reactive power from shunt capacitors');
xlabel('Timeline');
ylabel('Reactive power [VAr]');
legend('cos\phi=1','cos\phi=0.8 ind','cos\phi=0.8 cap');
saveas(gcf,'analysis/fig/shuntCapAnalysis_Q_shunt.png');
saveas(gcf,'analysis/fig/shuntCapAnalysis_Q_shunt','epsc');