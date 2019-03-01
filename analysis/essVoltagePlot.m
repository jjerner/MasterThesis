function essVoltagePlot(resultSet_noess,resultSet_67ess,resultSet_1ess,TransformerData,buses)
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

    seasonMonths=[6 7 8];      % Summer

    filledUntil=0;
    tSummer=zeros(1,sum(diff(monthsStart2End(seasonMonths,:),[],2)+1));
    for iSel=seasonMonths
        intervalForMonth=filledUntil+1:filledUntil+diff(monthsStart2End(iSel,:),[],2)+1;
        tSummer(intervalForMonth)=monthsStart2End(iSel,1):monthsStart2End(iSel,2);
        filledUntil=filledUntil+diff(monthsStart2End(iSel,:),[],2)+1;
    end

    U_max(1)=max(max(abs(resultSet_noess.U_hist(buses,tSummer)),[],1));
    U_min(1)=min(min(abs(resultSet_noess.U_hist(buses,tSummer)),[],1));
    U_mean(1)=mean(mean(abs(resultSet_noess.U_hist(buses,tSummer)),1));
    U_max(2)=max(max(abs(resultSet_67ess.U_hist(buses,tSummer)),[],1));
    U_min(2)=min(min(abs(resultSet_67ess.U_hist(buses,tSummer)),[],1));
    U_mean(2)=mean(mean(abs(resultSet_67ess.U_hist(buses,tSummer)),1));
    U_max(3)=max(max(abs(resultSet_1ess.U_hist(buses,tSummer)),[],1));
    U_min(3)=min(min(abs(resultSet_1ess.U_hist(buses,tSummer)),[],1));
    U_mean(3)=mean(mean(abs(resultSet_1ess.U_hist(buses,tSummer)),1));

    barMat=[U_min(1) U_mean(1) U_max(1);...
        U_min(2) U_mean(2) U_max(2);...
        U_min(3) U_mean(3) U_max(3)].*TransformerData.U_sec_base/sqrt(3);

    hB=figure;
    hB=bar(barMat,'BaseValue',220);
    hAx=gca;            % get a variable for the current axes handle
    str={'No ESS','67 small ESS:s','One large ESS',};
    labels = {'min' 'avg' 'max' 'min' 'avg' 'max' 'min' 'avg' 'max'};
    hAx.XTickLabel=str; % label the ticks
    hT=[];              % placeholder for text object handles
    for iText=1:length(hB)  % iterate over number of bar objects
      hT=[hT,text(hB(iText).XData+hB(iText).XOffset,hB(iText).YData,labels(:,iText), ...
              'VerticalAlignment','bottom','horizontalalign','center')];
    end
    hAx.YMinorGrid = 'on';
    title('Voltages with different ESS solutions (summer only)');
    ylabel('Voltage (line-to-neutral) [V]');
    xlabel('Energy storage solution');
    ylim([220 255]);
    %legend('Min','Avg','Max','Location','bestoutside');
    hold on
    xlim=get(gca,'xlim');
    plot(xlim,[253 253],'r')
end