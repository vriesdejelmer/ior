function [latencyLists, targetPropList, distPropList] = makeBins(latencies, selectedEls,element1,element2,numbBins)

constantsSacExp_JV;

    %sort based on latencies
sortedLatElList     = sortrows([latencies selectedEls]);
sortedLatencies     = sortedLatElList(:,1);
sortedSelectedEl    = sortedLatElList(:,2);

    %now calculate binned proportions
binSize = floor(length(sortedLatencies)/numbBins);
for( r = 1:numbBins )
    beginIndex  = 1+(r-1)*binSize;
    endIndex    = r*binSize;

        %calculate bin properties
    latencyLists(r)     = median(sortedLatencies(beginIndex:endIndex));
    targetPropList(r)   = sum(sortedSelectedEl(beginIndex:endIndex) == element1)/binSize;
    distPropList(r)     = sum(sortedSelectedEl(beginIndex:endIndex) == element2)/binSize;

end


   %now calculate binned proportions
binSizeInd = floor(length(sortedLatencies)/numbBins);
for( r = 1:numbBins )
    beginIndex  = 1+(r-1)*binSizeInd;
    endIndex    = r*binSizeInd;

        %calculate bin properties
    latencyListsInd(r)     = median(sortedLatencies(beginIndex:endIndex));
    targetPropListInd(r)   = sum(sortedSelectedEl(beginIndex:endIndex) == element1)/binSizeInd;
    distPropListInd(r)     = sum(sortedSelectedEl(beginIndex:endIndex) == element2)/binSizeInd;

end
