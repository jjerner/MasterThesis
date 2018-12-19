
LPfolder = 'European_LV_CSV/Load Profiles';

for indexLoad = 1:height(Loads)
    loadShape = Loads.Yearly(indexLoad);
    
    filename = ['Load_Profile_', num2str(loadShape), '.csv'];
    LPimport = ELVLoadImport(filename);     % read data from filename --> output in kW

    Input(indexLoad).name = Loads.Yearly(indexLoad);
    Input(indexLoad).values = LPimport;
end