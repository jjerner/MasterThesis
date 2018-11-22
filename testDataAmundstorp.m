busTypes=['SL';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ'];
V_0=[1 1 1 1 0.5 0.5 0 0.5 0.5 0 0.5 0.5 0.5 0.5];
P_inj=[0 0 0 0 1 1.05 0 1 1.1 0 0.9 1 1.05 0.8];
Q_inj=[0 0 0 0 0 0 0 0 0 0 0 0 0 0];
gsres=solveGS(Y_bus,busTypes,V_0,P_inj,Q_inj,1,1)