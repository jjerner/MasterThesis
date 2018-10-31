%% Parameters

ExampleCable = 1;

if ExampleCable == 1
    % Constant parameters
    cableData(1).l=1;                % Length [km]         
    cableData(1).R=0.125;            % Series resistance [ohm/km]
    cableData(1).L=0.23e-3;          % Series inductance [H/km]
    cableData(1).G=0;                % Shunt conductance [S/km]
    cableData(1).C=2e-9;             % Shunt capacitance [F/km]

    % Calculated characteristics
    cableData(1).z=cableData(1).R+j*w*cableData(1).L;           % Series impedance [ohm/km]
    cableData(1).y=cableData(1).G+j*w*cableData(1).C;           % Shunt admittance [S/km]
    cableData(1).Z=cableData(1).z*cableData(1).l;               % Total series impedance [ohm/km]
    cableData(1).Y=cableData(1).y*cableData(1).L;               % Total shunt admittance [S/km]
    cableData(1).Z_C=sqrt(cableData(1).z/cableData(1).y);       % Characteristic impedance [ohm]
    cableData(1).gamma=sqrt(cableData(1).y*cableData(1).z);     % Propagation constant [?]
    cableData(1).alpha=real(cableData(1).gamma);                % Attenuation constant [?]
    cableData(1).beta=imag(cableData(1).gamma);                 % Phase constant [rad/m]

    cableData(2) = cableData(1);

else
    % Read data from file
    
    %for i = 1:length( /file/ )
        %compare file.name(i) to Ledningsdata.name to get cable index, ID
        %cableData(i).l = getlength from file
        %cableData(i).R = Ledningsdata.R(ID);
        %cableData(i).R0 = Ledningsdata.R0(ID);
        %.
        %.
        %.
        
        
    %end
    
end