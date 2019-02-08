function Results = solveFBSM(Z_ser,Y_shu,S_in,U_in,connections,busType,maxIter,convEps,doPlot,shuntCap)
% Forward Backward Sweep Method (FBSM) solver for radial power networks
%
% Results = solveFBSM(Z_in,S_in,U_in,connections,busType,MAX_ITER,convEps,doPlot,shuntCap)
%
% Inputs:
%    Z_in        = Impedance matrix for all connections (NxN).
%    S_in        = Power consumption (3-phase) at load buses (others 0) (Nx1).
%    U_in        = Voltage guess for each bus (specified voltage at slack bus) (Nx1).
%    connections = Matrix decribing connections between buses (N-1x2).
%    busType     = Vector with bus types ('SL', 'PV' or 'PQ') (Nx1).
%    maxIter     = Maximum number of iterations. Default value from Settings.
%    convEps     = Convergence criteria. Default value from Settings.
%    doPlot      = Create plots (1x1 logical). Default value from Settings.
%    shuntCap    = Include shunt capacitance (1x1 logical). Default value from Settings.
%
% Outputs:
%    Results.S_out   = Power calculation (per bus)
%    Results.S_loss  = Power loss calculation (per connection)
%    Results.U_out   = Voltage calculation (per bus)
%    Results.U_loss  = Voltage loss calculation (per connection)
%    Results.I_out   = Current calculation (per connection)
%    Results.nIters  = Number of iterations

global Settings;
if ~exist('maxIter','var'),  maxIter  = Settings.defaultMaxIter;   end    % Default value for maximum number of iterations
if ~exist('convEps','var'),  convEps  = Settings.defaultConvEps;   end    % Default convergence limit
if ~exist('doPlot','var'),   doPlot   = Settings.defaultConvPlots; end    % Default value for plot creation
if ~exist('shuntCap','var'), shuntCap = Settings.defaultShuntCap;  end    % Default value for shunt capacitance

iter = 2;               % First calculation is iteration 2

% Inputs
S_calc(:,1) = S_in;     % Input powers (loads) at iteration 1
U_calc(:,1) = U_in;     % Input voltages (guesses) at iteration 1

% Current matrix preallocations (excluding inputs)
I_calc(:,1) = zeros(size(connections,1),1);
I_calc(:,1) = zeros(size(connections,1),1);

% Power matrix preallocations (excluding inputs)
S_conn(:,1) = zeros(size(connections,1),1);
S_loss(:,1) = zeros(size(connections,1),1);
Q_shu1(:,1) = zeros(size(connections,1),1);
Q_shu2(:,1) = zeros(size(connections,1),1);

% Voltage matrix preallocations (excluding inputs)
U_delta(:,1) = zeros(size(connections,1),1);

% Vectors storing if calculation for a connection is done
calcDoneBwd = false(size(connections,1),1);
calcDoneFwd = false(size(connections,1),1);

%S_in=conj(S_in);

while iter<=maxIter
    
    if iter == maxIter
        warning('No convergence before maximum number of iterations was reached.') 
    end
 
    % Backward sweep to calculate powers and currents
    while ~all(calcDoneBwd)
        % Inputs
        S_calc(:,iter) = S_in;
        % Matrix preallocations
        S_loss(:,iter) = zeros(size(connections,1),1);
        S_conn(:,iter) = zeros(size(connections,1),1);
        I_calc(:,iter) = zeros(size(connections,1),1);
        I_calc(:,iter) = zeros(size(connections,1),1);
        
        for iConnB = size(connections,1):-1:1
            startBus = connections(iConnB,1);       % Start bus for connection
            endBus   = connections(iConnB,2);       % End bus for connection
            
            existsChildrenDS = [zeros(iConnB,1); connections(iConnB+1:end,1)] == endBus;
            existsChildrenUS = [connections(1:iConnB-1,1); zeros(size(connections,1)-iConnB+1,1)] == endBus;
            downstreamCheck  = all(calcDoneBwd(find(existsChildrenDS)));
            upstreamCheck    = all(calcDoneBwd(find(existsChildrenUS)));
            connectionToLoad = ~any(existsChildrenDS | existsChildrenUS);
            
            if upstreamCheck && downstreamCheck   
                
                % Find three-phase current through connection
                if connectionToLoad
                    % If connection to load, use load power
                    I_calc(iConnB,iter) = (1/sqrt(3))*abs(S_calc(endBus,iter))...
                        /abs(U_calc(endBus,iter-1));   
                    % Set correct sign of current
                    I_calc(iConnB,iter) = sign(real(S_calc(endBus,iter)))*I_calc(iConnB,iter);
                else
                    % If connection to other connection(s), use sum of
                    % incoming currents with regard to power factor
                    I_calc(iConnB,iter) = abs(sum(abs(I_calc(connections(:,1)==endBus,iter))...
                        .*S_calc(connections(connections(:,1)==endBus,2),iter)...
                        ./abs(S_calc(connections(connections(:,1)==endBus,2),iter)),'omitnan'));
                end
                  
                S_loss(iConnB,iter) = 3*I_calc(iConnB,iter)^2*Z_ser(startBus,endBus);	% Three-phase power loss through connection (always positive)
                
                if shuntCap
                    % Include reaction power generation in shunt capacitors
                    Q_shu1(iConnB,iter) = -3j*(abs(U_calc(startBus,iter-1)/sqrt(3))^2*imag(Y_shu(startBus,endBus))/2);
                    Q_shu2(iConnB,iter) = -3j*(abs(U_calc(endBus,iter-1)/sqrt(3))^2*imag(Y_shu(startBus,endBus))/2);
                    S_loss(iConnB,iter) = S_loss(iConnB,iter)+Q_shu1(iConnB,iter)+Q_shu2(iConnB,iter);
                end
                    
                S_conn(iConnB,iter) = S_calc(endBus,iter)+S_loss(iConnB,iter);          % Total power through connection including losses
                
                % Update startpoints only
                S_calc(startBus,iter) = S_calc(startBus,iter)+S_conn(iConnB,iter);      % Three-phase power in bus
                calcDoneBwd(iConnB)   = true;                                           % Mark connection calculation as done
            end
        end
    end
    
    % Update slack bus voltage angle but keep magnitude
    isSlackBus=busType(:,1)=='S' & busType(:,2)=='L';               % Find slack bus
    U_calc(isSlackBus,iter)=abs(U_calc(isSlackBus,iter-1))...
        *S_calc(isSlackBus,iter)/abs(S_calc(isSlackBus,iter));      % At slack bus, voltage angle = power angle
    
    
    % Forward sweep to calculate voltages
    while ~all(calcDoneFwd)
        % Matrix preallocation
        U_delta(:,iter) = zeros(size(connections,1),1);

        for iConnF = 1:size(connections,1)
            startBus = connections(iConnF,1);   % Start bus for connection
            endBus   = connections(iConnF,2);   % End bus for connection

            existsParentsDS = [zeros(iConnF,1); connections(iConnF+1:end,2)] == startBus;
            existsParentsUS = [connections(1:iConnF-1,2); zeros(size(connections,1)-iConnF+1,1)] == startBus;
            downstreamCheck = all(calcDoneFwd(find(existsParentsDS)));
            upstreamCheck   = all(calcDoneFwd(find(existsParentsUS)));

            if upstreamCheck && downstreamCheck
                U_delta(iConnF,iter) = -sqrt(3)*I_calc(iConnF,iter)*Z_ser(startBus,endBus); % Voltage loss over line  
                U_calc(endBus,iter) = U_calc(startBus,iter)+U_delta(iConnF,iter);           % Voltage at end bus
                calcDoneFwd(iConnF) = true;                                                 % Mark connection calculation as done
            end
        end
    end
    
    % Convergence criteria
    if iter > 2
        powerConvCrit   = max(abs(S_calc(:,iter-1) - S_calc(:,iter)));      % Power convergence criteria
        voltageConvCrit = max(abs(U_calc(:,iter-1) - U_calc(:,iter)));      % Voltage convergence criteria
        currentConvCrit = max(abs(I_calc(:,iter-1) - I_calc(:,iter)));      % Current convergence criteria
        
        if powerConvCrit < convEps && voltageConvCrit < convEps && currentConvCrit < convEps
            break
        end
    end
    
    calcDoneBwd(:) = false;     % Reset calc done backwards vector for next iteration
    calcDoneFwd(:) = false;     % Reset calc done fordwards vector for next iteration
    
    iter = iter+1;              % Go to next iteration
end

% Plot convergence
if doPlot
    legendLabelsU=[repmat('U_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
    legendLabelsP=[repmat('P_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
    legendLabelsQ=[repmat('Q_{',length(Z_ser),1) num2str(transpose(1:length(Z_ser))) repmat('}',length(Z_ser),1)];
    legendLabelsI=[repmat('I_{',size(connections,1),1) num2str(transpose(1:size(connections,1))) repmat('}',size(connections,1),1)];
    figure;
    plot(abs(U_calc'));
    title('Voltage convergence');
    xlabel('Number of iterations');
    ylabel('Voltage [p.u.]');
    legend(legendLabelsU);
    figure;
    plot(real(S_calc'));
    title('Active power convergence');
    xlabel('Number of iterations');
    ylabel('Active power [p.u.]');
    legend(legendLabelsP);
    figure;
    plot(imag(S_calc'));
    title('Reactive power convergence');
    xlabel('Number of iterations');
    ylabel('Reactive power [p.u.]');
    legend(legendLabelsQ);
    figure;
    plot(abs(I_calc'));
    title('Current convergence');
    xlabel('Number of iterations');
    ylabel('Current [p.u.]');
    legend(legendLabelsI);
end

% Output
Results.S_out   = S_calc(:,end);      % Power calculation (per bus)
Results.S_loss  = S_loss(:,end);      % Power loss calculation (per connection)
Results.U_out   = U_calc(:,end);      % Voltage calculation (per bus)
Results.U_delta = U_delta(:,end);     % Voltage loss calculation (per connection)
Results.I_out   = I_calc(:,end);      % Current calculation (per connection)
Results.Q_shu1  = Q_shu1(:,end);      % Shunt capacitor reactive power generation at start bus (per connection)
Results.Q_shu2  = Q_shu2(:,end);      % Shunt capacitor reactive power generation at end bus (per connection)
Results.nIters  = iter;               % Output number of iterations

end