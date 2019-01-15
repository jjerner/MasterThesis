% Find cable load levels in percent (I/I_max)

% Cable currents (transformer removed)
cableCurrents_pu=[resultSet.I_hist(1:Info.addedTransformerBusAtIndex(1)-1,:);
          resultSet.I_hist(Info.addedTransformerBusAtIndex(1)+1:end,:)]...
          .*TransformerData.I_sec_base; % [p.u.]
      

% Maximum line currents allowed [A]
maxCableCurrents=cell2mat({CableData.Imax})';

% Line load in percent
cableLoadLevels=100*cableCurrents./maxCableCurrents;

% Plot
plot(resultSet.timeLine,cableLoadLevels);
title('Line load in percent');