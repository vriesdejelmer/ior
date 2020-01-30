function [latencyData conditions] = getLatenciesPerCond_JV( allFixations, conditions )
    
    if( ~exist('conditions') )
        conditions = unique(allFixations.condition);
    end

    for( u = 1:length(conditions) )

            %Only trials with a minumum of two fixations have a latency!
        trialsWithTwo = allFixations.trialNumber(allFixations.fixationNumber == 2 & allFixations.condition == conditions(u));
        fixationsTrialsWithTwo = ismember(allFixations.trialNumber,trialsWithTwo);       %will give us a boolean list with all fixations from trials with two fixations

            %Now get the fixation durations for the first fixations in trials with two fixations
        latencies = allFixations.duration(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
        trialNumbers = allFixations.trialNumber(allFixations.fixationNumber == 1 & fixationsTrialsWithTwo);
        latencyData(u).latencies = latencies;
        latencyData(u).median = median(latencies);
        latencyData(u).se = std(latencies)./sqrt(length(latencies)-1);
        latencyData(u).condition = conditions(u);
        latencyData(u).trialNumbers = trialNumbers;
        
    end
end

