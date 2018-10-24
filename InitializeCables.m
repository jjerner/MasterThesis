%% Parameters

%if(läser från exempelvis excel)
    % do things
    
%else
    % gör exempelkabel

l       = 1;        % [km]      längd i km
I_max   = 375;      % [A]       maximal belastningsström

r       = 0.125;    % [Ohm/km]  resistans per km
r0      = 0.125;    % [Ohm/km]  nollföljdsresistans

x       = 0.069;    % [Ohm/km]  reaktans per km
x0      = 0.324;    % [Ohm/km]  nollföljdsreaktans

Cables = struct('length', l,...
                'I_max', I_max,...
                'r', r,....
                'r0', r0,...
                'x', x,...
                'x0', x0);
            
clear l I_max r r0 x x0