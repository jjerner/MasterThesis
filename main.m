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

U_guess = 230;  % initial guess voltage across all busses

U = ones(length(Y_chg),1) .* U_guess;

% SomeScriptToSetBusTypes           % Setup PQ - PV - Slack busses
% CalculationsOnPQBusses
% CalculationsOnPVBusses


%% Analysis
% plots etc