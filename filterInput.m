% Moving-Average Filter
if ~exist('S_ana','var'), S_ana = S_bus; end
windowSize = input('Set window size for moving average filter: ');
b = (1/windowSize)*ones(1,windowSize);
a = 1;
meanBefore=mean(mean(S_ana,2));
S_ana = filter(b,a,S_ana,[],2);
meanAfter=mean(mean(S_ana,2));
match=meanBefore/meanAfter;
fprintf('Input data filtered with window size %d. Mean value match: %g.\n',windowSize,match);
% plot(timeLine,abs(S_ana(timeLine)))
% figure
% plot(timeLine,abs(S_bus(timeLine)))
clear meanPrev meanAfter windowSize b a match
