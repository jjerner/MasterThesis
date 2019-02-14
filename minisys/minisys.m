j=1i;
addpath('..');

% Settings
maxIter  = 100;       % Maximum number of iterations
convEps  = 1e-3;      % Convergence limit
doPlot   = false;     % Plot convergence
shuntCap = true;     % Include shunt capacitance

for iConnection = 1:size(connectionBuses,1)
    startBus = connectionBuses(iConnection,1);
    endBus = connectionBuses(iConnection,2);
    disp(['At buses: ', num2str(startBus), ', ', num2str(endBus)]);
    Z_ser(startBus,endBus) = CableData(iConnection).R + j*CableData(iConnection).X;
    Z_ser(endBus,startBus) = CableData(iConnection).R + j*CableData(iConnection).X;
    disp(['Series impedance added from Cable ', num2str(iConnection)])
    if isfield(CableData,'G')
        Y_shu(startBus,endBus) = CableData(iConnection).G + j*CableData(iConnection).B;
        Y_shu(endBus,startBus) = CableData(iConnection).G + j*CableData(iConnection).B;
        disp(['Shunt admittance added from Cable ', num2str(iConnection)])
    else
        Y_shu = zeros(size(Z_ser));
    end
end

Results = solveFBSM(Z_ser,Y_shu,S_in,U_in,connectionBuses,...
                    busType,maxIter,convEps,doPlot,shuntCap);

S_out=Results.S_out
U_out=Results.U_out
I_out=Results.I_out
nIters=Results.nIters