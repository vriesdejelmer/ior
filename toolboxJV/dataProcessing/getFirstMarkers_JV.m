function [ markerData ] = getFirstMarkers_JV( allFixations, trialInformation,conditions )
        
    constantsSacExp_JV;

    if( ~exist('conditions') )
        conditions = unique(allFixations.condition);
    end

    subConditions = unique(allFixations.subCondition);

    for( u = 1:length(conditions) )
            
        for( v = 1:length(subConditions) )
                %get a subselection of trials
            selection = allFixations.fixationNumber == 2 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v);

                %get the trial numbers
            trialNumbers = allFixations.trialNumber(selection);

                %Now get the fixation durations for the first fixations in trials with two fixations
            markerData(v,u).condition = conditions(u);
            markerData(v,u).subCondition = subConditions(v);
            markerData(v,u).fixatedElements = allFixations.fixatedElements(selection);
            markerData(v,u).distanceToEl = allFixations.distanceElements(selection);

                %get timings for the trials(selection)
            markerData(v,u).timingList = [trialInformation(ismember([trialInformation.trialId],trialNumbers)).delayTime]';
%             messageSelection = ismember([experimentMessages.trialid],trialNumbers);
%             markerData(v,u).timingList = [experimentMessages(messageSelection).markerTimeStamp]' - [experimentMessages(messageSelection).synctimeTimeStamp]';
%             
        end
    end

end

