function [] = plotReciprobit_JV(latencies)

numbTrials = length(latencies);

figure;
subplot(1,4,1);
histogram(latencies,'BinLimits',[min(latencies) max(latencies)]);

subplot(1,4,2);
histogram(1./latencies);

subplot(1,4,3);
reciLat         = -1./latencies;
sortedReciLat   = sort(reciLat);
reciLatIndex    = 1:length(sortedReciLat);
sortedReciLat   = sort(reciLat);
plot(sortedReciLat,reciLatIndex/numbTrials);
labelList   = [-0.01:0.002:-0.002 -0.0001];
xLabels     = cellfun(@(x) x(2:end), arrayfun(@num2str, 1./labelList, 'unif', 0), 'unif',0)
set(gca, 'XTick', labelList ,'XTickLabel', xLabels);


subplot(1,4,4);
plot(sortedReciLat,norminv(reciLatIndex./numbTrials));
yValues     = [0.00001 0.01 0.1:0.1:0.9 0.99 0.99999];
yLabels     = arrayfun(@num2str, yValues, 'unif', 0);
set(gca,'YTick',[norminv(yValues)],'YTickLabel',yLabels);

