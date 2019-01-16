j=1i;

for iConnection = 1:size(connectionBuses,1)
        startBus = connectionBuses(iConnection,1);
        endBus = connectionBuses(iConnection,2);
        disp(['At buses: ', num2str(startBus), ', ', num2str(endBus)]);
        Z_ser(startBus,endBus) = CableData(iConnection).R + j*CableData(iConnection).X;
        Z_ser(endBus,startBus) = CableData(iConnection).R + j*CableData(iConnection).X;
        disp(['Series impedance added from Cable ', num2str(iConnection)])
end

Results = solveFBSM(Z_ser, S_in, U_in, connectionBuses, busType,100,1e-6,0);

S_out=Results.S_out
U_out=Results.U_out
I_out=Results.I_out
nIters=Results.nIters