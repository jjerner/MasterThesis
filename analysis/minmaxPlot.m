function minmaxPlot(plotStruct, Info, TransformerData, busIsLoad)
% 
% atIter not needed

busNumber = (1:Info.nBuses)';
loadNumber = busNumber(busIsLoad);
minAllowed = 230*0.9 / (TransformerData.U_sec_base/sqrt(3));
maxAllowed = 230*1.1 / (TransformerData.U_sec_base/sqrt(3));
timeLine = 1:length(plotStruct(1).Results.U_hist(1,1:end));
months = [{'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'}];
months2 = [{'jan', 'mar', 'may', 'jul', 'sep', 'nov'}];
monthTick = [0, 745, 1417, 2161, 2881, 3625, 4345, 5089, 5833, 6553, 7297, 8017];
monthTick2 = [0, 1417, 2881, 4345, 5833, 7297];


% Analysera plotStruct
structName = inputname(1);
if strcmp(structName ,'EvenDist')     
    atIter = 17; % 17 nås gräns
    %atIter = 26; % 26 är exakt 1 panel per hus
    atIter = 1;
    
    str = 'Even Dist.';        
    prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
    prodkW = prodkW * length(loadNumber);
elseif strcmp(structName, 'SelectDist')
    %atIter = 40; % 28 nås gräns i weak || 40 nås gräns i strong
    atIter = 43; % 43 samma total prod som iter 17 i EvenDist (ish)
    
    str = 'Selected Dist.';
    prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
    prodkW = prodkW * plotStruct(atIter).PvSystemsAdded;
else
    atIter  = 6;  %random

    str = 'Even Dist.'; 
    prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
    prodkW = prodkW * length(loadNumber);
end

critloadmax = find(loadNumber == plotStruct(atIter).Critical.maxMeanVoltage.BusNumer(1));
critloadmin = find(loadNumber == plotStruct(atIter).Critical.minMeanVoltage.BusNumber(1));
fprintf('max bus = %d \n', loadNumber(critloadmax))


% Plot av fallet där kritisk spänning uppnåtts samt fallet utan produktion
% för eventuell jämförelse
figure('Position', [170, 180, 1200, 400]);
% sgtitle(['Critical Bus, ', num2str(plotStruct(atIter).Critical.maxVoltage.BusNumber),...
%        ' Produced Power: ', num2str(prodkW), ' kW'])
sgtitle(['Highest mean Bus: ', num2str(loadNumber(critloadmax)), ', Lowest mean Bus: ', num2str(loadNumber(critloadmin))])
subplot(1,2,1)
plot(timeLine, abs(plotStruct(atIter).Results.U_hist(critloadmax,:)).*TransformerData.U_sec_base./sqrt(3),'b')
hold on
%plot(timeLine, abs(plotStruct(1).Results.U_hist(critloadmax,:)).*TransformerData.U_sec_base./sqrt(3),'g')
plot(timeLine, ones(length(timeLine),1).*230*1.1,'r')
plot(timeLine, ones(length(timeLine),1).*230*0.9,'r')
xlim([0,timeLine(end)]);
ylim([205, 255]);
set(gca,'xtick',monthTick2,'xticklabel',months2)
grid on
title('Highest mean Bus Voltage')
ylabel('Voltage (line-to-neutral) [V]')
legend({'with production';'no production'},'Location', 'southeast')

subplot(1,2,2)
plot(timeLine, abs(plotStruct(atIter).Results.U_hist(critloadmin,:)).*TransformerData.U_sec_base./sqrt(3),'b')
hold on
%plot(timeLine, abs(plotStruct(1).Results.U_hist(critloadmin,:)).*TransformerData.U_sec_base./sqrt(3),'g')
plot(timeLine, ones(length(timeLine),1).*230*1.1,'r')
plot(timeLine, ones(length(timeLine),1).*230*0.9,'r')
xlim([0,timeLine(end)]);
ylim([205, 255]);
set(gca,'xtick',monthTick2,'xticklabel',months2)
grid on
title('Lowest mean Bus Voltage')
ylabel('Voltage (line-to-neutral) [V]')
legend({'with production';'no production'},'Location', 'southeast')


% subplot(2,2,1)
% plot(timeLine, abs(plotStruct(1).Results.U_hist(critload,:)).*TransformerData.U_sec_base./sqrt(3))
% hold on
% plot(timeLine, ones(length(timeLine),1).*230*1.1,'r')
% xlim([0,timeLine(end)]);
% set(gca,'xtick',monthTick2,'xticklabel',months2)
% grid on
% title('Voltage without Production')
% ylabel('Voltage (line-to-neutral) [V]')
% 
% subplot(2,2,3)
% plot(timeLine, real(plotStruct(1).Results.S_hist(critload,:)).*TransformerData.S_base./1000)
% title('Power without Production')
% ylabel('Power [kW]')
% xlim([0,timeLine(end)]);
% set(gca,'xtick',monthTick2,'xticklabel',months2)
% grid on


% % Hitta unika kritiska bussar och sedan plotta spänningsökningen i extrempunkten
%
% for asd = 2:length(plotStruct) % börja på 2 för att plats 1 är utan prod.
%     criticalBuses(asd-1,1) = plotStruct(asd).Critical.maxVoltage.BusNumber;
%     critTime(asd-1,1) = plotStruct(asd).Critical.maxVoltage.TimeStamp;
% end
% 
% crit = [criticalBuses, critTime];
% 
% crit_unique = crit(1,:);
% for asd = 1:size(crit,1)
%     if ~ismember(crit(asd,:),crit_unique,'rows')
%         crit_unique(end+1,:) = crit(asd,:);
%     end
% end
% 
% for iBus = 1:size(crit_unique,1)
%     bus = crit_unique(iBus, 1);
%     time = crit_unique(iBus, 2);
%     critload = find(loadNumber == bus);
%     
%     for qwe = 1:length(plotStruct)
%         voltage(qwe) = abs(plotStruct(qwe).Results.U_hist(critload,time)*TransformerData.U_sec_base/sqrt(3));
%         prod(qwe) = plotStruct(qwe).PvPowerPerLoad(1,time)*(TransformerData.S_base/1000);
%     end
%     
%     figure
%     plot(prod, voltage)
%     title(['Bus', num2str(bus), ' at time: ', num2str(time)])
%     xlabel('PV-production [kW]')
%     ylabel('Voltage [V]')
%     
% end

end