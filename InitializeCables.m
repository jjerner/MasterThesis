%% Parameters

fileToRead = 'T317 Amundstorp.xlsx';
ExampleCable = 0;
j = 1i;
%freq = 50;

disp('Loading cable data')

if ExampleCable == 1
    % Constant parameters
    CableData(1).l=1;                % Length [km]         
    CableData(1).R=0.125;            % Series resistance [ohm/km]
    CableData(1).L=0.23e-3;          % Series inductance [H/km]
    CableData(1).G=0;                % Shunt conductance [S/km]
    CableData(1).C=2e-9;             % Shunt capacitance [F/km]

    % Calculated characteristics
    CableData(1).z=CableData(1).R+j*w*CableData(1).L;           % Series impedance [ohm/km]
    CableData(1).y=CableData(1).G+j*w*CableData(1).C;           % Shunt admittance [S/km]
    CableData(1).Z=CableData(1).z*CableData(1).l;               % Total series impedance [ohm/km]
    CableData(1).Y=CableData(1).y*CableData(1).L;               % Total shunt admittance [S/km]
    CableData(1).Z_C=sqrt(CableData(1).z/CableData(1).y);       % Characteristic impedance [ohm]
    CableData(1).gamma=sqrt(CableData(1).y*CableData(1).z);     % Propagation constant [?]
    CableData(1).alpha=real(CableData(1).gamma);                % Attenuation constant [?]
    CableData(1).beta=imag(CableData(1).gamma);                 % Phase constant [rad/m]
    
    nCables = 2;
    for i = 2:nCables
        CableData(i) = CableData(1);
    end
    
else
    disp(['Reading from file: "', fileToRead,'"']);
    disp(' ');
    load Ledningsdata.mat                           % get table of cable data
    
    % Read data from file
    data = importdata(fileToRead);
    data.textdata = data.textdata(4:end, :);        % remove first 3 rows of nonsense in textdata
    
    for i = 1:length(data.textdata(:,2)) 
        %compare (find the right cable data)
        cableFound = false;
        index = 1;
        
        
        while ~cableFound
            nameToCompare = Ledningsdata.Name{index};
            if nameToCompare(end-2) == '/'
                nameToCompare = nameToCompare(1:end-3);
            end
            
            if length(data.textdata{i,2}) == length(nameToCompare)
                if data.textdata{i,2} == nameToCompare
                    cableFound = true;
                else
                    index = index + 1;
                end
            else
                index = index + 1; 
            end
            
            
            if index == (length(Ledningsdata.Area) + 1)
                disp(['Could not find cable match, using standard cable at index ', num2str(i)]);
                cableFound = true;
                index = 4;  % <-- set appropriate index to "standard cable"
            end
        end
        
        %read data
        CableData(i).l      = data.data(i,5);                       % [m]
        CableData(i).Rpl    = Ledningsdata.R(index);                % [Ohm / km]
        CableData(i).R0pl   = Ledningsdata.R0(index);               % [Ohm / km]
        CableData(i).Xpl    = Ledningsdata.X(index);                % [Ohm / km]
        CableData(i).X0pl   = Ledningsdata.X0(index);               % [Ohm / km]
        CableData(i).Bdpl   = Ledningsdata.Bd(index);               % [uS / km / fas]
        CableData(i).Imax   = Ledningsdata.Imax;                    % [A]
        
        % assumed data
        CableData(i).G      = 0;
        
        %formatting + calculations
        CableData(i).R      = (CableData(i).l / 1e3) * CableData(i).Rpl;                        % [Ohm]
        CableData(i).X      = (CableData(i).l / 1e3) * CableData(i).Xpl;                        % [Ohm]
        CableData(i).L      = (CableData(i).l / 1e3) * CableData(i).Xpl / (2*pi*freq);          % [H]
        CableData(i).C      = (CableData(i).l / 1e3) * (CableData(i).Bdpl / (2*pi*freq*1e6));   % [F]
        CableData(i).Bd     = (CableData(i).l / 1e3) * CableData(i).Bdpl;                       % [S]
        
        CableData(i).Z=CableData(i).R+j*CableData(i).X;             % Series impedance [ohm]
        CableData(i).Y=CableData(i).G+j*CableData(i).Bd;            % Shunt admittance [S]


    end
    
end