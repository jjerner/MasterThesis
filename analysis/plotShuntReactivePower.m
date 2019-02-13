% Total reactive power from shunt capacitors (sum of all connections)
plotTimeLine=timeLine;
figure;
hold on;
plot(plotTimeLine,TransformerData.S_base.*imag(sum(resultSet.S_shu1(:,plotTimeLine)+resultSet.S_shu2(:,plotTimeLine),1)));
title('Total reactive power from shunt capacitors');
xlabel('Timeline');
ylabel('Reactive power [VAr]');
saveas(gcf,'analysis/fig/shuntCapAnalysis_Q_shunt.png');