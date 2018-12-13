
load('Lines.mat');
load('LineCodes.mat');

connectionBuses(:,1) = Lines.Bus1;
connectionBuses(:,2) = Lines.Bus2;

for iCode = 1:height(LineCodes)
    currentName = LineCodes.Name(iCode);
    resistance1 = LineCodes.R1(iCode);
    conductance1 = LineCodes.X1(iCode);
    resistance0 = LineCodes.R0(iCode);
    conductance0 = LineCodes.X0(iCode);
    
    for iLine = 1:height(Lines)
       %read data
       if currentName == Lines.LineCode(iLine)
            CableData(iLine).l      = Lines.Length(iLine);
            CableData(iLine).Rpl    = resistance1;
            CableData(iLine).R0pl   = resistance0;
            CableData(iLine).RNpl   = resistance1;
            CableData(iLine).Xpl    = conductance1;
            CableData(iLine).X0pl   = conductance0;
            CableData(iLine).XNpl   = conductance1;
            CableData(iLine).Bdpl   = 0;
            CableData(iLine).Imax   = inf;

            % assumed data
            CableData(iLine).G      = 0;

            %formatting + calculations (NOTE: NOT IN PER-UNIT)

            CableData(iLine).R      = (CableData(iLine).l / 1e3) * CableData(iLine).Rpl;
            CableData(iLine).X      = (CableData(iLine).l / 1e3) * CableData(iLine).Xpl; 
            CableData(iLine).L      = (CableData(iLine).l / 1e3) * CableData(iLine).Xpl / (2*pi*freq);
            CableData(iLine).C      = (CableData(iLine).l / 1e3) * (CableData(iLine).Bdpl / (2*pi*freq*1e6));
            CableData(iLine).Bd     = (CableData(iLine).l / 1e3) * CableData(iLine).Bdpl;

            CableData(iLine).Z_ser=CableData(iLine).R+j*CableData(iLine).X;
            CableData(iLine).Y_shu=CableData(iLine).G+j*CableData(iLine).Bd;
       end
    end
end