function [] = plotMultiHisto_JV(data,binWidth)

figure;

heightFactor = 1.25;
leftOffset = -50;
rightOffset = 150;

[beginBin endBin] = calculateBinCentersEtc(data,binWidth,leftOffset,rightOffset)

for(u = 1:length(data))
    [binSize binPosition] = hist(data(u).latencies,beginBin:binWidth:endBin);
    subplot(length(data),1,u);
    bar(binPosition, binSize);
    hold on;
    plot([median(data(u).latencies) median(data(u).latencies)],[0 ceil(max(binSize)*heightFactor)],'r-.');
    axis([(beginBin-round(binWidth/2)) (endBin+round(binWidth/2)) 0 ceil(max(binSize)*heightFactor)]);
    if( u == round(length(data)/2))
        ylabel('Frequency','FontSize',18)
    end
end

xlabel('Latency (ms)','FontSize',18);


function [beginBin endBin] = calculateBinCentersEtc(data,binWidth,leftOffset,rightOffset)

    allData = [];
    for( u = 1:length(data) )
        allData = [allData ; data(u).latencies];
    end
    
    minLatency = min(allData);
    maxLatency = max(allData);
    beginBin = ceil(minLatency/binWidth) * binWidth;
    beginBin = beginBin + leftOffset;
    endBin = floor(maxLatency/binWidth) * binWidth;
    endBin = endBin + rightOffset;