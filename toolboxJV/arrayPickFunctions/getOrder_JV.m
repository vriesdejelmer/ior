function order = getOrder_JV(baseOrder, previousOrder,nonAdjacentElements)

    constantsSacExp;

    reorder = 1;    
    
        %Tot er een nieuwe order is gevonden, ga door
    while( reorder )
        reorder = 0;
        
        order = shuffle(baseOrder);                             %Doe een voorstel
        hotspots = ismember(order,nonAdjacentElements);         %Markeer de elementen die elkaar niet mogen raken
        
            %Als er een vorige volgorde moeten we checken of er elementen op dezelfde plek staan
        if( ~isempty(previousOrder) )                           
            
            hotspotsOld = ismember(previousOrder,nonAdjacentElements); %Markeer de elementen in de vorige order
            
                %Neem de conjunctie van de oude en de nieuwe hotspots en check of deze niet meer dan 1 is
            if sum(hotspots & hotspotsOld) > 0
                reorder = 1;
            end
        end

            %Check nu plek voor plek of twee opvolgende plekken aanliggende hotspot bevatten
        for v=2:length(hotspots)
            if hotspots(v) & hotspots(v-1) 
                reorder = 1;
            end
        end
            
            %En tot of de eerste en de laatste elementen hotspots zijn
        if hotspots(1) == 1 & hotspots(end) == 1
            reorder = 1;
        end
    end

