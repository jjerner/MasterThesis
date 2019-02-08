% Add power production

% productionAtBus=[118;120];          % Bus nr to add production to
% productionAtTime=70:170;            % Time interval for production
% productionPower=[1e-3;1e-2];        % Power [p.u.]
% 
% S_ana(productionAtBus,productionAtTime)=S_ana(productionAtBus,productionAtTime)...
%     -productionPower;
% fprintf('Added %g p.u. production at node %d\n',[productionPower productionAtBus]');

if ~exist('S_ana','var'), S_ana = S_bus; end

disp('Select production case: ')
disp('1. Relative to consumption')
disp('2. Even distribution')
disp('3. Selected distribution')
prodCase = input('Enter case:');


%Create waitbar for any case, update with handle 'wh'

wh = waitbar(0, 'Running Calculation', 'Name', 'Power Production',...
             'Units','Normalized', 'Position', [0.405, 0.6, 0.19, 0.05]);

switch prodCase

    case 1 % Relative to consumption
        
        disp('Calculating PV power from model.');
        P_pv=(1/TransformerData.S_base)*PV_model(1,1,1,3)';     % Get PV power from model [p.u.]
        P_pv=P_pv(timeLine);                                    % Set correct timeline
        relLoadSize=S_ana(busIsLoad)./mean(S_ana(busIsLoad));   % Load size relative to mean load
        S_ana(busIsLoad,timeLine)=S_ana(busIsLoad,timeLine)-0.1*relLoadSize.*repmat(P_pv,[size(S_ana(busIsLoad),1) 1]);

    case 2 % evenly distributed
        
        evenDistProd;
        
    case 3 % pv-prod at selected loads
        
        % Set selected loads, in the form of their busnumber
        % // code here//
        disp('Calculating PV power from model.');
        P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';  % Get PV power from model [p.u.]
            
        minAllowed = 0.9;
        maxAllowed = 1.1;
        minV = 1;
        maxV = 1;
        withinVoltageLimit = maxV<=maxAllowed && minV>=minAllowed;
        
        % load results from greedy search and add production in the order
        % busses appear in vector 'addedPvPowerAt'
        load 'greedySearch_addedPvPowerAt.mat'
     
        for iter = 1:length(addedPvPowerAt)
            selectedLoads = addedPvPowerAt(1:iter);
            selectedDistProd;
            
            if ~withinVoltageLimit
                disp(['Critical voltage reached at iteration: ', num2str(iter)])
                break
            end
        end
        
        selectedPlots = 1;
        if selectedPlots == 1
            selectedDistPlot;
        end
        
    otherwise
        warning('Not valid case')
end

%remove waitbar
delete(wh)


clear wh prodCase