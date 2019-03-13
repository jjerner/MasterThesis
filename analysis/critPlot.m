function critPlot(plotStruct, Info, TransformerData, busIsLoad, atIter)
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
if ~exist('atIter','var')
    structName = inputname(1);
    if strcmp(structName ,'EvenDist')     
        %atIter = 17; % 17 nås gränss
        atIter = 26; % 26 är exakt 1 panel per hus

        str = 'Even Dist.';        
        prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
        prodkW = prodkW * length(loadNumber);
    elseif strcmp(structName, 'SelectDist')
        atIter = 49; % 28 nås gräns i weak || 49 nås gräns i strong
        %atIter = 43; % 43 samma total prod som iter 17 i EvenDist (ish)
        
        str = 'Selected Dist.';
        prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
        prodkW = prodkW * plotStruct(atIter).PvSystemsAdded;
    else
        atIter  = 2;  %random
        
        str = 'Even Dist.'; 
        prodkW = max(plotStruct(atIter).PvPowerPerLoad).*TransformerData.S_base./1000;
        prodkW = prodkW * length(loadNumber);
    end
end

critload = find(loadNumber == plotStruct(atIter).Critical.maxVoltage.BusNumber);
%critload = 49;
fprintf('Crit bus = %d \n', loadNumber(critload))


% Plot av fallet där kritisk spänning uppnåtts samt fallet utan produktion
% för eventuell jämförelse
figure('Position', [170, 180, 1000, 500]);
% sgtitle(['Critical Bus, ', num2str(plotStruct(atIter).Critical.maxVoltage.BusNumber),...
%        ' Produced Power: ', num2str(prodkW), ' kW'])
sgtitle(['Critical Bus: ', num2str(loadNumber(critload)), ', ', ' Total Power Production: ', num2str(round(prodkW)), ' kW'])
subplot(2,1,1)
plot(timeLine, abs(plotStruct(atIter).Results.U_hist(critload,:)).*TransformerData.U_sec_base./sqrt(3),'b')
hold on
plot(timeLine, abs(plotStruct(1).Results.U_hist(critload,:)).*TransformerData.U_sec_base./sqrt(3),'g')
plot(timeLine, ones(length(timeLine),1).*230*1.1,'r')
xlim([0,timeLine(end)]);
ylim([215, 260]);
set(gca,'xtick',monthTick,'xticklabel',months)
grid on
title('Voltage')
ylabel('Voltage (line-to-neutral) [V]')
legend({'with production';'no production'},'Location', 'northeast')

subplot(2,1,2)
plot(timeLine, real(plotStruct(atIter).Results.S_hist(critload,:)).*TransformerData.S_base./1000,'b')
hold on
plot(timeLine, real(plotStruct(1).Results.S_hist(critload,:)).*TransformerData.S_base./1000,'g')
%plot(timeLine, ones(length(timeLine),1).*0,'r')
xlim([0,timeLine(end)]);
ylim([-9, 9])
set(gca,'xtick',monthTick,'xticklabel',months)
grid on
title('Power')
ylabel('Power [kW]')
legend({'with production';'no production'},'Location', 'southeast')


end
