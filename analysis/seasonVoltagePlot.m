function seasonVoltagePlot(resultSet,TransformerData,buses)
    monthsStart2End=[1      744;...
                     745    1416;...
                     1417   2160;...
                     2161   2880;...
                     2881   3624;...
                     3625   4344;...
                     4345   5088;...
                     5089   5832;...
                     5833   6552;...
                     6553   7296;...
                     7297   8016;...
                     8017   8760];

    seasonMonths(1,:)=[12 1 2];     % Winter
    seasonMonths(2,:)=[3 4 5];      % Spring
    seasonMonths(3,:)=[6 7 8];      % Summer
    seasonMonths(4,:)=[9 10 11];    % Fall

    for iSeason=1:4
        filledUntil=0;
        seasonTLtemp=zeros(1,sum(diff(monthsStart2End(seasonMonths(iSeason,:),:),[],2)+1));
        for iSel=seasonMonths(iSeason,:)
            intervalForMonth=filledUntil+1:filledUntil+diff(monthsStart2End(iSel,:),[],2)+1;
            seasonTLtemp(intervalForMonth)=monthsStart2End(iSel,1):monthsStart2End(iSel,2);
            filledUntil=filledUntil+diff(monthsStart2End(iSel,:),[],2)+1;
        end
        switch iSeason
            case 1
                tWinter=seasonTLtemp;
                U_max(1)=max(max(abs(resultSet.U_hist(buses,tWinter)),[],1));
                U_min(1)=min(min(abs(resultSet.U_hist(buses,tWinter)),[],1));
                U_mean(1)=mean(mean(abs(resultSet.U_hist(buses,tWinter)),1));
            case 2
                tSpring=seasonTLtemp;
                U_max(2)=max(max(abs(resultSet.U_hist(buses,tSpring)),[],1));
                U_min(2)=min(min(abs(resultSet.U_hist(buses,tSpring)),[],1));
                U_mean(2)=mean(mean(abs(resultSet.U_hist(buses,tSpring)),1));
            case 3
                tSummer=seasonTLtemp;
                U_max(3)=max(max(abs(resultSet.U_hist(buses,tSummer)),[],1));
                U_min(3)=min(min(abs(resultSet.U_hist(buses,tSummer)),[],1));
                U_mean(3)=mean(mean(abs(resultSet.U_hist(buses,tSummer)),1));
            case 4
                tFall=seasonTLtemp;
                U_max(4)=max(max(abs(resultSet.U_hist(buses,tFall)),[],1));
                U_min(4)=min(min(abs(resultSet.U_hist(buses,tFall)),[],1));
                U_mean(4)=mean(mean(abs(resultSet.U_hist(buses,tFall)),1));
        end
    end

    barMat=[U_min(1) U_mean(1) U_max(1);...
        U_min(2) U_mean(2) U_max(2);...
        U_min(3) U_mean(3) U_max(3);...
        U_min(4) U_mean(4) U_max(4)].*TransformerData.U_sec_base/sqrt(3);

    grid on;
    title('Voltage min, mean and max values');
    ylabel('Voltage (line-to-neutral) [V]');
    xlabel('Season');

    hB=bar(barMat,'BaseValue',225);
    hAx=gca;            % get a variable for the current axes handle
    str={'Winter','Spring','Summer','Fall'};
    labels = {'min' 'avg' 'max' 'min' 'avg' 'max' 'min' 'avg' 'max' 'min' 'avg' 'max'};
    hAx.XTickLabel=str; % label the ticks
    hT=[];              % placeholder for text object handles
    for i=1:length(hB)  % iterate over number of bar objects
      hT=[hT,text(hB(i).XData+hB(i).XOffset,hB(i).YData,labels(:,i), ...
              'VerticalAlignment','bottom','horizontalalign','center')];
    end
    grid on;
    title('Voltage min, average and max values');
    ylabel('Voltage (line-to-neutral) [V]');
    xlabel('Season');
    ylim([225 265]);
    %legend('Min','Avg','Max','Location','bestoutside');
    hold on
    xlim=get(gca,'xlim');
    plot(xlim,[253 253],'r')
end