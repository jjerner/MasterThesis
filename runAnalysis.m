%{
j=1i;
busTypes=['SL';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ';'PQ'];
V_0=ones(length(busTypes),1);
P_inj=[NaN NaN NaN NaN 1 1.05 NaN 1 1.1 0 0.9 1 1.05 0.8];
Q_inj=[NaN NaN NaN NaN 0.1 0 NaN 0 0 0 0 0.1 0 0];
S_in=P_inj+j*Q_inj;
%gsres=solveGS(Y_bus,busTypes,V_0,P_inj,Q_inj,1,1)
[S_out,U_out]=fbsm(Z_ser_tot,S_in,V_0,connectionBuses,busType,50,1e-3,1)

%}
%% Load power factor
setPowerFactor=true;
newPowerFactor=0.9;
S_ana=S_bus;            % Powers for analysis set to inputs
if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
    disp('Note: Load input contains only active powers.');
else
    disp('Note: Load input contains both active and reactive powers.');
end

if setPowerFactor
    S_ana(busIsLoad,:)=createComplexPower(S_ana(busIsLoad,:),newPowerFactor);
    fprintf('Note: Power factor for all loads changed to %g.\n',newPowerFactor)
end

%% Hallonvägen

%main
%[S_out2,U_out2]=fbsm(Z_ser_tot, S_bus(:,1), U_bus(:,1), connectionBuses, busType, 100, 1e-3, 1)

%month
jan = 1:24*31;
feb = 1+(24*31):24*(28+31);
mar = 1+(24*(31+28)):24*(31+28+31);

month = 1:8760;

S_hist = zeros(size(S_bus,1), length(month));
U_hist = zeros(size(U_bus,1), length(month));

barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
for iter = 1:length(month)
    waitbar(iter/length(month), barHandle, sprintf('Sweep calculations %d/%d',...
            iter, length(month)));
        
    [S_out, U_out] = fbsm(Z_ser_tot, S_ana(:,month(iter)), U_bus(:,month(iter)),...
                          connectionBuses, busType, 1000, 1e-3, 0);
    
    S_hist(:,iter) = S_out;
    U_hist(:,iter) = U_out;
end
close(barHandle)

P_hist = real(S_hist);
Q_hist = imag(S_hist);

clear busIsLoadMatrix S_ana


%% plots

figure;
for asd = 1:size(U_hist, 1)
    plot(abs(U_hist(asd,:)))
    title('Voltage')
    ylabel('voltage [pu]')
    xlabel('time [h]')
    hold on
end

figure;
for asd2 = 1:size(S_hist, 1)
    plot(real(S_hist(asd2,:)))
    title('Active Power')
    hold on
end

figure;
for asd3 = 1:size(S_hist, 1)
    plot(imag(S_hist(asd3,:)))
    title('Reactive Power')
    hold on
end
