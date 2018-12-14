busParents=zeros(1,nBuses);
for iBus=1:nBuses
    if iBus==1
        busParents(iBus)=0;
    else
        busParents(iBus)=connectionBuses(find(connectionBuses(:,2)==iBus),1);
    end
end
treeplot(busParents);
[treeXpos,treeYpos] = treelayout(busParents);
treeXpos = treeXpos';
treeYpos = treeYpos';
text(treeXpos(:,1),treeYpos(:,1),cellstr(num2str((1:size(busParents,2))')), 'VerticalAlignment','bottom','HorizontalAlignment','right')
title('Grid plot');
clear treeXpos treeYpos
