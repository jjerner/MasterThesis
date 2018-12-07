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

k = 2;
S_prev(:,1) = S_in;
U_prev(:,1) = U_in;
calcDone=zeros(length(connections),1);

while k<=MAX_ITER && true
    
% Convergence
if k >= MAX_ITER
    warning('No convergence during Forward Backward Sweep');
end

% Backward sweep
while ~all(calcDone)
    for iBack = length(connections):-1:1
        startPoint = connections(iBack, 1);
        endPoint   = connections(iBack, 2);
        
        existsChildrenDS=[zeros(iBack,1); connections(iBack+1:end,1)] == endPoint;
        existsChildrenUS=[connections(1:iBack-1,1); zeros(length(connections)-iBack,1)] == endPoint;
        downstreamCheck=all(calcDone(find(existsChildrenDS)));
        upstreamCheck=all(calcDone(find(existsChildrenUS)));
        
        if upstreamCheck && downstreamCheck
            S_loop = S_prev(endPoint,k-1) + S_prev(endPoint,k-1) * conj(S_prev(endPoint,k-1))...
                     * Z_in(startPoint,endPoint) / U_prev(endPoint,k-1)^2;
            % Update startpoints only
            S_prev(startPoint,k) = S_prev(startPoint,k-1) + S_loop;
            calcDone(iBack)=1;
        end
    end
end


% Forward sweep
for iFor = 1:length(connections)
    startPoint = connections(iFor, 1);
    endPoint   = connections(iFor, 2);
    if strcmpi(busType(iFor,:), 'SL') || strcmpi(busType(iFor,:), 'PV')
        continue
    else
        U_prev(endPoint, k) = U_prev(startPoint,k-1) - ...
                                ((real(S_prev(startPoint,k-1))*real(Z_in(startPoint,endPoint)))+...
                                (imag(S_prev(startPoint,k-1))*imag(Z_in(startPoint,endPoint)))/...
                                U_prev(startPoint,k-1));
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

