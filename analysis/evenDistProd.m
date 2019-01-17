% Evenly distributed PV production

disp('Calculating PV power from model.');
P_pv=(1/TransformerData.S_base)*PV_model(1,1,1,3)';     % Get PV power from model [p.u.]
P_pv=P_pv(timeLine);                                    % Set correct timeline

