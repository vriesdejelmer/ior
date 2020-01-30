function [latencyLists, targetPropList, distPropList, targetPropListExcl, distPropListExcl] = makeBins(latencies, selectedEls,element1,element2,numbBins)

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

    targetPropListExcl(r)   = sum(sortedSelectedEl(beginIndex:endIndex) == element1)/sum(sortedSelectedEl(beginIndex:endIndex) == element1 | sortedSelectedEl(beginIndex:endIndex) == element2);
    distPropListExcl(r)     = sum(sortedSelectedEl(beginIndex:endIndex) == element2)/sum(sortedSelectedEl(beginIndex:endIndex) == element1 | sortedSelectedEl(beginIndex:endIndex) == element2);

end

