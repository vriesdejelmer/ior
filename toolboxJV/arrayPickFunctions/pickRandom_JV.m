function [elements elementList] = pickRandom_JV(elementList)

            %Random een type kiezen   
    [rows columns] = size(elementList);
    randIndex = ceil( rand(1) * columns );
    elements = elementList(:,randIndex);

        %Gekozen element uit array halen, kan vast mooier
    elementList(:,randIndex) = [];
