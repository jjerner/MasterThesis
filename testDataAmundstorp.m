j=1i;
busTypes=['SL';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ'];
V_0=ones(length(busTypes),1);
P_inj=[NaN NaN NaN NaN 1 1.05 NaN 1 1.1 0 0.9 1 1.05 0.8];
Q_inj=[NaN NaN NaN NaN 0.1 0 NaN 0 0 0 0 0.1 0 0];
S_in=P_inj+j*Q_inj;
%gsres=solveGS(Y_bus,busTypes,V_0,P_inj,Q_inj,1,1)
[S_out,U_out]=fbsm(Z_ser_tot,S_in,V_0,connectionBuses,busType,50,1e-3,1)


%% Hallonvägen

%main
%[S_out2,U_out2]=fbsm(Z_ser_tot, S_bus(:,1), U_bus(:,1), connectionBuses, busType, 100, 1e-3, 1)

%month
jan = 1:24*31;
feb = 1+(24*31):24*(28+31);
mar = 1+(24*(31+28)):24*(31+28+31);

month = feb;

S_hist = zeros(size(S_bus,1), size(S_bus,2));
U_hist = zeros(size(U_bus,1), size(U_bus,2));
barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
for iter = month
    waitbar((iter-min(month)+1)/length(month), barHandle, sprintf('Sweep calculations %d/%d',...
            (iter-min(month)+1), length(month)));
    [S_out, U_out] = fbsm(Z_ser_tot, S_bus(:,iter), U_bus(:,iter), connectionBuses, busType, 200, 1e-3, 0);
    
    S_hist(:,iter) = S_out;
    U_hist(:,iter) = U_out;
end

P_hist = real(S_hist);
Q_hist = imag(S_hist);

%{
%plots
legendLabelsU=[repmat('U_{',length(U_hist),1) num2str(transpose(1:length(U_hist))) repmat('}',length(U_hist),1)];
legendLabelsP=[repmat('P_{',length(P_hist),1) num2str(transpose(1:length(P_hist))) repmat('}',length(P_hist),1)];
legendLabelsQ=[repmat('Q_{',length(Q_hist),1) num2str(transpose(1:length(Q_hist))) repmat('}',length(Q_hist),1)];
figure;
plot(abs(U_hist'));
title('Voltage history');
xlabel('Number of iterations');
ylabel('Voltage [p.u.]');
legend(legendLabelsU);
figure;
plot(real(S_hist'));
title('Active power history');
xlabel('Number of iterations');
ylabel('Active power [p.u.]');
legend(legendLabelsP);
figure;
plot(imag(S_hist'));
title('Reactive power history');
xlabel('Number of iterations');
ylabel('Reactive power [p.u.]');
legend(legendLabelsQ);
%}