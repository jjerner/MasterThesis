% Initialize transformer

disp(['Loading transformer data from: "', Settings.transformerDataPath,'"']);
disp(' ');
load(Settings.transformerDataPath);        % Load transformer data

% Description of TransformerData contents:
% TransformerData.Uprim       [V]    m�rksp�nning prim�r
% TransformerData.Usec        [V]    m�rksp�nning sekund�r
% TransformerData.S_tot       [VA]   m�rkeffekt
% TransformerData.P_loss      [W]    belastningsf�rluster
% 
% TransformerData.R2k         [pu]   kortslutningsresistans
% TransformerData.Z2k         [pu]   kortslutningsimpedans
% 
% TransformerData.P0          [W]    tomg�ngsf�rluster
% TransformerData.Q0          [VAR]  tomg�ngsf�rluster
% TransformerData.I0          [pu]   tomg�ngsstr�m
% TransformerData.R0          [pu]   nollf�ljdsresistans
% TransformerData.Z0          [pu]   nollf�ljdsimpedans


%% RESHAPED DATA FOR [PER-UNIT]

% base power and voltages
TransformerData.S_base      = TransformerData.S_tot;
TransformerData.U_prim_base = TransformerData.Uprim;
TransformerData.U_sec_base  = TransformerData.Usec;

% base currents
TransformerData.I_prim_base = TransformerData.S_base / (sqrt(3)*TransformerData.U_prim_base);
TransformerData.I_sec_base  = TransformerData.S_base / (sqrt(3)*TransformerData.U_sec_base);

% base impedances
TransformerData.Z_prim_base = (TransformerData.U_prim_base)/(sqrt(3)*TransformerData.I_prim_base);
TransformerData.Z_sec_base  = (TransformerData.U_sec_base)/(sqrt(3)*TransformerData.I_sec_base);

% Impedances
TransformerData.Z2k_pu      = TransformerData.Z2k/100;
TransformerData.R2k_pu      = TransformerData.R2k/100;

TransformerData.R0_pu       = TransformerData.R0;
TransformerData.Z0_pu       = TransformerData.Z0;

