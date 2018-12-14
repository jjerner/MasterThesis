clear analysisCase;
loopAnalysis=true;

while loopAnalysis
    fprintf('\nANALYSIS MENU\n');
    disp('Choose an option');
    disp('1. Set power to input');
    disp('2. Change power factor');
    disp('3. Add power production');
    disp('4. Run sweep calculation');
    disp('5. Plot all results');
    disp('6. Plot load results only');
    disp('7. Analyze voltages');
    disp('8. Plot grid map');
    disp('9. Cancel analysis');
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
            newPowerFactor = input('Enter new power factor: ','s');
            newPowerFactorLeading = input('Lagging/inductive (0) or leading/capacitive (1)? ','s');
            fprintf('\n');
            newPowerFactor=str2num(newPowerFactor);
            newPowerFactorLeading=str2num(newPowerFactorLeading);
            if ~exist('S_ana','var'), S_ana = S_bus; end            % Powers for analysis set to inputs

            S_ana(busIsLoad,:)=createComplexPower(S_ana(busIsLoad,:),newPowerFactor,newPowerFactorLeading);
            fprintf('Power factor for all loads changed to %g',newPowerFactor)
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
            tAll = 1:length(Input(1).values);

            timeLine = tJan;

            S_hist = zeros(size(S_bus,1), length(timeLine));
            U_hist = zeros(size(U_bus,1), length(timeLine));

            barHandle = waitbar(0, '1', 'Name', 'Sweep calculations');
            for iter = 1:length(timeLine)
                waitbar(iter/length(timeLine), barHandle, sprintf('Sweep calculations %d/%d',...
                        iter, length(timeLine)));

                [S_out, U_out] = fbsm(Z_ser_tot, S_ana(:,timeLine(iter)), U_bus(:,timeLine(iter)),...
                                      connectionBuses, busType, 1000, 1e-3, 0);

                S_hist(:,iter) = S_out;
                U_hist(:,iter) = U_out;
            end
            close(barHandle)
            disp('Sweep calculation finished.');

            P_hist = real(S_hist);
            Q_hist = imag(S_hist);

        case '5'
            % Plot all

            figure;
            plot(timeLine,abs(U_hist));
            title('Voltage (all)');

            figure;
            plot(timeLine,P_hist);
            title('Active power (all)');

            figure;
            plot(timeLine,Q_hist);
            title('Reactive power (all)');

        case '6'
            % Plot loads only

            figure;
            plot(timeLine,abs(U_hist(busIsLoad,:)));
            title('Voltage (loads)');

            figure;
            plot(timeLine,P_hist(busIsLoad,:));
            title('Active power (loads)');

            figure;
            plot(timeLine,Q_hist(busIsLoad,:));
            title('Reactive power (loads)');

        case '7'    
            % Analyze voltages

            [maxVoltageVec,maxVoltageTimeVec]=max(abs(U_hist),[],2);   % Max voltage for each bus
            [minVoltageVec,minVoltageTimeVec]=min(abs(U_hist),[],2);   % Min voltage for each bus

            [maxVoltage,maxVoltageBusNr]=max(maxVoltageVec);           % Max voltage and bus number
            [minVoltage,minVoltageBusNr]=min(minVoltageVec);           % Min voltage and bus number

            [maxLoadVoltage,maxLoadVoltageBusNr]=max(maxVoltageVec(busIsLoad));   % Max load voltage and bus number*
            [minLoadVoltage,minLoadVoltageBusNr]=min(minVoltageVec(busIsLoad));   % Min load voltage and bus number*
            % *=numbered according to load buses only

            allBusNrVec=1:nBuses;
            loadBusNrVec=allBusNrVec(busIsLoad);
            maxLoadVoltageBusNr=loadBusNrVec(maxLoadVoltageBusNr);     % Change to global bus numbering
            minLoadVoltageBusNr=loadBusNrVec(minLoadVoltageBusNr);     % Change to global bus numbering

            maxVoltageTimeStep=maxVoltageTimeVec(maxVoltageBusNr);     % Time (col) for max voltage
            minVoltageTimeStep=minVoltageTimeVec(minVoltageBusNr);     % Time (col) for min voltage
            maxLoadVoltageTimeStep=maxVoltageTimeVec(maxLoadVoltageBusNr);     % Time (col) for max load voltage
            minLoadVoltageTimeStep=minVoltageTimeVec(minLoadVoltageBusNr);     % Time (col) for min load voltage

            fprintf('Maximum voltage: %g at (%d,%d)\n',maxVoltage,maxVoltageBusNr,maxVoltageTimeStep);
            fprintf('Minimum voltage: %g at (%d,%d)\n',minVoltage,minVoltageBusNr,minVoltageTimeStep);
            fprintf('Maximum load voltage: %g at (%d,%d)\n',maxLoadVoltage,maxLoadVoltageBusNr,maxLoadVoltageTimeStep);
            fprintf('Minimum load voltage: %g at (%d,%d)\n',minLoadVoltage,minLoadVoltageBusNr,minLoadVoltageTimeStep);

            % fprintf('Minimum voltage difference: %g\n',minLoadVdiff);
            % fprintf('Maximum voltage difference: %g\n',maxLoadVdiff);
        case '8'
            plotTreeGrid;
        
        case '9'
            % Cancel analysis
            loopAnalysis=false;

        otherwise
            warning('Invalid choice');
    end
end
fprintf('\n');
clear loopAnalysis analysisCase;