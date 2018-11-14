% Gauss-Seidel solver

j=1i;                               % Imaginary unit


V_0=400*ones(1,length(Y_bus));      % Voltage guess for each node [V]
P_inj=[10 0 30 0 50 0 70 0 ...
    -10 0 -30 0 -50 0 -70 0];       % Active power injected at each node [W]
Q_inj=ones(1,length(Y_bus));        % Reactive power injected at each node [VAr]
S_inj=Q_inj+j*Q_inj;                % Apparent power injected at each node [VA]

V_latest=V_0;
P_latest=zeros(1,length(Y_bus));
V_hist(1,:)=V_0;
iLoop=1;


for iLoop=1:10                      % Test
    for iBus = 1:length(Y_bus)
        % if PQ-bus, find V
        V_latest(iBus)=(1/Y_bus(iBus,iBus))*((S_inj(iBus)/conj(V_latest(iBus)))...
            -sum(Y_bus(iBus,:).*V_latest));
        
        % if PV-bus, find Q
        Q_latest(iBus)=real(conj(V_latest(iBus))*V_latest(iBus)...
            *sum(Y_bus(iBus,:))-sum(Y_bus(iBus,:).*V_latest));
        
        % if slack-bus, find P
        P_latest(iBus)=-imag(conj(V_latest(iBus))*V_latest(iBus)...
            *sum(Y_bus(iBus,:))-sum(Y_bus(iBus,:).*V_latest));
    end
    V_hist(iLoop+1,:)=V_latest;
    P_hist(iLoop+1,:)=P_latest;
    Q_hist(iLoop+1,:)=Q_latest;
    V_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    P_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    Q_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
end

