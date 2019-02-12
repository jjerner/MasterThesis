
function limitPlot(plotStruct, Info, TransformerData, busIsLoad)

    structName = inputname(1);
    buses = 1:Info.nBuses;
    loadNumbers = buses(busIsLoad);

    nIter = max(size(plotStruct));

    Ulim_u = 253;
    Ulim_l = 207;

    distToLimit = nan(nIter, size(plotStruct(1).Results.U_hist,2));
    pvProd = nan(nIter,1);
    numSystems = nan(nIter, 1);
    for iProd = 1:nIter

        Ui = plotStruct(iProd).Results.U_hist;

        distToLimit(iProd, :) = sort(min(min((Ulim_u - abs(Ui.*TransformerData.U_sec_base./sqrt(3))), (abs(Ui.*TransformerData.U_sec_base./sqrt(3)) - Ulim_l)),[],1));
        pvProd(iProd) = max(plotStruct(iProd).PvPowerPerLoad).*TransformerData.S_base/1000;
        numSystems(iProd) = plotStruct(iProd).PvSystemsAdded;
    end
    N = size(distToLimit,2);
    q00 = 1;
    q10 = ceil(N*0.1);
    q20 = ceil(N*0.2);
    q50 = round(N*0.5);
    q90 = floor(N*0.9);
    q100 = N;
    labels = ({'min dist';'10 %';'20 %';'50 %';'90 %';'max dist'});
    figure('Position', [200 200 600 350]);
    
    if strcmp(structName, 'SelectDist')
        plot(numSystems, distToLimit(:,q00), 'r--', 'linewidth',2);hold on;
        plot(numSystems, distToLimit(:,q10), 'b--', 'linewidth',2);hold on;
        plot(numSystems, distToLimit(:,q20), 'k--', 'linewidth',2);hold on;
        plot(numSystems, distToLimit(:,q50), 'g', 'linewidth',2);hold on;
        plot(numSystems, distToLimit(:,q90), 'b', 'linewidth',2);hold on;
        %plot(numSystems, distToLimit(:,q100), 'r', 'linewidth',2);hold on;
        xlim([min(numSystems), max(numSystems)])
        ylim([0, max(max(distToLimit)).*1.1])
        xlabel('Number of PV-systems')
    else
        plot(pvProd, distToLimit(:,q00), 'r--', 'linewidth',2);hold on;
        plot(pvProd, distToLimit(:,q10), 'b--', 'linewidth',2);hold on;
        plot(pvProd, distToLimit(:,q20), 'k--', 'linewidth',2);hold on;
        plot(pvProd, distToLimit(:,q50), 'g', 'linewidth',2);hold on;
        plot(pvProd, distToLimit(:,q90), 'b', 'linewidth',2);hold on;
        %plot(pvProd, distToLimit(:,q100), 'r', 'linewidth',2);hold on;
        xlim([min(pvProd), max(pvProd)])
        ylim([0, max(max(distToLimit)).*1.1])
        xlabel('Maximal PV-production in the system [kW]')
    end
    title(['Distance to voltage limit of ', structName])
    ylabel('Distance to voltage limit [V]')
    legend(labels,'Location','bestoutside')
    grid on


end