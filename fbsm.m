function [S_out, U_out] = fbsm(Z_in, S_in, U_in, connections, busType, MAX_ITER, doPlot)
%FBSM, Forward Backward Sweep Method
%
%   Inputs:
%       Z_in        = Z-matrix (NxN) detailing impedances between all busses
%       S_in        = Input of all known powers (Nx1), 0 if unknown or no
%                     contribution of power in a node
%       U_in        = Input of all known voltages (Nx1), 1 pu if unknown
%       connections = Front to End of each connection (N-1x2)
%       busType     = Vector with bus types (Nx1)
%       MAX_ITER    = Maximum number of iterations, default value = 100
%       doPlot      = Create plots (1x1 logical). Default off.
%
%   Outputs:
%       S_out    = Power of all busses
%       U_out    = Voltages of all busses
%       I_out    = Current of all busses

if ~exist('MAX_ITER','var'), MAX_ITER = 100; end    % Default value for max no of iterations
if ~exist('doPlot','var'), doPlot = 0; end    % Create plots is off by default

k = 1;
S_prev(:,k) = S_in;
U_prev(:,k) = U_in;

while k<=MAX_ITER && true
    
% Convergence
if k >= MAX_ITER
    warning('No convergence during Forward Backward Sweep');
end

% Backward sweep
S_prev(:,k+1) = S_in;
for iBack = length(connections):-1:1
    startpoint = connections(iBack, 1);
    endpoint   = connections(iBack, 2);

    S_loop = S_prev(endpoint,k) + S_prev(endpoint,k) * conj(S_prev(endpoint,k))...
             * Z_in(startpoint,endpoint) / U_prev(endpoint,k)^2;
    S_prev(startpoint,k+1) = S_prev(startpoint,k+1) + S_loop;
end


% Forward sweep
U_prev(:,k+1) = U_in;
for iFor = 1:length(connections)
    startpoint = connections(iFor, 1);
    endpoint   = connections(iFor, 2);
    if strcmpi(busType(iFor,:), 'SL') || strcmpi(busType(iFor,:), 'PV')
        continue
    else
        U_prev(endpoint, k+1) = U_prev(startpoint,k) - ...
                                ((real(S_prev(startpoint,k))*real(Z_in(startpoint,endpoint)))+...
                                (imag(S_prev(startpoint,k))*imag(Z_in(startpoint,endpoint)))/...
                                U_prev(startpoint,k));
    end
end

k = k+1;
end

if doPlot
    legendLabelsU=[repmat('U_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    legendLabelsP=[repmat('P_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    legendLabelsQ=[repmat('Q_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    figure;
    plot(abs(U_prev'));
    title('Voltage history');
    xlabel('Number of iterations');
    ylabel('Voltage [p.u.]');
    legend(legendLabelsU);
    figure;
    plot(real(S_prev'));
    title('Active power history');
    xlabel('Number of iterations');
    ylabel('Active power [p.u.]');
    legend(legendLabelsP);
    figure;
    plot(imag(S_prev'));
    title('Reactive power history');
    xlabel('Number of iterations');
    ylabel('Reactive power [p.u.]');
    legend(legendLabelsQ);
end

    % Output
    S_out = S_prev(:, end);
    U_out = U_prev(:, end);

end

