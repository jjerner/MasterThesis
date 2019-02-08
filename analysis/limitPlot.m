
function limitPlot(plotStruct, Info, TransformerData, busIsLoad)

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
        pvProd(iProd) = max(plotStruct(iProd).PvPowerPerLoad) .* plotStruct(iProd).PvSystemsAdded .*TransformerData.S_base/1000;
        numSystems(iProd) = plotStruct(iProd).PvSystemsAdded;
    end
    N = size(distToLimit,2);
    q00 = 1;
    q10 = ceil(N*0.1);
    q20 = ceil(N*0.2);
    q50 = round(N*0.5);
    q80 = floor(N*0.8);
    q100 = N;
    figure('Position', [200 200 500 300]);
    plot(numSystems, distToLimit(:,q00), 'k', 'linewidth',2);hold on;
    plot(numSystems, distToLimit(:,q10), 'r--', 'linewidth',2);hold on;
    plot(numSystems, distToLimit(:,q20), 'k', 'linewidth',2);hold on;
    plot(numSystems, distToLimit(:,q50), 'b', 'linewidth',2);hold on;
    plot(numSystems, distToLimit(:,q80), 'k', 'linewidth',2);hold on;
    plot(numSystems, distToLimit(:,q100), 'k', 'linewidth',2);hold on;
    xlim([min(numSystems), max(numSystems)])
    grid on


end