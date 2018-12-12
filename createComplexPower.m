% Create complex power from magnitude and power factor
%
% function S = createComplexPower(S_abs,powerFactor,leading)
%
% INPUTS:
% S_abs:        Power magnitude (absolute value) [any matrix]
% powerFactor:  Power factor cos(phi) [1x1 or size(S_abs)]
% leading:      Make power factor leading (capacitive) instead of
%               lagging (inductive). Default: off.
%               [optional logical, 1x1 or size(S_abs)]
%
% OUTPUTS:
% S:            Complex power [size(S_abs)]

function S = createComplexPower(S_abs,powerFactor,leading)
    if ~exist('leading','var'), leading = 0; end    % Leading mode is off by default
    j=1i;                                   % Imaginary unit
    S_abs=abs(S_abs);                       % Make sure S_abs is magnitude
    P=S_abs.*powerFactor;                   % Active power
    if ~leading
        Q=S_abs.*sin(acos(powerFactor));    % Reactive power (positive)
    elseif leading
        Q=-S_abs.*sin(acos(powerFactor));   % Reactive power (negative)
    end
    S=P+j.*Q;                               % Complex power
end