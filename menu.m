clear menuCase;

while true
    % Select case
    caseList={'xxx','=== BASIC SETUP ===';...
              'main','Main setup (includes children)';...
              'loadsettings','- Load settings';...
              'setupsystem','- Set up system';...
              'readinput','- Read input from .txt files';...
              'setupproblem','- Set up problem (solver input)';...
              'xxx','=== SOLVER ===';...
              'settimeline','Set timeline';...
              'sweepcalc','Run sweep calculation';...
              'sweepcalcstor','Run sweep calculation with storage';...
              'xxx','=== ANALYSIS ===';...
              'resetanalysis','Reset analysis';...
              'changepf','Change power factor';...
              'addprod','Add power production';...
              'filterinput','Filter input (moving average)';... 
              'analyzeus','Analyze voltages and powers';...
              'xxx','=== PLOTS ===';...
              'plotall','Plot all results';...
              'plotloads','Plot load results only';...
              'plotshuntpow','Plot shunt reactive power';...
              'plotgridtree','Plot grid tree map';...
              'plotvhist','Plot voltage histogram';...
              'plotniters','Plot number of iterations'};
    [menuSel,menuOK] = listdlg('PromptString','Menu:',...
                       'SelectionMode','single',...
                       'ListString',caseList(:,2),...
                       'Name','Select a case',...
                       'ListSize',[200,350],...
                       'SelectionMode','single');
    if menuOK~=true
        warning('No case selected.');
        return
    end
    menuCase=strjoin(caseList(menuSel,1));

    switch menuCase
        case 'main'
            % Main setup
            main;
        case 'loadsettings'
            % Load settings
            LoadSettings;
        
        case 'setupsystem'
            % Set up system
            InitializeTransformer;          % Initialize transformer parameters
            InitializeCables;               % Initialize cables
            SetupConnections;               % Set up connection buses, names, type etc.
            SetupArrays;                    % Match cable parameters and connections to matrices
            
        case 'readinput'
            % Read input from .txt
            if ~exist('Settings','var'), disp('Error: Load settings first'); break; end
            ReadInputTXT;
            
        case 'setupproblem'
            % Set up problem
            SetupProblem;
                        
        case 'settimeline'
            % Set timeline
            leapYear = input('Leap year?  No (0) or Yes (1): ');
            timeLine=setTimeLine(leapYear);
            
        case 'resetanalysis'
            % Reset analysis
            S_ana=S_bus;
            disp('All bus powers reset to input values.');
            if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
                disp('Load input contains only active powers.');
            else
                disp('Load input contains both active and reactive powers.');
            end
            
        case 'changepf'
            % Change power factor
            changePowerFactor;

        case 'addprod'
            % Add power production
            if ~exist('timeLine','var'), disp('Error: Set timeline first'); break; end
            addPowerProduction;

        case 'filterinput'
            % Filter input (moving average)
            filterInput;

        case 'sweepcalc'
            % Run sweep calculation
            if ~exist('timeLine','var'), disp('Error: Set timeline first'); break; end
            if ~exist('S_ana','var'), S_ana = S_bus; end
            resultSet=doSweepCalcs(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine);
            
        case 'sweepcalcstor'
            % Run sweep calculation with energy storage
            if ~exist('timeLine','var'), disp('Error: Set timeline first'); break; end
            if ~exist('S_ana','var'), S_ana = S_bus; end
            resultSet=doSweepCalcsStor(Z_ser,Y_shu,S_ana,U_bus,connectionBuses,busType,timeLine,1,[],busIsLoad,TransformerData);

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
            
        case 'plotshuntpow'
            % Plot shunt reactive power
            plotShuntReactivePower;
            
        case 'plotvhist'
            % Plot voltage histogram
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            plotVoltageHistogram;

        case {'plotniters'}
            % Plot number of iterations
            if ~exist('resultSet','var'), disp('Error: Run or load calculation first.'); break; end
            plotNumberOfIterations;

        otherwise
            warning('Invalid choice');
    end
end
clear menuCase loopMenu menuSel menuOK;