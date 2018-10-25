% Constant parameters
l=2;                % Length [km]         
w=1;                % Frequency [rad/s]
R=2e-3;             % Series resistance [ohm/km]
L=3e-3;             % Series inductance [H/km]
G=1;                % Shunt conductance [S/km]
C=2;                % Shunt capacitance [F/km]
x=l:-0.01:0;        % Distance from receiving end

% Calculated characteristics
z=R+j*w*L;          % Series impedance [ohm/km]
y=G+j*w*C;          % Shunt admittance [S/km]
Z=z*l;              % Total series impedance [ohm/km]
Y=y*L;              % Total shunt admittance [S/km]
Z_C=sqrt(z/y);      % Characteristic impedance [ohm]
gamma=sqrt(y*z);    % Propagation constant [?]
alpha=real(gamma);  % Attenuation constant [?]
beta=imag(gamma);   % Phase constant [rad/m]

% Receiving end
V_R=400;            % Receiving voltage [V]
I_R=1;              % Receiving current [A]

% Sending end
V_S=((V_R+Z_C*I_R)*exp(gamma.*x)/2)...
    +((V_R-Z_C*I_R)*exp(-gamma.*x)/2);      % Sending voltage [V]
I_S=((V_R/Z_C+I_R)*exp(gamma.*x)/2)...
    -((V_R/Z_C-I_R)*exp(-gamma.*x)/2);      % Sending current [A]
