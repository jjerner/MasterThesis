%% Parameters

%if(l�ser fr�n exempelvis excel)
    % do things
    
%else
    % g�r exempelkabel

l       = 1;        % [km]      l�ngd i km
I_max   = 375;      % [A]       maximal belastningsstr�m

r       = 0.125;    % [Ohm/km]  resistans per km
r0      = 0.125;    % [Ohm/km]  nollf�ljdsresistans

x       = 0.069;    % [Ohm/km]  reaktans per km
x0      = 0.324;    % [Ohm/km]  nollf�ljdsreaktans

Cables = struct('length', l,...
                'I_max', I_max,...
                'r', r,....
                'r0', r0,...
                'x', x,...
                'x0', x0);
            
clear l I_max r r0 x x0