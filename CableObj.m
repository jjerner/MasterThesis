classdef CableObj
    properties
        Length;                         %% l [m]
        Diameter;                       %% d [m]
        SeriesResistance;               %% R [Ohm / m]
        ShuntConductance;               %% G [S (1/Ohm)]
        SeriesInductance;               %% L [H/m]
        ShuntCapacitance;               %% C [F/m]
        Impedance;                      %% z = R + jwL
        Admittance;                     %% y = G + jwC
    end
    
    properties(Dependent)
        test;
    end

    methods
        
        function obj = CableObj(l, d, R, G, L, C)
            if nargin < 6
                error('Missing input parameter');
            elseif nargin > 6
                error('Too many input parameters');
            else
                obj.Length = l;                         %% l [m]
                obj.Diameter = d;                       %% d [m]
                obj.SeriesResistance = R;               %% R [Ohm / m]
                obj.ShuntConductance = G;               %% G [S (1/Ohm)]
                obj.SeriesInductance = L;               %% L [H/m]
                obj.ShuntCapacitance = C;               %% C [F/m]
            end
        end
        
        function obj = impedanceCalc(obj, phase)
            R = obj.SeriesResistance;
            L = obj.SeriesInductance;
            j = 1i;
            w = phase;
            obj.Impedance = R + j*w*L;
        end
        
        function obj = adittanceCalc(obj, phase)
            
        end
    end
end
