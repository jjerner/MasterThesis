% Create complex power from magnitude and power factor
%
% function S = createComplexPower(power,powerInType,powerFactor,leading)
%
% INPUTS:
% powerIn:      Input power [any matrix]
% powerInType:  Input power type [char]:
%               - 'M' for power magnitude (apparent power)
%               - 'P' for active power (real(S))
% powerFactor:  Power factor cos(phi) [1x1 or size(S_abs)]
% leading:      Make power factor leading (capacitive) instead of
%               lagging (inductive). Default: off.
%               [optional logical, 1x1 or size(S_abs)]
%
% OUTPUTS:
% S:            Complex power [size(S_abs)]

function S = createComplexPower(powerIn,powerInType,powerFactor,leading)
    if ~exist('leading','var'), leading = 0; end    % Leading mode is off by default
    j=1i;                                   % Imaginary unit
    
    switch powerInType
        case 'M'
            % Input is power magnitude (apparent power)
            M=powerIn;                                % Power magnitude
            P=M.*powerFactor;                         % Active power
            
        case 'P'
            % Input power is active power
            P=powerIn;                                % Active power
            M=P./powerFactor;                         % Power magnitude
        
        otherwise
            error('Unsupported input power type.');
    end
    
    if ~leading
        Q=M.*sin(acos(powerFactor));          % Reactive power (positive)
    elseif leading
        Q=-M*sin(acos(powerFactor));          % Reactive power (negative)
    end
    
    S=P+j.*Q;                                 % Complex power
end