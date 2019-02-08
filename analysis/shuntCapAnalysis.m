% Shunt capacitor analysis

main;
timeLine=1:744;

%% Without shunt capacitors

% Test with power factor 1
S_ana=S_bus;
resultSet_noshunt_def=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 lagging
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,0);
resultSet_noshunt_lagg=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 leading
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,1);
resultSet_noshunt_lead=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

%% With shunt capacitors

% Test with power factor 1
S_ana=S_bus;
resultSet_shunt_def=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 lagging
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,0);
resultSet_shunt_lagg=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Test with power factor 0.8 leading
S_ana(busIsLoad,:)=createComplexPower(abs(S_bus(busIsLoad,:)),'P',0.8,1);
resultSet_shunt_lead=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);

% Reactive power from shunt capacitors
figure;
plot(resultSet.timeLine,TransformerData.S_base.*imag(resultSet.Q_shu1+resultSet.Q_shu2))
title('Reactive power from shunt capacitors');
xlabel('Timeline');
ylabel('Reactive power [VAr]');
