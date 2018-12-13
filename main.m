clear

%add paths
AddPathsToMain                  % Add local paths to data repositories & PV model

disp('Choose location');
disp('1. Amundstorp');
disp('2. Hallonvägen');
chooseLocation = input('Enter your choice: ','s');
switch chooseLocation
    case '1'
        location='Amundstorp';
    case '2'
        location='Hallonvägen';
    otherwise
        error('Incorrect choice');
end     

%% Initialize parameters (CONSTANTS)
freq = 50;                      % frequency
w = 2*pi*freq;                  % OMEGA(LUL, omegalul Kappa 4Head)
j = 1i;

%% Initialize parameters (transformer & cables)
InitializeTransformer;          % transformer parameters
InitializeCables;               % cable parameters & connections

% Sort startpoint - endpoint and bus types
readBuses;                      % outputs: connectionBuses & connectionType, 
                                %          matrices describing where each bus is connected.
                                
SetupArrays;                    % match cable parameters and connections to matrices

%% Power Flow Calculations

SetupProblem;                   % Setup PQ - PV - Slack busses from buses (reading inputdata)


