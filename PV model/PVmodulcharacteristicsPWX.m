%% PV modul characteristics

PVchara.K = 1.38065e-23;    %Boltzman constant
PVchara.q = 1.602e-19;      %Charge of electron
PVchara.Eg = 1.12;          %Band gap of silicon at 25 degree celcius
PVchara.a = 1.3;            %Diode ideality constant
PVchara.Iscn = 3.11;        %Nominal SC Current
PVchara.Kv = -0.0725;       %Temperature voltage constant 
PVchara.Ki= 0.0013;         %Temperature current constant
PVchara.Ns = 36;            %No of series connected cells
PVchara.NOCT = 45;          %nominal operating cell temperature
PVchara.Tn = 25 + 273;      %Nominal temperature
PVchara.Gn = 1000;          %Nominal irradiance
PVchara.Rs = 0.75;          %Serial resistor
PVchara.Rp = 110;           %Parallel resistor
PVchara.Vocn= 21.8;         %Open-Circuit Voltage 

PVchara.NbrModul = 205;     %Number of modules