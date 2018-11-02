clear

%add paths
AddPathsToMain                  % Add local paths to data repositories & PV model

%% Initialize parameters
freq = 50;                      % frequency
w = 2*pi*freq;                  % omeeeeeeeeeeega
j = 1i;

InitializeTransformer;         	% transformer parameters
InitializeCables;               % cable parameters


%% Calculations