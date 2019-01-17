% Reactive power from shunt capacitors
figure;
plot(resultSet.timeLine,TransformerData.S_base.*imag(resultSet.Q_shu1+resultSet.Q_shu2))
title('Reactive power from shunt capacitors');
xlabel('Timeline');
ylabel('Reactive power [VAr]');
