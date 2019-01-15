% Find cable load levels in percent (I/I_max)

% Cable currents (transformer removed)
cableCurrents_pu=[resultSet.I_hist(1:Info.addedTransformerBusAtIndex(1)-1,:);
                  resultSet.I_hist(Info.addedTransformerBusAtIndex(1)+1:end,:)]; % [p.u.]
connectionLevel_mod=[connectionLevel(1:Info.addedTransformerBusAtIndex(1)-1);
                     connectionLevel(Info.addedTransformerBusAtIndex(1)+1:end)];
cableCurrents=zeros(size(cableCurrents_pu));
cableCurrents(connectionLevel_mod=='H',:)=cableCurrents_pu(connectionLevel_mod=='H',:).*TransformerData.I_prim_base;  % [A]
cableCurrents(connectionLevel_mod=='L',:)=cableCurrents_pu(connectionLevel_mod=='L',:).*TransformerData.I_sec_base;   % [A]

% Maximum line currents allowed [A]
maxCableCurrents=cell2mat({CableData.Imax})';

% Line load in percent
cableLoadLevels=100*cableCurrents./maxCableCurrents;

% Plot
plot(resultSet.timeLine,cableLoadLevels);
title('Line load in percent');
xlabel('Timeline');
ylabel('Load level (I/I_{max}) [%]');

clear connectionLevel_mod