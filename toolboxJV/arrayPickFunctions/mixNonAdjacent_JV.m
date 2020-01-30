function order = mixNonAdjacent_JV(elements, previousOrder, targets)

    constantsSacExp_JV;

    reorder = 1;    
    while( reorder )
        reorder = 0;
        order = shuffle(elements);
        hotspots = ismember(order,targets);
        
        if( ~isempty(previousOrder) )
            hotspotsOld = ismember(previousOrder,targets);

            if sum(hotspots & hotspotsOld) > 0
                reorder = 1;
            end
        end

        for v=2:length(hotspots)
            if hotspots(v) & hotspots(v-1) 
                reorder = 1;
            end
        end
        
        if hotspots(1) == 1 & hotspots(end) == 1
            reorder = 1;
        end
    end