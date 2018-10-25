clear
%% Initialize parameters
InitializeTransformer;         	% transformer parameters
InitializeCables;               % cable parameters
%% Calculations
%% Summarize impedance of circuit

Z_1 = 10 + 3i;                  % house 1
Z_2 = 5 + 1i;                   % house 2
Z_grid = [Z_1; Z_2];

% impedance in parallel: (1/Z_tot) = (1 / Z_1) + (1 / Z_2)
% impedance in series: Z = Z_1 + Z_2

nom = prod(Z_grid);
denom = sum(Z_grid);
Z_tot = nom / denom;

%% calculate power needed

P_1 = 100;
P_2 = 50;
P_grid = [P_1; P_2];
P_tot = sum(P_grid);

%% calculate current needed from transformer

I_input = P_tot / Transformer.U_1;

% something should go here to model transformer i guess

I_2 = P_tot / Transformer.U_2;

% voltage drop across a cable, simplified: U_drop = I * Z_cable
% calculate voltage drops across all the elements in Z_grid
% Need something before this to find current through all these elements

VoltageDrops = zeros(length(Z_grid), 2);    % Matrix with input and output of each drop

for i = 1:length(Z_grid)
    if i == 1
        Us = Transformer.U_2;               % "voltage on input side"
        I_in = I_2;                         % current flow through cable <-- WRONG
        Z_cable = Z_grid(i);                % impedance across cable
        Ur = Us - (I_in * abs(Z_cable));    % "voltage on reciever side"
    
    else
        Us = Ur;                            % "voltage on input side"
        I_in = I_2;                         % current flow through cable <-- WRONG
        Z_cable = Z_grid(i);                % impedance across cable
        Ur = Us - (I_in * abs(Z_cable));    % "voltage on reciever side"
    end
    
    VoltageDrops(i, :) = [Us, Ur];
    
end
