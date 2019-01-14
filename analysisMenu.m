clear analysisCase;
loopAnalysis=true;

while loopAnalysis
    % Select case
    caseList={'resetinput','Reset and analyze input';...
              'changepf','Change power factor (BETA)';...
              'addprod','Add power production (BETA)';...
              'filterinput','Filter input (moving average)';...
              'settimeline','Set timeline';...
              'sweepcalc','Run sweep calculation';...
              'plotall','Plot all results';...
              'plotloads','Plot load results only';...
              'analyzeus','Analyze voltages and powers';...
              'plotgridtree','Plot grid tree map';
              'plotvhist','Plot voltage histogram (BETA)';...
              'plotniters','Plot number of iterations'};
    [sel,ok] = listdlg('PromptString','Choose an option:',...
                       'SelectionMode','single',...
                       'ListString',caseList(:,2),...
                       'Name','Select a case',...
                       'ListSize',[200,200],...
                       'SelectionMode','single');
    if ok~=true
        error('No case selected.');
    end
    analysisCase=strjoin(caseList(sel,1));

    switch analysisCase
        case 'resetinput'
            % Reset and analyze input
            S_ana=S_bus;
            disp('All bus powers reset to input values.');
            if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
                disp('Load input contains only active powers.');
            else
                disp('Load input contains both active and reactive powers.');
            end
        case 'changepf'
            % Change power factor
            if ~exist('S_ana','var'), S_ana = S_bus; end            % Powers for analysis set to inputs
            newPowerFactor = input('Enter new power factor: ');
            newPowerFactorLeading = input('Lagging/inductive (0) or leading/capacitive (1)? ');
            %fprintf('\n');

            S_ana(busIsLoad,:)=createComplexPower(abs(S_ana(busIsLoad,:)),'M',newPowerFactor,newPowerFactorLeading);
            fprintf('Power factor for all loads changed to %g',newPowerFactor)
            if newPowerFactorLeading, fprintf(' leading.\n'); else, fprintf(' lagging.\n'); end

        case 'addprod'
            % Add power production
            if ~exist('timeLine','var'), disp('Error: Set timeline first'); break; end
            if ~exist('S_ana','var'), S_ana = S_bus; end
%             productionAtBus=[118;120];          % Bus nr to add production to
%             productionAtTime=70:170;            % Time interval for production
%             productionPower=[1e-3;1e-2];        % Power [p.u.]
% 
%             S_ana(productionAtBus,productionAtTime)=S_ana(productionAtBus,productionAtTime)...
%                 -productionPower;
%             fprintf('Added %g p.u. production at node %d\n',[productionPower productionAtBus]');
            disp('Calculating PV power from model.');
            P_pv=(1/TransformerData.S_base)*PV_model(1,1,1,3)';    % Get PV power from model [p.u.]
            P_pv=P_pv(timeLine);        % Set correct timeline
            relLoadSize=S_ana(busIsLoad)./mean(S_ana(busIsLoad)); % Load size relative to mean load
            S_ana(busIsLoad,timeLine)=S_ana(busIsLoad,timeLine)-0.1*relLoadSize.*repmat(P_pv,[size(S_ana(busIsLoad),1) 1]);

        case 'filterinput'
            % Filter input (moving average)
            if ~exist('S_ana','var'), S_ana = S_bus; end
            filterInput;
            
        case 'settimeline'
            % Set timeline
            leapYear = input('Leap year?  No (0) or Yes (1): ');
            timeLine=setTimeLine(leapYear);

        case 'sweepcalc'
            % Run sweep calculation
            if ~exist('timeLine','var'), disp('Error: Set timeline first'); break; end
            if ~exist('S_ana','var'), S_ana = S_bus; end
            resultSet=doSweepCalcs(Z_ser_tot,S_ana,U_bus,connectionBuses,busType,timeLine);


        case 'plotall'
            % Plot all
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            plotResults(resultSet,busIsLoad,0);

        case 'plotloads'
            % Plot loads only
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            plotResults(resultSet,busIsLoad,1);

        case 'analyzeus'    
            % Analyze voltages and powers
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            anaRes=analyzeUandS(resultSet,busIsLoad);

        case 'plotgridtree'
            % Plot grid tree map
            plotTreeGrid;
            
        case 'plotvhist'
            % Plot voltage histogram
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            plotVoltageHistogram;

        case {'plotniters'}
            % Plot number of iterations
            figure;
            plot(resultSet.timeLine,resultSet.nItersVec);
            title('Number of iterations');
            xlabel('Timeline');
            ylabel('Number of iterations');

        otherwise
            warning('Invalid choice');
    end
end
clear analysisCase loopAnalysis sel ok;