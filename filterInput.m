% Moving-Average Filter
windowSize = 5;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
S_ana = filter(b,a,S_bus,[],2);
plot(timeLine,abs(S_ana(timeLine)))
figure
plot(timeLine,abs(S_bus(timeLine)))
mean(mean(S_ana,2))
mean(mean(S_bus,2))