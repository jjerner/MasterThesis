%% Parameters

%if(läser från exempelvis excel)
    % do things
    
%else
    % gör exempelkabel
% 
% l       = 1;        % [km]      längd i km
% I_max   = 375;      % [A]       maximal belastningsström
% 
% r       = 0.125;    % [Ohm/km]  resistans per km
% r0      = 0.125;    % [Ohm/km]  nollföljdsresistans
% 
% x       = 0.069;    % [Ohm/km]  reaktans per km
% x0      = 0.324;    % [Ohm/km]  nollföljdsreaktans
% 
% Cables = struct('length', l,...
%                 'I_max', I_max,...
%                 'r', r,....
%                 'r0', r0,...
%                 'x', x,...
%                 'x0', x0);
%             
% clear l I_max r r0 x x0

% Constant parameters
cableData(1).l=1;                % Length [km]         
cableData(1).R=0.125;            % Series resistance [ohm/km]
cableData(1).L=0.23e-3;          % Series inductance [H/km]
cableData(1).G=0;                % Shunt conductance [S/km]
cableData(1).C=2e-9;             % Shunt capacitance [F/km]

% Calculated characteristics
cableData(1).z=cableData(1).R+j*w*cableData(1).L;          % Series impedance [ohm/km]
cableData(1).y=cableData(1).G+j*w*cableData(1).C;          % Shunt admittance [S/km]
cableData(1).Z=cableData(1).z*cableData(1).l;              % Total series impedance [ohm/km]
cableData(1).Y=cableData(1).y*cableData(1).L;              % Total shunt admittance [S/km]
cableData(1).Z_C=sqrt(cableData(1).z/cableData(1).y);      % Characteristic impedance [ohm]
cableData(1).gamma=sqrt(cableData(1).y*cableData(1).z);    % Propagation constant [?]
cableData(1).alpha=real(cableData(1).gamma);  % Attenuation constant [?]
cableData(1).beta=imag(cableData(1).gamma);   % Phase constant [rad/m]

cableData(2) = cableData(1);