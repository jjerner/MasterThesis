% Gauss-Seidel solver for power flow analysis
% result=solveGS(Y_bus,nodeTypes,V_0,P_inj,Q_inj,doPlot)
%
% INPUTS:
% Y_bus:        Bus admittance matrix (n x n complex double)
% nodeTypes:    Vector describing node types (n x 2 char)
% V_0:          Voltage magnitude guess for each node [V] (n x 1 double)
% P_inj:        Active power injected at each node [W] (n x 1 double)
% Q_inj:        Reactive power injected at each node [VAr] (n x 1 double)
% doPlot:       Switch to produce plots or not (1 x 1 bool)
%
% OUTPUTS:
% result:           Struct containing solver results
% result.V_hist:    Voltage iteration history per node
% result.P_hist:    Active power iteration history per node
% result.Q_hist:    Reactive power iteration history per node
% result.V_diff:    Voltage difference between the last two iterations
% result.P_diff:    Active power difference between the last two iterations
% result.Q_diff:    Reactive power difference between the last two iterations
%
% SAMPLE DATA:
% Y_bus=[-13 5 4 0; 5 -13.5 2.5 2;4 2.5 -9 2.5; 0 2 2.5 -4.5];
% nodeTypes=['SL';'PQ';'PQ';'PQ'];
% V_0=[1 1 0.95 0.9];
% P_inj=[0 1 1.01 1.5];
% Q_inj=[0 0.01 0.01 0.01];


function result=solveGS(Y_bus,nodeTypes,V_0,P_inj,Q_inj,doPlot)

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

    PQbuses=nodeTypes=='PQ';              % Logical vector indentifying PQ buses
    PQbuses=PQbuses(:,1);
    PVbuses=nodeTypes=='PV';              % Logical vector indentifying PV buses
    PVbuses=PQbuses(:,1);
    SLbuses=nodeTypes=='SL';              % Logical vector indentifying slack bus
    SLbuses=PQbuses(:,1);

    S_inj=Q_inj+j*Q_inj;     % Apparent power injected at each node [VA]

    V_latest=V_0;
    P_latest=P_inj;
    Q_latest=Q_inj;
    V_hist(1,:)=V_0;
    P_hist(1,:)=P_inj;
    Q_hist(1,:)=Q_inj;
    iLoop=1;
    V_diff=inf*ones(1,length(Y_bus));   % Initial difference to avoid immediate stop
    P_diff=inf*ones(1,length(Y_bus));
    Q_diff=inf*ones(1,length(Y_bus));


    while norm(V_diff,2)>1e-4 && norm(P_diff,2)>1e-4 && norm(Q_diff,2)>1e-4
        for iBus = 1:length(Y_bus)
            switch nodeTypes(iBus,:)
                case 'PQ'   % If PQ-bus, find V
                    V_latest(iBus)=(1/Y_bus(iBus,iBus))*((P_latest(iBus)+j*Q_latest(iBus)/conj(V_latest(iBus)))...
                        -(sum(Y_bus(iBus,:).*V_latest)-Y_bus(iBus,iBus).*V_latest(iBus)));
                case 'PV'   % If PV-bus, find Q
                    Q_latest(iBus)=-imag(conj(V_latest(iBus))*sum(Y_bus(iBus,:).*V_latest));
                    % If Q_latest is within limits, then compute updated voltage
                    V_latest(iBus)=(1/Y_bus(iBus,iBus))*((P_latest(iBus)+j*Q_latest(iBus)/conj(V_latest(iBus)))...
                        -(sum(Y_bus(iBus,:).*V_latest)-Y_bus(iBus,iBus).*V_latest(iBus)));
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
        V_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);   % Voltage difference
        P_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);   % Active power difference
        Q_diff=V_hist(iLoop+1,:)-V_hist(iLoop,:);   % Reactive power difference
        iLoop=iLoop+1;
    end
    result.V_hist=V_hist;
    result.P_hist=P_hist;
    result.Q_hist=Q_hist;
    result.V_diff=V_diff;
    result.P_diff=P_diff;
    result.Q_diff=Q_diff;
    
    % Plot
    if doPlot
        legendLabelsV=[repmat('V_',length(Y_bus),1) num2str(transpose(1:length(Y_bus)))];
        legendLabelsP=[repmat('P_',length(Y_bus),1) num2str(transpose(1:length(Y_bus)))];
        legendLabelsQ=[repmat('Q_',length(Y_bus),1) num2str(transpose(1:length(Y_bus)))];
        figure;
        plot(abs(V_hist));
        title('Voltage history');
        xlabel('Number of iterations');
        ylabel('Voltage [p.u.]');
        legend(legendLabelsV);
        figure;
        plot(abs(P_hist));
        title('Active power history');
        xlabel('Number of iterations');
        ylabel('Active power [p.u.]');
        legend(legendLabelsP);
        figure;
        plot(abs(Q_hist));
        title('Reactive power history');
        xlabel('Number of iterations');
        ylabel('Reactive power [p.u.]');
        legend(legendLabelsQ);
    end
end