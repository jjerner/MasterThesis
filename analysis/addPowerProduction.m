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
disp('4. X nr of PV systems per load')
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
        S_ana(busIsLoad,timeLine)=S_ana(busIsLoad,timeLine)-0.3*relLoadSize.*repmat(P_pv,[size(S_ana(busIsLoad),1) 1]);

    case 2 % evenly distributed
        
        evenDistProd;
        
    case 3 % pv-prod at selected loads
        
        reverseOrder = 0;
        disp('Select Order of production')
        disp('   Weakest to Strongest - 1')
        disp('   Strongest to Weakest - 2')
        while reverseOrder ~= 1 || reverseOrder ~= 2
            reverseOrder = input('Select Order:');
            if reverseOrder == 1 || reverseOrder == 2
                break
            end
        end
        
        % Set selected loads, in the form of their busnumber
        % // code here//
        disp('Calculating PV power from model.');
        P_pv=(1/TransformerData.S_base).*PV_model(1,1,1,3)';  % Get PV power from model [p.u.]
            
        minAllowed = 230*0.9 / (TransformerData.U_sec_base/sqrt(3)) .*0.9;
        maxAllowed = 230*1.1 / (TransformerData.U_sec_base/sqrt(3)) .*1.1;
        minV = 1;
        maxV = 1;
        withinVoltageLimit = maxV<=maxAllowed && minV>=minAllowed;
        
        % load results from greedy search
      
        if reverseOrder == 2
           load('D:\Exjobb\Matlab\MasterThesisCode\analysis\greedysearch_strong.mat');
        else
           load('D:\Exjobb\Matlab\MasterThesisCode\analysis\greedysearch_weak.mat');
        end
     
        for iter = 1:length(addedPvPowerAt)
            selectedLoads = addedPvPowerAt(1:iter);
            selectedDistProd;
            
            if ~withinVoltageLimit
                disp(['Critical voltage reached at iteration: ', num2str(iter)])
                break
            end
        end
        
        selectedPlots = 0;
        if selectedPlots == 1
            selectedDistPlot; % funkar inte
        end
        
    case 4  % X nr of PV systems per load
        pvSystemsPerLoad=input('Number of PV systems per load: ');
        disp('Calculating PV power from model.');
        P_pv=(1/TransformerData.S_base)*PV_model(1,1,1,3)';     % Get PV power from model [p.u.]
        P_pv=P_pv(timeLine);
        S_ana(busIsLoad,timeLine)=S_ana(busIsLoad,timeLine)-pvSystemsPerLoad*repmat(P_pv,[size(S_ana(busIsLoad),1) 1]);
        
    otherwise
        warning('Not valid case')
end

%remove waitbar
delete(wh)


clear wh prodCase