% Constant parameters
l=2;               % Length [km]         
w=2*pi*50;          % Frequency [rad/s]
R=2e-3;             % Series resistance [ohm/km]
L=3e-3;             % Series inductance [H/km]
G=1e-6;             % Shunt conductance [S/km]
C=2e-3;             % Shunt capacitance [F/km]
% x=l:-0.01:0;      % Distance from receiving end [km]
x=l;         % Distance from receiving end [km]

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
I_R=2;              % Receiving current [A]

% Sending end
V_inc=(V_R+Z_C*I_R)*exp(gamma.*x)/2;        % Incident voltage [V]
V_ref=(V_R-Z_C*I_R)*exp(-gamma.*x)/2;       % Reflected voltage [V]
V_S=V_inc+V_ref;                            % Sending voltage [V]
I_S=((V_R/Z_C+I_R)*exp(gamma.*x)/2)...
    -((V_R/Z_C-I_R)*exp(-gamma.*x)/2);      % Sending current [A]

% Plot
plot(x,V_S);
title('Cable voltage');
xlabel('Distance from receiving end [km]');
ylabel('Voltage [V]');
figure;
plot(x,I_S);
title('Cable current');
xlabel('Distance from receiving end [km]');
ylabel('Current [A]');