%% Parameters

disp(['Loading transformer data for: ', location]);
disp(' ');

switch location
    case 'Amundstorp'
        TransformerData.Uprim      = 22000;         % [V]    märkspänning primär
        TransformerData.Usec       = 420;           % [V]    märkspänning sekundär
        TransformerData.S_tot      = 50e3;          % [VA]   märkeffekt
        TransformerData.P_loss     = 948;           % [W]    belastningsförluster

        TransformerData.R2k        = 1.896;         % [pu]   kortslutningsresistans
        TransformerData.Z2k        = 4.222;         % [pu]   kortslutningsimpedans

        TransformerData.P0         = 111;           % [W]    tomgångsförluster
        TransformerData.Q0         = 0;             % [VAR]  tomgångsförluster
        TransformerData.I0         = 0;             % [pu]   tomgångsström
        TransformerData.R0         = 0;             % [pu]   nollföljdsresistans
        TransformerData.Z0         = 0;             % [pu]   nollföljdsimpedans
        
    case 'Hallonvägen'
        TransformerData.Uprim      = 22000;         % [V]    märkspänning primär
        TransformerData.Usec       = 420;           % [V]    märkspänning sekundär
        TransformerData.S_tot      = 500e3;         % [VA]   märkeffekt
        TransformerData.P_loss     = 4704;          % [W]    belastningsförluster

        TransformerData.R2k        = 0.941;         % [pu]   kortslutningsresistans
        TransformerData.Z2k        = 4.78;          % [pu]   kortslutningsimpedans

        TransformerData.P0         = 847;           % [W]    tomgångsförluster
        TransformerData.Q0         = 0;             % [VAR]  tomgångsförluster
        TransformerData.I0         = 0;             % [pu]   tomgångsström
        TransformerData.R0         = 0;             % [pu]   nollföljdsresistans
        TransformerData.Z0         = 0;             % [pu]   nollföljdsimpedans
end

%% RESHAPED DATA FOR [PER-UNIT]

% base power and voltages
TransformerData.S_base      = TransformerData.S_tot;
TransformerData.U_prim_base = TransformerData.Uprim;
TransformerData.U_sec_base  = TransformerData.Usec;

% base impedances
TransformerData.Z_prim_base = (TransformerData.U_prim_base^2)/TransformerData.S_base;
TransformerData.Z_sec_base  = (TransformerData.U_sec_base^2)/TransformerData.S_base;

% base currents
TransformerData.I_prim_base = TransformerData.S_base / TransformerData.U_prim_base;
TransformerData.I_sec_base  = TransformerData.S_base / TransformerData.U_sec_base;

% Impedances
TransformerData.Z2k_pu      = TransformerData.Z2k;  
TransformerData.R2k_pu      = TransformerData.R2k;

TransformerData.R0_pu       = TransformerData.R0;
TransformerData.Z0_pu       = TransformerData.Z0;

% Recalculation of impedances for both HV and LV sides (These might not be needed)
TransformerData.Z2_pu       = TransformerData.Z2k_pu/2;       % half on LV side
TransformerData.Z1_pu       = (TransformerData.Z2k_pu/2)*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2;

