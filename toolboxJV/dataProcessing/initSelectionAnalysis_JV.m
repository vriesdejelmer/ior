function [ selectionData ] = initSelectionAnalysis_JV( allFixations, trialInf, experimentMessages )
        
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
                selection = allFixations.fixationNumber == 2 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v);
                selectionData(u,v).subCondition = subConditions(v);
            else
                    %get a subselection of trials
                selection = allFixations.fixationNumber == 2 & allFixations.condition == conditions(u);                    
            end

                %get the trial numbers
            trialNumbers = allFixations.trialNumber(selection);
            trialSelectionList = ismember(allFixations.trialNumber,trialNumbers);

            messageSelection = ismember([experimentMessages.trialid],trialNumbers);
%             if( isfield(experimentMessages(messageSelection),'markerTimeStamp') && ~isempty([experimentMessages(messageSelection).markerTimeStamp]) )
%                 %for( length(markerTimeStamp)
%                     %experiment message selection
%                 messagesForCondition = experimentMessages(messageSelection);
%                 messagesForCondition(1).markerTimeStamp
%                 length(messagesForCondition(1).markerTimeStamp)
%                 
%                 for( w = 1:length(messagesForCondition(1).markerTimeStamp) )
%                     markerTimes = arrayfun(@(x) x.markerTimeStamp(w), messagesForCondition);
%                     if( w == 1)
%                         selectionData(u,v).markerTimes(:,w) = (markerTimes - [experimentMessages(messageSelection).synctimeTimeStamp])';
%                     else
%                         selectionData(u,v).markerTimes(:,w) = (markerTimes - selectionData(u,v).markerTimes(:,w-1)' - [experimentMessages(messageSelection).synctimeTimeStamp])';
%                     end
%                 end
%                 selectionData(u,v).markerTimes
%                 %selectionData(u,v).markers = [experimentMessages(messageSelection).marker]';
%             end


                %Now get the fixation durations for the first fixations in trials with two fixations
            selectionData(u,v).trials = allFixations.trialNumber(selection);
            selectionData(u,v).latencies = allFixations.duration(trialSelectionList & allFixations.fixationNumber == 1);
            selectionData(u,v).fixatedElements = allFixations.fixatedElements(selection);
            selectionData(u,v).distanceToEl = allFixations.distanceElements(selection);
            selectionData(u,v).radiansToEl = allFixations.minimumRadians(selection);
            selectionData(u,v).distanceToTar = allFixations.dis2Tar(selection);
            selectionData(u,v).radiansToTar = allFixations.rad2Tar(selection);
            selectionData(u,v).amplitudes = allFixations.incomingAmplitude(selection);
            selectionData(u,v).xEndPoint = allFixations.xCoord(selection);
            selectionData(u,v).yEndPoint = allFixations.yCoord(selection);
            selectionData(u,v).xVect = allFixations.xCoord(selection);
            selectionData(u,v).yVect = allFixations.yCoord(selection);
            selectionData(u,v).radian = allFixations.eyeMovRad(selection);
            
            trialInfSelection = ismember([trialInf.trialId],trialNumbers);
            selectionData(u,v).trialInf = trialInf(trialInfSelection);
            
            if( isfield(experimentMessages,'orientation') )
                disp('Komt ie hier?');
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

