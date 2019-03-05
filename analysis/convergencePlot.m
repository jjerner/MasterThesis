% This file is intended to be run when solveFBSM has done all calculations
% and is paused in debug mode

%legendLabelsU=[repmat('U_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
%legendLabelsP=[repmat('P_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
%legendLabelsQ=[repmat('Q_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
%legendLabelsI=[repmat('I_{',size(connections,1),1) num2str(transpose(1:size(connections,1))) repmat('}',size(connections,1),1)];

hCp=figure;
subplot(2,2,1);
plot(abs(U_calc'));
title('Voltage');
xlabel('Iterations');
ylabel('Voltage [V]');
grid minor;
xlim([1 5]);
%legend(legendLabelsU);

subplot(2,2,2);
plot(abs(I_calc'));
title('Current');
xlabel('Iterations');
ylabel('Current [A]');
grid minor;
xlim([1 5]);
%legend(legendLabelsI);

subplot(2,2,3);
plot(real(S_calc')./1e3);
title('Active power');
xlabel('Iterations');
ylabel('Active power [kW]');
grid minor;
xlim([1 5]);
%legend(legendLabelsP);

subplot(2,2,4);
plot(imag(S_calc')./1e3);
title('Reactive power');
xlabel('Iterations');
ylabel('Reactive power [kVAr]');
grid minor;
xlim([1 5]);
%legend(legendLabelsQ);

mtit('Convergence','fontsize',13,'color',[0 0 0],'xoff',0,'yoff',0.03);