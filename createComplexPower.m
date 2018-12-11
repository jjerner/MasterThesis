% Create complex power from magnitude and power factor
%
% function S = createComplexPower(S_abs,cosPhi)
%
% INPUTS:
% S_abs:    Power magnitude (absolute value) [any matrix]
% cosPhi:   Power factor cos(phi) [scalar or size(S_abs)]
%
% OUTPUTS:
% S:        Complex power [size(S_abs)]

function S = createComplexPower(S_abs,cosPhi)
    j=1i;
    P=S_abs.*cosPhi;                 % Active power
    Q=S_abs.*sin(acos(cosPhi));      % Reactive power
    S=P+j.*Q;                        % Complex power
end