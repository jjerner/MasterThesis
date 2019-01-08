clear

%add paths
AddPathsToMain                  % Add local paths to data repositories & PV model

%% Settings
Settings.location='Hallonvägen';                        % Location name
Settings.inputDir = 'data/Inputs/T085';                 % Directory for input files
Settings.cableDBPath='data/Ledningsdata.mat';           % Path to cable database file
Settings.gridCableDataPath = 'data/T085 Hallonvagen.xlsx';              % Path to grid cable data file
Settings.transformerDataPath='data/TransformerData_Hallonvagen.mat';    % Path to transformer data file

%% Initialize parameters (CONSTANTS)
%freq = 50;                      % frequency
%w = 2*pi*freq;                  % OMEGA
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


