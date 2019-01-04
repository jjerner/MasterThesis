histBusNr = input('Enter node number for histogram: ');
fprintf('\n');
figure;
monthsBeginAt = 1:730:8761;             % Vector with the hour the months begin at
for iMonth = 12:-1:1
    [vHistCount,vHistEdges]= histcounts(abs(resultSet.U_hist(histBusNr,timeLine < monthsBeginAt(iMonth+1) & monthsBeginAt(iMonth) < timeLine)));
    vHistCount(vHistCount == 0) = NaN;      % Ignore zero values
    vHistCenters=vHistEdges(1:end-1)+diff(vHistEdges)./2;
    plot(vHistCenters,vHistCount/100 + 12-iMonth,'LineWidth',2);hold on;
    minV(iMonth)=min(vHistEdges);
    maxV(iMonth)=max(vHistEdges);
end
title(['Voltage histogram at bus ' num2str(histBusNr)]);
ylabel('Month');
xlabel('Voltage [p.u.]');
set(gca,'Xtick',min(minV)-0.1:2*mean(diff(vHistEdges)):max(maxV)+0.1,...
    'Ytick',1:12,'YTickLabel',...
    fliplr({'January','February','March','April',...
    'May','June','July','August',...
    'September','October','November','December'}));
xtickangle(45);
line(0.98*[1 1],[0 13], 'Color', 'r');  % Lower limit line
line(1.00*[1 1],[0 13], 'Color', 'r');  % Upper limit line
grid on;
clear histBusNr monthsBeginAt vHistCount vHistEdges vHistCenters minV maxV iMonth;