
clear

addpath('European_LV_CSV');
addpath('European_LV_CSV/Load Profiles');
addpath('..');
j = 1i;
freq = 50;

% Read data
Transformer;
Cables;

% Setup arrays and add loads
AddConnectionType;
SetupArrays;

% inputs
ELVinputs;
verificationProblem;