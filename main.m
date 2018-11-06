clear

%add paths
AddPathsToMain                  % Add local paths to data repositories & PV model

%% Initialize parameters (CONSTANTS)
freq = 50;                      % frequency
w = 2*pi*freq;                  % omeeeeeeeeeeega
j = 1i;

%% Initialize parameters (transformer & cables)
InitializeTransformer;          % transformer parameters
InitializeCables;               % cable parameters & connections
SetupImpedanceMatrix;           % match cable parameters and connections to a matrix

%% Calculations

