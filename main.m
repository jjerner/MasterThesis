clear
%% Initialize parameters

InitializeTransformer;         	% transformer parameters
InitializeCables;               % cable parameters

%% Calculations

% Summarize impedance

Z_1 = 10 + 3i;
Z_2 = 5 + 1i;

% impedance in parallel: (1/Z_tot) = (1 / Z_1) + (1 / Z_2)
% impedance in series: Z = Z_1 + Z_2

nom = Z_1 * Z_2;
denom = Z_1 + Z_2;

Z_tot = nom / denom;

% calculate power needed

P_1 = 100;
P_2 = 50;

P_tot = P_1 + P_2;

% calculate current needed from transformer

i_input = P_tot / Transformer.V_1;


