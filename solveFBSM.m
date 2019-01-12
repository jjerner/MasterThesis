function [S_out,U_out,I_out,iter] = solveFBSM(Z_in, S_in, U_in, connections, busType, MAX_ITER, eps, doPlot)
%FBSM, Forward Backward Sweep Method
%
%   Inputs:
%       Z_in        = Z-matrix (NxN) detailing impedances between all buses
%       S_in        = Input of all known powers (3-phase) (Nx1),
%                     0 if unknown or no contribution of power in a bus.
%       U_in        = Input of all known voltages (Nx1).
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
I_calc(:,1) = zeros(length(connections),1);
I_calc2(:,1) = zeros(length(connections),1);
calcDoneBwd=zeros(length(connections),1);
calcDoneFwd=zeros(length(connections),1);

S_in=conj(S_in);

while iter<=MAX_ITER
    
    if iter == MAX_ITER
       warning('No convergence before maximum number of iterations was reached.') 
    end
 
    % Backward sweep
    while ~all(calcDoneBwd)
        S_calc(:,iter) = S_in;
        I_calc(:,iter) = zeros(length(connections),1);
        for iConnB = length(connections):-1:1
            startPoint = connections(iConnB, 1);
            endPoint   = connections(iConnB, 2);
            
            existsChildrenDS=[zeros(iConnB,1); connections(iConnB+1:end,1)] == endPoint;
            existsChildrenUS=[connections(1:iConnB-1,1); zeros(length(connections)-iConnB+1,1)] == endPoint;
            downstreamCheck=all(calcDoneBwd(find(existsChildrenDS)));
            upstreamCheck=all(calcDoneBwd(find(existsChildrenUS)));
            
            if upstreamCheck && downstreamCheck
                I_line=(1/sqrt(3))*abs(S_calc(endPoint,iter))/abs(U_calc(endPoint,iter-1)); % Current in one line (three-phase)
                %I_line=abs(S_calc(endPoint,iter))/abs(U_calc(endPoint,iter-1)); % Current in one line (single-phase)
                S_loss=3*I_line^2*Z_in(startPoint,endPoint);                                % Three-phase power loss <--- CHANSNING HÄR
                %S_loss=I_line^2*Z_in(startPoint,endPoint);                                % Single-phase power loss
                S_line=S_calc(endPoint,iter)+S_loss;                                        % Three-phase power (total)
                
                % Update startpoints only
                S_calc(startPoint,iter) = S_calc(startPoint,iter) + S_line;                 % Three-phase power in junction
                I_calc(iConnB,iter) = I_calc(iConnB,iter) + I_line;                 % Current in junction
                calcDoneBwd(iConnB)=1;                                                      % Mark connection as done
            end
        end
    end
    
    % Forward sweep
    while ~all(calcDoneFwd)
        U_calc(:,iter) = U_in;
        I_calc2(:,iter) = zeros(length(connections),1);
        for iConnF = 1:length(connections)
            if strcmpi(busType(iConnF,:), 'SLXXX') || strcmpi(busType(iConnF,:), 'PVXXX')     %% PV bus not implemented
                calcDoneFwd(iConnF)=1;
                continue
            else
                startPoint = connections(iConnF, 1);
                endPoint   = connections(iConnF, 2);

                existsParentsDS=[zeros(iConnF,1); connections(iConnF+1:end,2)] == startPoint;
                existsParentsUS=[connections(1:iConnF-1,2); zeros(length(connections)-iConnF+1,1)] == startPoint;
                downstreamCheck=all(calcDoneFwd(find(existsParentsDS)));
                upstreamCheck=all(calcDoneFwd(find(existsParentsUS)));
                
                if upstreamCheck && downstreamCheck
                    I_line2 = (1/sqrt(3))*(abs(S_calc(startPoint,iter))/abs(U_calc(startPoint,iter)));      % Current in one line
                    %I_line2 = (abs(S_calc(startPoint,iter))/abs(U_calc(startPoint,iter)));
                    U_loss  = sqrt(3)*I_line2*Z_in(startPoint,endPoint);                                            % Voltage loss over line
                    U_calc(endPoint,iter) = U_calc(startPoint,iter) - U_loss;                               % Voltage at endpoint
                    calcDoneFwd(iConnF)=1;                                                                  % Mark connection as done
                    I_calc2(iConnF,iter) = I_calc2(iConnF,iter) + I_line2;
                end
            end
        end
    end
    
    % Convergence
    if iter > 2
        powerConvCrit = max(abs(S_calc(:,iter-1) - S_calc(:,iter)));
        voltageConvCrit = max(abs(U_calc(:,iter-1) - U_calc(:,iter)));
        currentConvCrit = max(abs(I_calc(:,iter-1) - I_calc(:,iter)));
        
        if powerConvCrit < eps && voltageConvCrit < eps && currentConvCrit < eps
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
    legendLabelsI=[repmat('I_{',length(connections),1) num2str(transpose(1:length(connections))) repmat('}',length(connections),1)];
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
    figure;
    plot(abs(I_calc'));
    title('Current history');
    xlabel('Number of iterations');
    ylabel('Current [p.u.]');
    legend(legendLabelsI);
end

% Output
S_out = S_calc(:,end);
U_out = U_calc(:,end);
I_out = I_calc(:,end);
I_out2 = I_calc2(:,end);

end