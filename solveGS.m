% Gauss-Seidel solver
j=1i;                               % Imaginary unit


PQbuses=BusType=='PQ';
PQbuses=PQbuses(:,1);
PVbuses=BusType=='PV';
PVbuses=PQbuses(:,1);
SLbuses=BusType=='SL';
SLbuses=PQbuses(:,1);

V_0=[1e4 1e4 1e4 ones(1,length(Y_bus)-3)];      % Voltage guess for each node [V]
P_inj(PQbuses)=-1000;               % Active power injected at each node [W]
Q_inj(PQbuses)=-50;                 % Reactive power injected at each node [VAr]
S_inj=Q_inj+j*Q_inj;                % Apparent power injected at each node [VA]

V_latest=V_0;
P_latest=P_inj;
Q_latest=Q_inj;
V_hist(1,:)=V_0;
P_hist(1,:)=P_inj;
Q_hist(1,:)=Q_inj;
iLoop=1;


for iLoop=1:100                      % Test
    for iBus = 1:length(Y_bus)
        switch BusType(iBus,:)
            case 'PQ'   % If PQ-bus, find V
            V_latest(iBus)=(1/Y_bus(iBus,iBus))*((S_inj(iBus)/conj(V_latest(iBus)))...
                -sum(Y_bus(iBus,:).*V_latest));
            case 'PV'   % If PV-bus, find Q
            Q_latest(iBus)=real(conj(V_latest(iBus))*V_latest(iBus)...
                *sum(Y_bus(iBus,:))-sum(Y_bus(iBus,:).*V_latest));
            case 'SL'   % If slack-bus, find P
            P_latest(iBus)=-imag(conj(V_latest(iBus))*V_latest(iBus)...
                *sum(Y_bus(iBus,:))-sum(Y_bus(iBus,:).*V_latest));
        end    
    end
    V_hist(iLoop+1,:)=V_latest;
    P_hist(iLoop+1,:)=P_latest;
    Q_hist(iLoop+1,:)=Q_latest;
    V_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    P_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    Q_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
end