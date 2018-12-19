function P_pv = PV_model(location, orientation, tilt, year)
% PV_model function version of thesis work of some german guy
%
% location:
% 1 - Norrkoeping
% 2 - Kiruna
% 3 - Visby
% 4 - Munich
% 
% orientation:
% 1 - East
% 2 - Southeast
% 3 - South
% 4 - Southwest
% 5 - West
% 
% tilt:
% 1 - flat_22degree
% 2 - medium_44degree
% 3 - steep_60degree
% 
% year:
% 1 - Y2013
% 2 - Y2014
% 3 - Y2015
% 4 - Y2016


%clear all
userInput = 0;
if(userInput == 1)
    %% Location
    PV.Location = struct('Norrkoeping',58.58, 'Kiruna',67.83, 'Visby',57.67, 'Munich',48.15);
    dataLoc = fieldnames(PV.Location);
    disp('Location:')
    for kkk = 1:length(dataLoc)
        disp([num2str(kkk) ' - '  dataLoc{kkk}])
    end
    Loc2run = floor(input('Select case to run: '));

    PV.latitude = PV.Location.(dataLoc{Loc2run});
    radiation = 'RadiationTemperatureData';
    [aaee,daaate] = xlsread(radiation,num2str(Loc2run));
    %% PV orientation
    PV.Orientation = struct('East',90,'Southeast',135,'South',180,'Southwest',225,'West',270);
    dataNames = fieldnames(PV.Orientation);
    disp('Available data sets:')
    for kki=1:length(dataNames)
        disp([num2str(kki) ' - '   dataNames{kki}])
    end

    Orient2run = floor(input('Select case to run: '));
    azimuth_pv = PV.Orientation.(dataNames{Orient2run});

    %% PV tilt
    PV.Tilt = struct('flat_22degree',33,'medium_44degree',30,'steep_60degree',35);
    dataPV = fieldnames(PV.Tilt);
    disp('PV installation:')
    for kkii=1:length(dataPV)
        disp([num2str(kkii) ' - '   dataPV{kkii}])
    end
    Tilt2run = floor(input('Select case to run: '));

    tilt = PV.Tilt.(dataPV{Tilt2run});

    %% Year (2013,2014,2015,2016)
    Year = struct('Y2013',365,'Y2014',365,'Y2015',365,'Y2016',366);
    dataYear = fieldnames(Year);
    disp('Year:')
    for kkjj = 1:length(dataYear)
        disp([num2str(kkjj) ' - ' dataYear{kkjj}])
    end
    year2run = floor(input('Select year to run: '));
    days = Year.(dataYear{year2run});
    Yearq = [2013; 2014;2015;2016];
    yearr = Yearq(year2run);

    %{
    %% Module
    Module = struct('FirstSolar65W',1,'PWX50049W',2);
    dataModule = fieldnames(Module);
    disp('Module')
    for kkmodu = 1:length(dataModule)
        disp([num2str(kkmodu) ' - ' dataYear{kkmodu}])
    end
    module2run = floor(input('Select year to run: '));
    if module2run == 1
    PVmodulcharacteristicsFirstSolar
    else PVmodulcharacteristicsPWX
    end
    %}
    else
    PV.Location = struct('Norrkoeping',58.58, 'Kiruna',67.83, 'Visby',57.67, 'Munich',48.15);
    dataLoc = fieldnames(PV.Location);
    Loc2run = location;
    PV.latitude = PV.Location.(dataLoc{Loc2run});
    radiation = 'RadiationTemperatureData';
    [aaee,daaate] = xlsread(radiation,num2str(Loc2run));
    
    PV.Orientation = struct('East',90,'Southeast',135,'South',180,'Southwest',225,'West',270);
    dataNames = fieldnames(PV.Orientation);
    Orient2run = orientation;
    azimuth_pv = PV.Orientation.(dataNames{Orient2run});
    
    PV.Tilt = struct('flat_22degree',33,'medium_44degree',30,'steep_60degree',35);
    dataPV = fieldnames(PV.Tilt);
    Tilt2run = tilt;
    tilt = PV.Tilt.(dataPV{Tilt2run});
    
    Year = struct('Y2013',365,'Y2014',365,'Y2015',365,'Y2016',366);
    dataYear = fieldnames(Year);
    year2run = year;
    days = Year.(dataYear{year2run});
    Yearq = [2013; 2014;2015;2016];
    yearr = Yearq(year2run);
    
end
%% Calculation incidence angle
azimuth_pvRad = azimuth_pv *(2*pi/360);
dayNbr = 1:1:days;
hourNbr = 1:1:24;
PV.tilt_rad = tilt * (2*pi/360);
PV.latitudeRad = PV.latitude*2*pi/360;  
Q= [1;1;1;1;1;1;1;1;1;1;1;1;0;0;0;0;0;0;0;0;0;0;0;0];
Y= [0;0;0;0;0;0;0;0;0;0;0;0;1;1;1;1;1;1;1;1;1;1;1;1];

%% PV modul characteristics
 PVmodulcharacteristicsPWX;


for ii = 1:dayNbr
for jj = 1:hourNbr
declination = 23.45*sin((dayNbr-81)*360/365*2*pi/360)*2*pi/360;
declinationDeg = declination*180/pi;

timeAngle = (hourNbr*15-180)*2*pi/360;

sunelevation = asin((sin(PV.latitudeRad).*sin(declination))+(cos(declination).*cos(PV.latitudeRad)).*(cos(timeAngle))');
sunelevationDeg = sunelevation*180/pi;
azimuth_sun1 =Q.* (real(pi - acos((sin(sunelevation)*sin(PV.latitudeRad)-sin(declination))./(cos(sunelevation)*cos(PV.latitudeRad))))) ;
azimuth_sun2 =Y.* (real(pi + acos((sin(sunelevation)*sin(PV.latitudeRad)-sin(declination))./(cos(sunelevation)*cos(PV.latitudeRad)))));
azimuth_sun = azimuth_sun1+azimuth_sun2;


azimuth_sunDeg = azimuth_sun*180/pi;
incidenceangle = acos(sin(sunelevation)*cos(PV.tilt_rad)+cos(sunelevation).*sin(PV.tilt_rad).*cos(azimuth_sun-azimuth_pvRad));
incidenceangle_Rad = incidenceangle*(360/(2*pi));

end
end

%% Calculating radiation on PV model

%I_global = aaee(:,2);
I_global1   = aaee(1:days*24,-5+7*(year2run));
I_global    = reshape(I_global1,24,(days));
I_diffuse1  = aaee(1:days*24,-3+7*(year2run));
I_diffuse   = reshape(I_diffuse1,24,(days));
I_direct1   = aaee(1:days*24,-4+7*(year2run));
%I_direct1 = I_global1-I_diffuse1;
I_direct    = reshape(I_direct1,24,(days)); 

Ta          = aaee(1:days*24,-2+7*(year2run));

%{
if case2run == 1 && days ==366
    I_global = xlsread(radiation,1,'C3:C8786');
    I_global = reshape(I_global1,24,366);
    I_direct1 = xlsread(radiation,1,'D3:D8786');
    I_direct = reshape(I_direct1,24,366);
    I_diffuse1 = xlsread(rradiationadi,1,'E3:E8786');
    I_diffuse = reshape(I_diffuse1,24,366);
    
elseif case2run == 1 && days ==365
    I_global = xlsread(radiation,1,'C3:C8783');
    I_global = reshape(I_global1,24,365);
    I_direct1 = xlsread(radiation,1,'D3:D8783');
    I_direct = reshape(I_direct1,24,365);
    I_diffuse1 = xlsread(rradiationadi,1,'E3:E8783');
    I_diffuse = reshape(I_diffuse1,24,365);
    
elseif case2run == 2 && days ==366
    I_global = xlsread(radiation,1,'C3:C8786');
    I_global = reshape(I_global1,24,365);
    I_direct1 = xlsread(radiation,1,'D3:D8786');
    I_direct = reshape(I_direct1,24,365);
    I_diffuse1 = xlsread(rradiationadi,1,'E3:E8786');
    I_diffuse = reshape(I_diffuse1,24,365);
    
end
%}

time = 0:1:(length(I_global1)-1);

c_ref = 0.2;   % reflection coefficient

%{
%Global Horizontal (GHI) = Direct Normal (DNI) x cos(sunelevation) +
Diffuse  Horizontal (DHI)
I_direct = (I_global - I_diffuse)./sin(sunelevation);
I_direct(I_direct<0) = 0;
I_direct1 = reshape(I_direct,8784,1);
%I_diffuse = I_global-I_direct.*sin(sunelevation);
%}


if Loc2run == 4
I_directModule = I_direct.*(cos(incidenceangle)./sin(sunelevation));
I_directModule1 = reshape(I_directModule,[8784,1]);
I_directModule(I_directModule<0) = 0;
I_directModule(I_directModule>1200) = 0;
I_directModule2= reshape(I_directModule,[8784,1]);
I_modul = I_directModule+ I_diffuse*((1+cos(PV.tilt_rad))/2)+ I_global*c_ref*((1-cos(PV.tilt_rad))/2);
%I_modul = I_direct.*cos(incidenceangle)+ I_diffuse*((1+cos(PV.tilt_rad))/2)+I_global*c_ref*((1-cos(PV.tilt_rad))/2); 
%%Using direct normal radiation:
else I_directsurface = I_direct.*(cos(incidenceangle));
    I_directsurface(I_directsurface<0) = 0;
    I_directModule(I_directsurface>1200) = 0;
    I_modul = I_directsurface + I_diffuse*((1+cos(PV.tilt_rad))/2)+I_global*c_ref*((1-cos(PV.tilt_rad))/2);
end
I_modul1 = I_modul;
G = I_modul1 (:);
%G = abs(G);

%% Calculating PV-Current and Power
T = (Ta + (G/800)*(PVchara.NOCT-20))+273;                                   %cell temperature

PVchara.Vtn = PVchara.Ns*(PVchara.K*PVchara.Tn/PVchara.q);

PVchara.Ion = PVchara.Iscn*(exp(-PVchara.Vocn/(PVchara.a*PVchara.Vtn)));

PVchara.Io = PVchara.Ion'.*(((T/PVchara.Tn).^3).*(exp((PVchara.q*PVchara.Eg/(PVchara.a*PVchara.K))*((1/PVchara.Tn)-(1./T)))));

PVchara.Ipvn = PVchara.Iscn;

PVchara.Iph = (PVchara.Ipvn + PVchara.Ki*(T-PVchara.Tn)).*(G/PVchara.Gn);

PVchara.Vt = PVchara.Ns*(PVchara.K*T/PVchara.q);

PVchara.VocVec = 0:0.1:PVchara.Vocn;
I = zeros(length(G),length(PVchara.VocVec));

for j= 1:length(PVchara.VocVec)
     I(:,j+1) = (PVchara.Iph - PVchara.Io.*(exp(((PVchara.VocVec(j))+(I(:,j)*PVchara.Rs))./(PVchara.Vt*PVchara.a))-1) - ((PVchara.VocVec(j)+(PVchara.Rs*I(:,j)))/PVchara.Rp)).*(G./G);
end

I=I(:,2:end);
I(isnan(I))=0;

P=PVchara.VocVec.*I;
Pmax=max(P,[],2);                         %max.Power per modul
P_simulation =Pmax*PVchara.NbrModul;      %max.Power per installation
P_simulationYearly = sum(P_simulation);
P_simulationmax = max(P_simulation);
P_simulation2 = P_simulation/1000;

disp(' ')
disp(['Location: ', dataLoc{Loc2run}, ' - Year: ', num2str(yearr)])
disp('---------------------------------')
disp(['Yearly power: ', num2str(P_simulationYearly/1e6), ' MW'])
disp(['Max power during 1h: ', num2str(P_simulationmax), ' W'])
disp('*********************************')

P_pv = P_simulation;

%% Plots
%{
%plot(VocVec,I);
Pnonneg = P;
%Pnonneg(Pnonneg<0) = 0;

figure
subplot(2,1,1)
plot(VocVec, Pnonneg);
ylabel('Power');
xlabel('Voltage');
subplot(2,1,2)
plot(VocVec,I);
ylabel('Current');
xlabel('Voltage');
%}
%{
StartDate = [{'2013-01-01'};{'2014-01-01'};{'2015-01-01'};{'2016-01-01'}];
StartingDate = StartDate(year2run);
date=datetime(StartingDate)+hours(time);
h = figure(1)
plot(date,P_simulation2);
title('Norrköping')
ylabel('Electricity Generation [kW]')
ylim([0 11]);
xlabel('Time');
xlim(datetime(yearr,[1 12],[1 31]));
set(gca,'fontsize',28)

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'RefMunich','-dpdf','-r0')
%}

end