clear

%% Initialize constants
j = 1i;

%% Add paths
%addpath('Verification');
addpath('PV model');

%% Run
LoadSettings;                   % Load settings
InitializeTransformer;          % Initialize transformer parameters
InitializeCables;               % Initialize cables
SetupConnections;               % Set up connection buses, names, type etc.
SetupArrays;                    % Match cable parameters and connections to matrices
SetupInput;                     % Read input data from files
SetupProblem;                   % Set up solver input matrices