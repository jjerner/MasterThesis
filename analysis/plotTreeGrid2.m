busNumbers=1:Info.nBuses;
loadBusNumbers=busNumbers(busIsLoad);
s=connectionBuses(:,1)';
t=connectionBuses(:,2)';
G=graph(s,t);
%h=plot(G,'Layout','layered','Sources',1,'Sinks',loadBusNumbers);
h=plot(G,'Layout','layered','Sources',1);
h.NodeColor = 'blue';
h.EdgeColor = 'black';
h.LineWidth = 1.5;
labelnode(h,busNumbers,cellstr(string(busNumbers)));
highlight(h,loadBusNumbers,'NodeColor','red');
title(['Grid plot of ' Settings.location]);
axis off;
%clear h s t G