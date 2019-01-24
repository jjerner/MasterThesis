% Greedy search to find worst-case order when adding PV power

% Bus vectors
allBuses=1:Info.nBuses;
loadBuses=allBuses(busIsLoad);

% Get PV power data
pvPower=PV_model(1,1,1,4)./TransformerData.S_base;
pvPower=pvPower(timeLine)';

% At first step
addedPvPowerAt=[];
busesToTest=loadBuses;

for iStep=1:length(busesToTest)
    for iOption=1:length(busesToTest)
        pvBusesInSweep=[addedPvPowerAt; busesToTest(iOption)];
        S_greedy=S_bus;
        S_greedy(pvBusesInSweep,timeLine)=S_greedy(pvBusesInSweep,timeLine)...
            -repmat(pvPower,size(pvBusesInSweep,1),1);
        res=doSweepCalcs(Z_ser,Y_shu,S_greedy,U_bus,connectionBuses,busType,timeLine);
        % / save res  for later /
    end
    % / choose something based on res /
    chosenBus=6;
    busesToTest(find(busesToTest==chosenBus))=[];
    addedPvPowerAt(iStep,1)=chosenBus;
end