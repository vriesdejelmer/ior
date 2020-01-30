function [handle1 handle2] = plotReciprobitCorrectInCorrect_JV(latencies,selectionList,correctSelection,incorrectSelection,minLat,maxLat,titleString)

numbTrials = length(latencies);

sortedRows      = sortrows([latencies selectionList]);
sortedLatencies = sortedRows(:,1);
sortedSelection = sortedRows(:,2);
sortedReciLat   = -1./sortedLatencies;
reciLatIndex    = 1:length(sortedReciLat);

correctList     = sortedSelection == correctSelection;
incorrectList   = sortedSelection == incorrectSelection;

handle1 = plot(sortedReciLat(correctList),norminv(reciLatIndex(correctList)./numbTrials),'go'); %,'color',[0.2 0.2 0.2]);
hold on;
handle2 = plot(sortedReciLat(incorrectList),norminv(reciLatIndex(incorrectList)./numbTrials),'ro'); %,'color',[0.7 0.7 0.7]);

xValues         = [75 100 200 500];
xLabels         = arrayfun(@num2str, xValues, 'unif', 0);
set(gca,'XTick',-1./xValues,'XTickLabel',xLabels);

yValues     = [0.0001 0.01 0.2 0.5 0.8 0.99 0.9999];
yLabels     = arrayfun(@num2str, yValues, 'unif', 0);
set(gca,'YTick',[norminv(yValues)],'YTickLabel',yLabels);
axis([-1./minLat -1./maxLat norminv(0.0001) norminv(0.9999)]);