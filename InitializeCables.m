%% Parameters

fileToRead = 'T317 Amundstorp.xlsx';
ExampleCable = 0;
%freq = 50;

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
    
    nCables = 2;
    for i = 2:nCables
        cableData(i) = cableData(1);
    end
    
else
    load Ledningsdata.mat                           % get table of cable data
    
    % Read data from file
    data = importdata(fileToRead);
    data.textdata = data.textdata(4:end, :);        % remove first 3 rows of nonsense in textdata
    
    for i = 1:length(data.textdata(:,2)) 
        %compare (find the right cable data)
        cableFound = false;
        index = 1;
        nameToCompare = Ledningsdata.Name{index};
        
        if nameToCompare(end-2) == '/'
            nameToCompare = nameToCompare(1:end-3);
        end
        
        while ~cableFound
            if length(data.textdata{i,2}) == length(nameToCompare)
                if data.textdata{i,2} == nameToCompare
                    
                    cableFound = true;
                end
                index = index + 1;
            else
                index = index + 1; 
            end
            
            
            if index == length(Ledningsdata.Area) + 1
                disp('Couldnt find cable match!')
                disp(['Using standard cable at index: ', num2str(i)]);
                index = 4;  % <-- set appropriate index to "standard cable"
            end
        end
        
        %get data
        cableData(i).l      = data.data(i,5);                       % [m]
        cableData(i).Rpl    = Ledningsdata.R(index);                % [Ohm / km]
        cableData(i).R0pl   = Ledningsdata.R0(index);               % [Ohm / km]
        cableData(i).Xpl    = Ledningsdata.X(index);                % [Ohm / km]
        cableData(i).X0pl   = Ledningsdata.X0(index);               % [Ohm / km]
        cableData(i).Bdpl   = Ledningsdata.Bd(index);               % [uS / km / fas]
        cableData(i).Imax   = Ledningsdata.Imax;                    % [A]
        
        %formatting
        cableData(i).R      = (cableData(i).l / 1e3) * cableData(i).Rpl;                        % [Ohm]
        cableData(i).L      = (cableData(i).l / 1e3) * cableData(i).X * 1000 / (2*pi*freq);     % [mH]
        cableData(i).C      = (cableData(i).l / 1e3) * (cableData(i).Bd / (2*pi*freq*1e6));     % [F]
        
        
    end
    
end