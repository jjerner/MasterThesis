clear;                          % Clear everything
LoadSettings;                   % Load settings
% === BEGIN Set up system ===
InitializeTransformer;          % Initialize transformer parameters
InitializeCables;               % Initialize cables
SetupConnections;               % Set up connection buses, names, type etc.
SetupArrays;                    % Match cable parameters and connections to matrices
% END Set up system ===
ReadInputTXT;                   % Read input data from .txt files
SetupProblem;                   % Set up solver input matrices

% Set default timeline
timeLine=1:8760;