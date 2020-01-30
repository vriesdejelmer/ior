function [amplitudeData conditions subConditions] = getAmplitudesPerSubCond_JV( allFixations, conditions )

    if( ~exist('conditions') )
        conditions = unique(allFixations.condition);
    end

    subConditions = unique(allFixations.subCondition);

    for( u = 1:length(conditions) )

        for( v = 1:length(subConditions) )
                %get the amplitdes for the first saccade
            amplitudes = allFixations.incomingAmplitude(allFixations.fixationNumber == 2 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v));
            amplitudeData(v,u).amplitudes = amplitudes;
        end
    end

    