%% Parameters

% Input parameters from spec
TransformerData.Uprim      = 11000;         % [V]   märkspänning primär
TransformerData.Usec       = 420;           % [V]   märkspänning sekundär
TransformerData.S_tot      = 500e3;         % [VA]  märkeffekt
TransformerData.P_loss     = 4984;          % [W]   belastningsförluster

TransformerData.R2k        = 0.997;         % [%]   kortslutningsresistans, procent av vad?
TransformerData.Z2k        = 5.730;         % [%]   kortslutningsimpedans, procent av vad?

TransformerData.P0         = 446;           % [W]   tomgångsförluster
TransformerData.Q0         = 0;             % [VAR] tomgångsförluster
TransformerData.I0         = 0.1;           % [%]   tomgångsström, procent av vad?
TransformerData.R0         = 1;             % [%]   nollföljdsresistans, procent av vad?
TransformerData.Z0         = 5.728;         % [%]   nollföljdsimpedans, procent av vad?

% RESHAPED DATA FOR PER-UNIT

% base power and voltages
TransformerData.S_base = TransformerData.S_tot;
TransformerData.U_prim_base = TransformerData.Uprim;
TransformerData.U_sec_base  = TransformerData.Usec;

% base impedances
TransformerData.Z_prim_base = (TransformerData.U_prim_base^2)/TransformerData.S_base;
TransformerData.Z_sec_base  = (TransformerData.U_sec_base^2)/TransformerData.S_base;

% base currents
TransformerData.I_prim_base = TransformerData.S_base / TransformerData.U_prim_base;  %[A RMS]
TransformerData.I_sec_base = TransformerData.S_base / TransformerData.U_sec_base;    %[A RMS]


TransformerData.Z2k_pu      = TransformerData.R2k;  
TransformerData.R2k_pu      = TransformerData.Z2k;

% Z primary side of transformer based on I0, R0, X0
