function [ binProps binLat elList sortedElements sortedLatencies] = getPropLatBins_jv( latencies, selectedEl, numbBins )
    
    constantsSacExp_JV;

        %sort latencies and selected elements on the basis of latencies
    latSelList = [latencies' selectedEl'];
    sortedLatSelList = sortrows(latSelList);
    sortedLatencies = sortedLatSelList(:,1);
    sortedElements = sortedLatSelList(:,2);
    
        %get all selected elements
    elList = unique(sortedElements);
    if( length(elList) == 1 )
        if( elList == DISTRACTOR )
            elList = [elList TARGET];
        else
            elList = [elList DISTRACTOR];
        end
    end
    
    binSize = floor(length(sortedElements)/numbBins);
    for( u = 1:numbBins )
        binLat(u) = mean(sortedLatencies((u-1)*binSize+1:u*binSize));
        for( v = 1:length(elList) )
            binProps(u,v) = sum(sortedElements((u-1)*binSize+1:u*binSize) == elList(v))/binSize;
        end
    end
end
