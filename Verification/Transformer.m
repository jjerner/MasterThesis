
%From Transformer.csv in the european LV case

TransformerData.Name = 'Tr1';
TransformerData.phases = 3;
TransformerData.bus1 = 'Source';
TransformerData.bus2 = 1;
TransformerData.U_prim = 11000;
TransformerData.U_sec = 416;
TransformerData.S_tot = 0.8*1e6;
TransformerData.Con_prim = 'Delta';
TransformerData.Con_sec = 'wye';
TransformerData.X = 4;
TransformerData.R = 0.4;

% calc & setup in same form as previous data

TransformerData.Z2k = TransformerData.R + j*TransformerData.X;
TransformerData.R2k = 0.4;

% base power and voltages
TransformerData.S_base      = TransformerData.S_tot;
TransformerData.U_prim_base = TransformerData.U_prim;
TransformerData.U_sec_base  = TransformerData.U_sec;

% base impedances
TransformerData.Z_prim_base = (TransformerData.U_prim_base^2)/TransformerData.S_base;
TransformerData.Z_sec_base  = (TransformerData.U_sec_base^2)/TransformerData.S_base;

% base currents
TransformerData.I_prim_base = TransformerData.S_base / (sqrt(3)*TransformerData.U_prim_base);
TransformerData.I_sec_base  = TransformerData.S_base / (sqrt(3)*TransformerData.U_sec_base);

% Impedances
TransformerData.Z2k_pu      = TransformerData.Z2k / TransformerData.Z_sec_base;  
TransformerData.R2k_pu      = TransformerData.R2k / TransformerData.Z_sec_base;

% TransformerData.R0_pu       = TransformerData.R0;
TransformerData.Z0_pu       = 0;

% Recalculation of impedances for both HV and LV sides (These might not be needed)
TransformerData.Z2_pu       = TransformerData.Z2k_pu/2;       % half on LV side
TransformerData.Z1_pu       = (TransformerData.Z2k_pu/2)*(TransformerData.U_sec_base/TransformerData.U_prim_base)^2;

Info.addedTransformerBusAtIndex = [1 2];