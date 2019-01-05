
clear

addpath('European_LV_CSV');
addpath('European_LV_CSV/Load Profiles');
addpath('European_LV_CSV/Solutions');
addpath('European_LV_CSV/Solutions/OpenDSS');
addpath('European_LV_CSV/Solutions/OpenDSS/Time Series');
addpath('European_LV_CSV/Solutions/GridLab-D');
addpath('European_LV_CSV/Solutions/GridLab-D/Time Series');
addpath('..');
j = 1i;
freq = 50;

% Read data
Transformer;
Cables;

% Setup arrays and add loads
AddConnectionType;
SetupArrays;

% INPUT
ELVinputs;
verificationProblem;

% CALC
pf = 0.95;

S_complex = createComplexPower(S_bus, pf, 0);

verResultSet=doSweepCalcs(Z_ser_tot, S_complex, U_bus, connectionBuses, busType, 1:1440);

% RESULTS

% comparaison data
load('GridLabData');

verificationPlots;


