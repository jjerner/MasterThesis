% Verification main script
% This is quite messy

clear

addpath('European_LV_CSV');
addpath('European_LV_CSV/Load Profiles');
addpath('European_LV_CSV/Solutions');
addpath('European_LV_CSV/Solutions/OpenDSS');
addpath('European_LV_CSV/Solutions/OpenDSS/Time Series');
addpath('European_LV_CSV/Solutions/GridLab-D');
addpath('European_LV_CSV/Solutions/GridLab-D/Time Series');
addpath('..');
freq=50;
j = 1i;

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

S_complex = createComplexPower(S_bus,'P', pf, 0);
timeLine=500:550;
resultSet=doSweepCalcs(Z_ser_tot, S_complex, U_bus, connectionBuses, busType, timeLine);

% RESULTS

% comparison data
load('GridLabData');

verificationPlots;