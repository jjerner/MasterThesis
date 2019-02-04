
days = 1;   % number of days

P_avgYear = 25000;              % in kWh in a year
P_avg = P_avgYear / (365*24);   % avg per hour

for iBus = 1:length(Y_bus)
    for iDays = 1:days
        P_in = ones(24, iDays) .* P_avg .* (rand(24,1)+0.5);     % kWh per h during a day
    end
    
    
end