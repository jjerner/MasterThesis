% Test data
%Y_bus=[-13 5 4 0; 5 -13.5 2.5 2;4 2.5 -9 2.5; 0 2 2.5 -4.5];

% Gauss-Seidel solver
j=1i;                               % Imaginary unit
% Check criterias
fprintf(['Bus admittance matrix Y_bus must fulfil either criteria \n' ...
    '1. Diagonally dominant\n' ...
    '2. Symmetric AND positive definite\n']);

% Diagonally dominant (weak)
isDiagonallyDominant = all(2*abs(diag(Y_bus)) >= sum(abs(Y_bus),2));
% Symmetricity
isSymmetric = issymmetric(Y_bus);
% Positive definite
isPositiveDefinite = all(eig((Y_bus+Y_bus')/2) > 0);

if isDiagonallyDominant
    disp('OK - Y_bus fulfills criteria 1');
elseif isSymmetric && isPositiveDefinite
    disp('OK - Y_bus fulfills criteria 1');
else
    warning('Neither criteria 1 nor 2 fulfilled - convergence not guaranteed');
end

PQbuses=BusType=='PQ';
PQbuses=PQbuses(:,1);
PVbuses=BusType=='PV';
PVbuses=PQbuses(:,1);
SLbuses=BusType=='SL';
SLbuses=PQbuses(:,1);

V_0=[1e4 1e4 1e4 ones(1,length(Y_bus)-3)];      % Voltage magnitude guess for each node [V]
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
                V_latest(iBus)=(1/Y_bus(iBus,iBus))*((P_latest(iBus)+j*Q_latest(iBus)/conj(V_latest(iBus)))...
                    -(sum(Y_bus(iBus,:).*V_latest)-Y_bus(iBus,iBus).*V_latest(iBus,iBus)));
            case 'PV'   % If PV-bus, find Q
                Q_latest(iBus)=-imag(conj(V_latest(iBus))*sum(Y_bus(iBus,:).*V_latest));
                % If Q_latest is within limits, then compute updated voltage
                V_latest(iBus)=(1/Y_bus(iBus,iBus))*((P_latest(iBus)+j*Q_latest(iBus)/conj(V_latest(iBus)))...
                    -(sum(Y_bus(iBus,:).*V_latest)-Y_bus(iBus,iBus).*V_latest(iBus,iBus)));
                % Force voltage magnitude to specified value
                V_latest(iBus)=abs(V_0(iBus))*V_latest(iBus)/abs(V_latest(iBus));
            case 'SL'   % If slack-bus, find P and Q ???
                P_latest(iBus)=real(conj(V_latest(iBus))*sum(Y_bus(iBus,:).*V_latest));
                Q_latest(iBus)=-imag(conj(V_latest(iBus))*sum(Y_bus(iBus,:).*V_latest));
                % Compute updated voltage ???
                %V_latest(iBus)=(1/Y_bus(iBus,iBus))*((P_latest(iBus)+j*Q_latest(iBus)/conj(V_latest(iBus)))...
                %    -(sum(Y_bus(iBus,:).*V_latest)-Y_bus(iBus,iBus).*V_latest(iBus,iBus)));
        end    
    end
    V_hist(iLoop+1,:)=V_latest;
    P_hist(iLoop+1,:)=P_latest;
    Q_hist(iLoop+1,:)=Q_latest;
    V_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    P_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
    Q_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);
end