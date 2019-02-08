%% Settings

global Settings;        % Make settings struct global

%% Constants
j = 1i;

%% Paths
%addpath('Verification');
addpath('PV model');
addpath('analysis');
addpath('minisys');

%% Common settings
Settings.cableDBPath            ='data/Ledningsdata.mat';   % Path to cable database file
Settings.removeHighVoltageBuses = true;                     % Ignore buses before transformer
Settings.U_j_guess              = 1.00;                     % Initial joint connection voltage guess
Settings.U_l_guess              = 0.99;                     % Initial load voltage guess
Settings.defaultMaxIter         = 100;                      % Default number for maximum number of iterations
Settings.defaultConvEps         = 1e-4;                     % Default value for convergence limit
Settings.defaultShuntCap        = false;                    % Default value for shunt capacitors (true = enabled)
Settings.defaultConvPlots       = false;                    % Default value for convergence plots in solveFBSM (true = enabled)
Settings.defaultWaitBar         = true;                     % Default value for waitbar in doSweepCalcs (true = enabled)

%% Location specific settings

% === Hallonvägen ===
Settings.location            = 'Hallonvägen';                           % Location name
Settings.inputDir            = 'data/Inputs/T085';                      % Directory for input files
Settings.gridCableDataPath   = 'data/T085 Hallonvagen.xlsx';            % Path to grid cable data file
Settings.transformerDataPath = 'data/TransformerData_Hallonvagen.mat';  % Path to transformer data file

% === Amundstorp ===
% Settings.location            = 'Amundstorp';                            % Location name
% Settings.inputDir            = 'data/Inputs/T317';                      % Directory for input files
% Settings.gridCableDataPath   = 'data/T317 Amundstorp.xlsx';             % Path to grid cable data file
% Settings.transformerDataPath = 'data/TransformerData_Amundstorp.mat';   % Path to transformer data file

%% Display
disp('Settings loaded successfully.');