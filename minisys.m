%clear;
%load('minisys_real.mat');
[S_out,U_out,I_out,iter] = solveFBSM(Z_ser, S_in, U_in, connectionBuses, busType,100,1e-3,1)