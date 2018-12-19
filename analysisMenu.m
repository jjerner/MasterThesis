clear analysisCase;
loopAnalysis=true;

while loopAnalysis
    fprintf('\nANALYSIS MENU\n');
    disp('Choose an option');
    disp('1. Set power to input');
    disp('2. Change power factor (BETA)');
    disp('3. Add power production (BETA)');
    disp('4. Run sweep calculation');
    disp('5. Plot all results');
    disp('6. Plot load results only');
    disp('7. Analyze voltages');
    disp('8. Plot grid tree map');
    disp('9. Plot voltage histogram (ALPHA)');
    disp('X. Cancel analysis');
    analysisCase = input('Enter your choice: ','s');
    fprintf('\n');
    
    switch analysisCase
        case '1'
            % Set power to input
            S_ana=S_bus;
            disp('All bus powers set to input values.');
            if all(all(S_bus(busIsLoad,:)==real(S_bus(busIsLoad,:))))
                disp('Load input contains only active powers.');
            else
                disp('Load input contains both active and reactive powers.');
            end
        case '2'
            % Change power factor
            histogramNodeNumber = input('Enter new power factor: ');
            newPowerFactorLeading = input('Lagging/inductive (0) or leading/capacitive (1)? ');
            fprintf('\n');
            if ~exist('S_ana','var'), S_ana = S_bus; end            % Powers for analysis set to inputs

            S_ana(busIsLoad,:)=createComplexPower(S_ana(busIsLoad,:),histogramNodeNumber,newPowerFactorLeading);
            fprintf('Power factor for all loads changed to %g',histogramNodeNumber)
            if newPowerFactorLeading, fprintf(' leading.\n'); else, fprintf(' lagging.\n'); end

        case '3'
            % Add power production

            if ~exist('S_ana','var'), S_ana = S_bus; end
            productionAtBus=[118;120];          % Bus nr to add production to
            productionAtTime=70:170;            % Time interval for production
            productionPower=[1e-3;1e-2];        % Power [p.u.]

            S_ana(productionAtBus,productionAtTime)=S_ana(productionAtBus,productionAtTime)...
                -productionPower;
            fprintf('Added %g p.u. production at node %d\n',[productionPower productionAtBus]');
        case '4'
            % Run sweep calculation

            if ~exist('S_ana','var'), S_ana = S_bus; end

            % Set timeline
            tJan = 1:24*31;
            tFeb = 1+(24*31):24*(28+31);
            tMar = 1+(24*(31+28)):24*(31+28+31);
            tJFM = [tJan tFeb tMar];
            tYear = 1:length(Input(1).values);

            timeLine = tYear;
            
            [U_hist,S_hist]=doSweepCalcs(Z_ser_tot,S_ana,U_bus,connectionBuses,busType,timeLine);
            

        case '5'
            % Plot all
            plotResults(U_hist,S_hist,timeLine,busIsLoad,0);

        case '6'
            % Plot loads only
            plotResults(U_hist,S_hist,timeLine,busIsLoad,1);

        case '7'    
            % Analyze voltages

            
        case '8'
            % Plot grid tree map
            plotTreeGrid;
        case '9'
            % Plot voltage histogram
            plotVoltageHistogram;
            
        case {'X','x'}
            % Cancel analysis
            loopAnalysis=false;

        otherwise
            warning('Invalid choice');
    end
end
fprintf('\n');
clear loopAnalysis analysisCase;