clear

%% Initialize constants
j = 1i;

%% Add paths
addpath('Verification');
addpath('PV model');

%% Settings
Settings.location='Hallonvägen';                        % Location name
Settings.inputDir = 'data/Inputs/T085';                 % Directory for input files
Settings.cableDBPath='data/Ledningsdata.mat';           % Path to cable database file
Settings.gridCableDataPath = 'data/T085 Hallonvagen.xlsx';              % Path to grid cable data file
Settings.transformerDataPath='data/TransformerData_Hallonvagen.mat';    % Path to transformer data file
Settings.removeHighVoltageBuses = true;                 % Ignore buses before transformer
Settings.U_t_guess = 1;                                 % initial transformer voltage guess
Settings.U_l_guess = 0.97;                              % initial load voltage guess
Settings.U_j_guess = 1;                                 % initial jointconnection voltage guess

%% Run
InitializeTransformer;          % Initialize transformer parameters
InitializeCables;               % Initialize cables
SetupConnections;               % Set up connection buses, names, type etc.
SetupArrays;                    % Match cable parameters and connections to matrices
SetupInput;                     % Read input data from files
SetupProblem;                   % Set up solver input matrices


