
days = 1;   % number of days

P_avgYear = 25000;              % in kWh in a year
P_avg = P_avgYear / (365*24);   % avg per hour

P_in = ones(24,days) .* P_avg;     % kWh per h during a day

