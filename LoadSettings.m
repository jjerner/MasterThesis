%% Settings

%% Common
Settings.cableDBPath='data/Ledningsdata.mat';           % Path to cable database file
Settings.removeHighVoltageBuses = true;                 % Ignore buses before transformer
Settings.U_t_guess = 1;                                 % Initial transformer voltage guess
Settings.U_l_guess = 0.97;                              % Initial load voltage guess
Settings.U_j_guess = 1;                                 % Initial jointconnection voltage guess

%% Location specific

% === Hallonv�gen ===
Settings.location='Hallonv�gen';                        % Location name
Settings.inputDir = 'data/Inputs/T085';                 % Directory for input files
Settings.gridCableDataPath = 'data/T085 Hallonvagen.xlsx';              % Path to grid cable data file
Settings.transformerDataPath='data/TransformerData_Hallonvagen.mat';    % Path to transformer data file

% === Amundstorp ===
% Settings.location='Amundstorp';                         % Location name
% Settings.inputDir = 'data/Inputs/T317';                 % Directory for input files
% Settings.gridCableDataPath = 'data/T317 Amundstorp.xlsx';               % Path to grid cable data file
% Settings.transformerDataPath='data/TransformerData_Amundstorp.mat';     % Path to transformer data file