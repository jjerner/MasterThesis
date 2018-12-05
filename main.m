clear

%add paths
AddPathsToMain                  % Add local paths to data repositories & PV model

location = 'Hallonvägen';
%location = 'Amundstorp';

%% Initialize parameters (CONSTANTS)
freq = 50;                      % frequency
w = 2*pi*freq;                  % OMEGA(LUL)
j = 1i;

%% Initialize parameters (transformer & cables)
InitializeTransformer;          % transformer parameters
InitializeCables;               % cable parameters & connections

% Sort startpoint - endpoint and bus types
readBuses                       % outputs: start2end & busType, matrices describing where each cable is connected.

SetupArrays;                    % match cable parameters and connections to matrices

%% Power Flow Calculations

U_guess = 230;                  % initial guess voltage across all busses
SetupProblem;                   % Setup PQ - PV - Slack busses from buses





