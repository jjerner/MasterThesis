j=1i;
busTypes=['SL';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ'];
V_0=ones(length(busTypes),1);
P_inj=[0 0 0 0 1 1.05 0 1 1.1 0 0.9 1 1.05 0.8];
Q_inj=[0 0 0 0 0.1 0 0 0 0 0 0 0.1 0 0];
S_in=P_inj+j*Q_inj;
%gsres=solveGS(Y_bus,busTypes,V_0,P_inj,Q_inj,1,1)
swres=fbsm(Z_ser_tot,S_in,V_0,connectionBuses,busType,10,1)