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
cableData(1).x=l;                % Distance from receiving end [km]

% Calculated characteristics
cableData(1).z=R+j*w*L;          % Series impedance [ohm/km]
cableData(1).y=G+j*w*C;          % Shunt admittance [S/km]
cableData(1).Z=z*l;              % Total series impedance [ohm/km]
cableData(1).Y=y*L;              % Total shunt admittance [S/km]
cableData(1).Z_C=sqrt(z/y);      % Characteristic impedance [ohm]
cableData(1).gamma=sqrt(y*z);    % Propagation constant [?]
cableData(1).alpha=real(gamma);  % Attenuation constant [?]
cableData(1).beta=imag(gamma);   % Phase constant [rad/m]