% Greedy search to find best-case order when adding PV power

% Bus vectors
allBuses=1:Info.nBuses;
loadBuses=allBuses(busIsLoad);

% Result without production, for comparison
ResultNoProd=doSweepCalcs(Z_ser,Y_shu,S_bus,U_bus,connectionBuses,busType,timeLine);

% Get PV power data
pvPower=PV_model(1,1,1,3)./TransformerData.S_base;
pvPower=pvPower(timeLine)';

% At first step
addedPvPowerAt=[];
busesToTest=loadBuses;

for iStep=1:length(loadBuses)
    for iOption=1:length(busesToTest)
        pvBusesInSweep=[addedPvPowerAt; busesToTest(iOption)];
        S_greedy=S_bus;
        S_greedy(pvBusesInSweep,timeLine)=S_greedy(pvBusesInSweep,timeLine)...
            -repmat(pvPower,size(pvBusesInSweep,1),1);
        ResultTemp=doSweepCalcs(Z_ser,Y_shu,S_greedy,U_bus,connectionBuses,busType,timeLine,false);
        diffU=abs(abs(ResultTemp.U_hist(busesToTest,:))-abs(ResultNoProd.U_hist(busesToTest,:)));
        [rowMinDiff, timeMinDiff] = find(diffU == min(min(diffU)));
        minDiffUAtBus(iOption) = busesToTest(rowMinDiff(1));
        minDiffU(iOption) = min(min(diffU));
    end
    [minDiffUChoice,minDiffUAtBusChoice]=min(minDiffU);
    chosenBus=minDiffUAtBus(minDiffUAtBusChoice);
    busesToTest(find(busesToTest==chosenBus))=[];
    addedPvPowerAt(iStep,1)=chosenBus;
    clear minDiffUAtBus minDiffU;
    fprintf('Greedy search: Step %d finished. Chose bus %d.\n',iStep,chosenBus);
end