classdef CableObj
    properties
        Length;                         %% l [m]
        %Diameter;                       %% d [m]
        SeriesResistance;               %% R [Ohm / m]
        %ShuntConductance;               %% G [S (1/Ohm)]
        SeriesInductance;               %% L [H/m]
        %ShuntCapacitance;               %% C [F/m]
        Impedance;                      %% z = R + jwL
        %Admittance;                     %% y = G + jwC
    end
    
    properties(Dependent)
        test;
    end

    methods
        
        function obj = CableObj(l, R, L)
            if nargin == 0
                obj.Length = 1;
                obj.SeriesResistance = 1;
                obj.SeriesInductance = 1;
                disp('Default cable object created');
            elseif nargin == 3
                obj.Length = l;                         %% l [km]
                obj.SeriesResistance = R;               %% R [Ohm / km]
                obj.SeriesInductance = L;               %% L [H/km]
                
                %obj.Diameter = d;                       %% d [m]
                %obj.ShuntCapacitance = C;               %% C [F/km]
                
                disp('Custom cable object created');
            else
                error('Error in input.');
            end
        end
        
        function obj = impedanceCalc(obj, phase)
            R = obj.SeriesResistance;
            L = obj.SeriesInductance;
            j = 1i;
            w = phase;
            obj.Impedance = R + j*w*L;
        end
    end
end
