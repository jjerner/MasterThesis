function [S_out,U_out,iter] = solveFBSM(Z_in, S_in, U_in, connections, busType, MAX_ITER, eps, doPlot)
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
%       eps         = Convergence criteria, default value = 1e-6
%       doPlot      = Create plots (1x1 logical). Default off.
%
%   Outputs:
%       S_out    = Power of all busses
%       U_out    = Voltages of all busses

if ~exist('MAX_ITER','var'), MAX_ITER = 100; end    % Default value for max no of iterations
if ~exist('eps', 'var'), eps = 1e-6; end            % Default convergence  
if ~exist('doPlot','var'), doPlot = 0; end          % Create plots is off by default 

iter = 2;
S_calc(:,1) = S_in;
U_calc(:,1) = U_in;
calcDoneBwd=zeros(length(connections),1);
calcDoneFwd=zeros(length(connections),1);

while iter<=MAX_ITER
    
    if iter == MAX_ITER
       warning('No convergence before maximal iterations was reached!') 
    end
 
    % Backward sweep
    while ~all(calcDoneBwd)
        S_calc(:,iter) = S_in;
        for iBack = length(connections):-1:1
            startPoint = connections(iBack, 1);
            endPoint   = connections(iBack, 2);
            
            existsChildrenDS=[zeros(iBack,1); connections(iBack+1:end,1)] == endPoint;
            existsChildrenUS=[connections(1:iBack-1,1); zeros(length(connections)-iBack+1,1)] == endPoint;
            downstreamCheck=all(calcDoneBwd(find(existsChildrenDS)));
            upstreamCheck=all(calcDoneBwd(find(existsChildrenUS)));
            
            if upstreamCheck && downstreamCheck
                S_loop = S_calc(endPoint,iter) + S_calc(endPoint,iter) * conj(S_calc(endPoint,iter))...
                    * Z_in(startPoint,endPoint) / U_calc(endPoint,iter-1)^2;
                % Update startpoints only
                S_calc(startPoint,iter) = S_calc(startPoint,iter) + S_loop;
                calcDoneBwd(iBack)=1;
            end
        end
    end
    
    % Forward sweep
    while ~all(calcDoneFwd)
        U_calc(:,iter) = U_in;
        for iFwd = 1:length(connections)
            if strcmpi(busType(iFwd,:), 'SL') || strcmpi(busType(iFwd,:), 'PV')
                calcDoneFwd(iFwd)=1;
                continue
            else
                startPoint = connections(iFwd, 1);
                endPoint   = connections(iFwd, 2);

                existsParentsDS=[zeros(iFwd,1); connections(iFwd+1:end,2)] == startPoint;
                existsParentsUS=[connections(1:iFwd-1,2); zeros(length(connections)-iFwd+1,1)] == startPoint;
                downstreamCheck=all(calcDoneFwd(find(existsParentsDS)));
                upstreamCheck=all(calcDoneFwd(find(existsParentsUS)));
                
                if upstreamCheck && downstreamCheck
                    U_calc(endPoint,iter) = U_calc(startPoint,iter-1) -(S_calc(startPoint,iter)*Z_in(startPoint,endPoint)/U_calc(startPoint,iter-1));
                    calcDoneFwd(iFwd)=1;
                end
            end
        end
    end
    
    % Convergence
    if iter > 2
        powerConvCrit = max(abs(S_calc(:,iter-1) - S_calc(:,iter)));
        voltageConvCrit = max(abs(U_calc(:,iter-1) - U_calc(:,iter)));

        if powerConvCrit < eps && voltageConvCrit < eps
            break
        end
    end
    
    calcDoneBwd(:)=0;
    calcDoneFwd(:)=0;
    iter = iter+1;
end

if doPlot
    legendLabelsU=[repmat('U_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    legendLabelsP=[repmat('P_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    legendLabelsQ=[repmat('Q_{',length(Z_in),1) num2str(transpose(1:length(Z_in))) repmat('}',length(Z_in),1)];
    figure;
    plot(abs(U_calc'));
    title('Voltage history');
    xlabel('Number of iterations');
    ylabel('Voltage [p.u.]');
    legend(legendLabelsU);
    figure;
    plot(real(S_calc'));
    title('Active power history');
    xlabel('Number of iterations');
    ylabel('Active power [p.u.]');
    legend(legendLabelsP);
    figure;
    plot(imag(S_calc'));
    title('Reactive power history');
    xlabel('Number of iterations');
    ylabel('Reactive power [p.u.]');
    legend(legendLabelsQ);
end

% Output
S_out = S_calc(:, end);
U_out = U_calc(:, end);

end