function [latBin tarBin distBin] = calculateBins(latencyList,selectionList,numbBins)

    constantsSacExp_JV;

    sortedList  = sortrows([latencyList selectionList]);
    if isempty(sortedList), latBin = zeros(1,numbBins); tarBin = zeros(1,numbBins); distBin = zeros(1,numbBins);
    else
        sortedLat   = sortedList(:,1);
        sortedSel   = sortedList(:,2);

        binSize = floor(length(sortedSel)/numbBins);
        for w = 1:numbBins,
            beginBin    = (w-1)*(binSize)+1;
            endBin      = w*binSize;
            tarBin(w)   = mean(sortedSel(beginBin:endBin) == TARGET)*100;
            distBin(w)  = mean(sortedSel(beginBin:endBin) == DISTRACTOR)*100;
            latBin(w)   = median(sortedLat(beginBin:endBin));
        end
    end