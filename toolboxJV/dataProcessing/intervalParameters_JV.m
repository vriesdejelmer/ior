function [ selectionData ] = intervalParameters_JV( allFixations, trialInf, experimentMessages )
        
    constantsSacExp_JV;

    conditions = unique(allFixations.condition);

    if( isfield(allFixations,'subCondition') & ~isempty(allFixations.subCondition) )
        subConditions = unique(allFixations.subCondition);
    else
        subConditions = 0;
    end

    for( u = 1:length(conditions) )
            
        for( v = 1:length(subConditions) )

            selectionData(u,v).condition = conditions(u);
            
            if( subConditions(v) ~= 0 )
                    %get a subselection of trials
                selection = allFixations.fixationNumber == 3 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v);
                selectionData(u,v).subCondition = subConditions(v);
            else
                    %get a subselection of trials
                selection = allFixations.fixationNumber == 3 & allFixations.condition == conditions(u);                    
            end

                %get the trial numbers
            trialNumbers = allFixations.trialNumber(selection);
            trialSelectionList = ismember(allFixations.trialNumber,trialNumbers);

            messageSelection = ismember([experimentMessages.trialid],trialNumbers);
            if( isfield(experimentMessages,'markerTimeStamp') && ~isempty([experimentMessages(messageSelection).markerTimeStamp]) )
                    %experiment message selection
                selectionData(u,v).markerTimes = ([experimentMessages(messageSelection).markerTimeStamp] - [experimentMessages(messageSelection).synctimeTimeStamp])';
                selectionData(u,v).markers = [experimentMessages(messageSelection).marker]';
            end


                %Now get the fixation durations for the first fixations in trials with two fixations
            selectionData(u,v).trials = allFixations.trialNumber(selection);
            selectionData(u,v).latencies = allFixations.duration(trialSelectionList & allFixations.fixationNumber == 1);
            selectionData(u,v).intervals = allFixations.duration(trialSelectionList & allFixations.fixationNumber == 2);
            selectionData(u,v).fixatedElements = [allFixations.fixatedElements(trialSelectionList & allFixations.fixationNumber == 2) allFixations.fixatedElements(selection)];
            selectionData(u,v).amplitudes = [allFixations.incomingAmplitude(trialSelectionList & allFixations.fixationNumber == 2) allFixations.incomingAmplitude(selection)];
            selectionData(u,v).xPoints = [allFixations.xCoord(trialSelectionList & allFixations.fixationNumber == 1) allFixations.xCoord(trialSelectionList & allFixations.fixationNumber == 2) allFixations.xCoord(selection)];
            selectionData(u,v).yPoints = [allFixations.yCoord(trialSelectionList & allFixations.fixationNumber == 1) allFixations.yCoord(trialSelectionList & allFixations.fixationNumber == 2) allFixations.yCoord(selection)];
            selectionData(u,v).xVect = [allFixations.xVect(trialSelectionList & allFixations.fixationNumber == 2) allFixations.xVect(selection)];
            selectionData(u,v).yVect = [allFixations.yVect(trialSelectionList & allFixations.fixationNumber == 2) allFixations.yVect(selection)];
            selectionData(u,v).radian = [allFixations.eyeMovRad(trialSelectionList & allFixations.fixationNumber == 2) allFixations.eyeMovRad(selection)];

            if( isfield(experimentMessages,'orientation') )
%                     %experiment message selection
%                 rotateSelectionData_JV(selectionData(u,v),experimentMessages(messageSelection).orientation) 
                selectionData(u,v).rotation = [experimentMessages(messageSelection).orientation]';
            end



            if( ~isempty(allFixations.dis2Tar) )
                selectionData(u,v).distanceToTarget = allFixations.distanceElements(selection);
            end
        end
    end

end

