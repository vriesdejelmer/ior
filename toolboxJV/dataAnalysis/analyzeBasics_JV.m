function [latencyData conditions subConditions] = analyzeBasics_JV( allFixations, criterea, conditions, subConditions )

    if( ~exist('conditions') )
        conditions = unique(allFixations.condition)
    end

%     if( ~exist('subConditions') )
%         subConditions = unique(allFixations.subCondition)
%     end

    for( u = 1:length(conditions) )

            %Only trials with a minumum of two fixations have a latency!
        trialsWithTwo = allFixations.trialNumber(allFixations.fixationNumber == 2 & allFixations.condition == conditions(u));
        fixationsTrialsWithTwo = ismember(allFixations.trialNumber,trialsWithTwo);       %will give us a boolean list with all fixations from trials with two fixations

            %Now get the fixation durations for the first fixations in trials with two fixations
        latenciesForCond = allFixations.duration(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
        trialNumbersForCond = allFixations.trialNumber(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
        amplitudes = allFixations.incomingAmplitude(allFixations.fixationNumber == 2 & fixationsTrialsWithTwo);
        fixatedElements = allFixations.fixatedElements(allFixations.fixationNumber == 2 & fixationsTrialsWithTwo);
        distanceElements = allFixations.distanceElements(allFixations.fixationNumber == 2 & fixationsTrialsWithTwo);

        if( isfield(criterea,'minLatency') & isfield(criterea,'maxLatency') )
            latencySelection = latenciesForCond < criterea.maxLatency & latenciesForCond > criterea.minLatency;
            latenciesForCond = latenciesForCond(latencySelection);
            trialNumbersForCond = trialNumbersForCond(latencySelection);
            amplitudes = amplitudes(latencySelection);
            fixatedElements = fixatedElements(latencySelection);
            distanceElements = distanceElements(latencySelection);
        end

        if( isfield(criterea,'maxDistance') )
            distanceSelection = distanceElements < criterea.maxDistance
            latenciesForCond = latenciesForCond(distanceSelection);
            trialNumbersForCond = trialNumbersForCond(distanceSelection);
            amplitudes = amplitudes(distanceSelection);
            fixatedElements = fixatedElements(distanceSelection);
            distanceElements = distanceElements(distanceSelection);

        end

        latencyData(u).latencies = latenciesForCond;
        latencyData(u).median = median(latenciesForCond);
        latencyData(u).se = std(latenciesForCond)/sqrt(length(latenciesForCond)-1);
        latencyData(u).amplitudes = amplitudes;
        latencyData(u).fixatedElements = fixatedElements;
        latencyData(u).distanceElements = distanceElements;


        latencyData(u).medianAmplitude = median(amplitudes);
        latencyData(u).seAmplitude = std(amplitudes)/sqrt(length(amplitudes)-1);
        latencyData(u).trialNumbers = trialNumbersForCond;
        latencyData(u).condition = conditions(u);
    end    