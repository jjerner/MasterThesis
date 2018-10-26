clear
%% Initialize parameters
freq = 50;                      % frequency
w = 2*pi*freq;                  % omeeeeeeeeeeega

InitializeTransformer;         	% transformer parameters
InitializeCables;               % cable parameters
%% Calculations
%% Summarize impedance of circuit

Z_1 = 10 + 3i;                  % house 1
Z_2 = 5 + 1i;                   % house 2
Z_loads = [Z_1; Z_2];

Z_1c = 0.125 + 0i;              % cable 1
Z_2c = 0.250 + 01;              % cable 2
Z_cables = [Z_1c; Z_2c];

Z_grid = [Z_loads, Z_cables];

% impedance in parallel: (1/Z_tot) = (1 / Z_1) + (1 / Z_2)
% impedance in series: Z = Z_1 + Z_2

nom = prod(Z_grid);
denom = sum(Z_grid);
Z_tot = nom / denom;

%% calculate power needed

P_1 = 100;
P_2 = 50;
P_loads = [P_1; P_2];
P_tot = sum(P_loads);

%% calculate current needed from transformer

I_input = P_tot / Transformer.U_1;

% something should go here to model transformer i guess

I_2 = P_tot / Transformer.U_2;

I_loads = zeros(length(Z_loads));
for i = 1:length(Z_loads)
    I_loads(i) = (Z_loads(i) + sum(Z_cables(1:i))) / sum(Z_grid,'all');
end

% voltage drop across a cable, simplified: U_drop = I * Z_cable
% calculate voltage drops across all the elements in Z_grid
% Need something before this to find current through all these elements

VoltageDrops = zeros(length(Z_grid), 2);    % Matrix with input and output of each drop

for i = 1:length(Z_grid)
    if i == 1
        Us = Transformer.U_2;               % "voltage on input side"
        I_in = I_loads(i);                  % current flow through cable
        [Ur, I_out] = cableCalc(Us, I_in, cableData, i);
        %Z_cable = Z_grid(i);                % impedance across cable
        %Ur = Us - (I_in * abs(Z_cable));    % "voltage on reciever side"
    
    else
        Us = Transformer.U_2;               % "voltage on input side"
        I_in = I_loads(i);                  % current flow through cable
        [Ur, I_out] = cableCalc(Us, I_in, cableData, i);
        %Z_cable = Z_grid(i);                % impedance across cable
        %Ur = Us - (I_in * abs(Z_cable));    % "voltage on reciever side"
    end
    
    VoltageDrops(i, :) = [Us, Ur];
    disp(['Sender: ', num2str(round(Us)), ' - Reciever: ', num2str(round(Ur))]);
end
