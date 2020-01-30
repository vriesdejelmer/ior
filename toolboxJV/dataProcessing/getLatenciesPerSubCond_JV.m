function [latencyData conditions subConditions] = getLatenciesPerSubCond_JV( allFixations, minLatency, maxLatency, conditions, subConditions )

    if( ~exist('conditions') )
        conditions = unique(allFixations.condition)
    end

    if( ~exist('subConditions') )
        subConditions = unique(allFixations.subCondition)
    end

    for( u = 1:length(conditions) )

        for( v = 1:length(subConditions) )
                %Only trials with a minumum of two fixations have a latency!
            trialsWithTwo = allFixations.trialNumber(allFixations.fixationNumber == 2 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v));
            fixationsTrialsWithTwo = ismember(allFixations.trialNumber,trialsWithTwo);       %will give us a boolean list with all fixations from trials with two fixations

                %Now get the fixation durations for the first fixations in trials with two fixations
            latenciesForCond = allFixations.duration(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
            trialNumbersForCond = allFixations.trialNumber(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
            amplitudes = allFixations.incomingAmplitude(allFixations.fixationNumber == 2 & fixationsTrialsWithTwo);
            
            if( exist('minLatency') & exist('maxLatency') )
                latencySelection = latenciesForCond < maxLatency & latenciesForCond > minLatency;
                latenciesForCond = latenciesForCond(latencySelection);
                trialNumbersForCond = trialNumbersForCond(latencySelection);
                amplitudes = amplitudes(latencySelection);
            end

            
            latencyData(v,u).latencies = latenciesForCond;
            latencyData(v,u).median = median(latenciesForCond);
            latencyData(v,u).se = std(latenciesForCond)/sqrt(length(latenciesForCond)-1);
            latencyData(v,u).amplitudes = amplitudes;
            latencyData(v,u).medianAmplitude = median(amplitudes);
            latencyData(v,u).seAmplitude = std(amplitudes)/sqrt(length(amplitudes)-1);;
            latencyData(v,u).trialNumbers = trialNumbersForCond;
            latencyData(v,u).condition = conditions(u);
            latencyData(v,u).subCondition = subConditions(v);
        end
    end

    