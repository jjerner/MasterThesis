%% Parameters

fileToRead = 'T317 Amundstorp.xlsx';
%fileToRead = 'T085 hallonvagen.xlsx';
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
    for iCables = 2:nCables
        CableData(iCables) = CableData(1);
    end
    
else
    
    disp(['Reading from file: "', fileToRead,'"']);
    disp(' ');
    load Ledningsdata.mat                           % get table of cable data
    
    % Read data from file
    data = importdata(fileToRead);
    data.textdata = data.textdata(4:end, :);        % remove first 3 rows of nonsense in textdata
    
    for iCables = 1:length(data.textdata(:,2)) 
        %compare (find the right cable data)
        cableFound = false;
        index = 1;
        
        
        while ~cableFound
            nameToCompare = Ledningsdata.Name{index};
            if nameToCompare(end-2) == '/'
                nameToCompare = nameToCompare(1:end-3);
            end
            
            if length(data.textdata{iCables,2}) == length(nameToCompare)
                if data.textdata{iCables,2} == nameToCompare
                    cableFound = true;
                else
                    index = index + 1;
                end
            else
                index = index + 1; 
            end
            
            
            if index == (length(Ledningsdata.Area) + 1)
                disp(['Could not find cable match, using standard cable at index ', num2str(iCables)]);
                cableFound = true;
                index = 4;  % <-- set appropriate index to "standard cable"
            end
        end
        
        %read data
        CableData(iCables).l      = data.data(iCables,5);                 % [m]
        CableData(iCables).Rpl    = Ledningsdata.R(index);                % [Ohm / km]
        CableData(iCables).R0pl   = Ledningsdata.R0(index);               % [Ohm / km]
        CableData(iCables).Xpl    = Ledningsdata.X(index);                % [Ohm / km]
        CableData(iCables).X0pl   = Ledningsdata.X0(index);               % [Ohm / km]
        CableData(iCables).Bdpl   = Ledningsdata.Bd(index);               % [uS / km / fas]
        CableData(iCables).Imax   = Ledningsdata.Imax;                    % [A]
        
        % assumed data
        CableData(iCables).G      = 0;
        
        %formatting + calculations
        CableData(iCables).R      = (CableData(iCables).l / 1e3) * CableData(iCables).Rpl;                        % [Ohm]
        CableData(iCables).X      = (CableData(iCables).l / 1e3) * CableData(iCables).Xpl;                        % [Ohm]
        CableData(iCables).L      = (CableData(iCables).l / 1e3) * CableData(iCables).Xpl / (2*pi*freq);          % [H]
        CableData(iCables).C      = (CableData(iCables).l / 1e3) * (CableData(iCables).Bdpl / (2*pi*freq*1e6));   % [F]
        CableData(iCables).Bd     = (CableData(iCables).l / 1e3) * CableData(iCables).Bdpl;                       % [S]
        
        CableData(iCables).Z_ser=CableData(iCables).R+j*CableData(iCables).X;             % Series impedance [ohm]
        CableData(iCables).Y_shu=CableData(iCables).G+j*CableData(iCables).Bd;            % Shunt admittance [S]


    end
    
    % Sort startpoint - endpoint and node types
    readNodes       % outputs: start2end & nodeType, matrices describing where each cable is connected.
    
end

% clear some workspace
clear ExampleCable index nameToCompare iCables cableFound