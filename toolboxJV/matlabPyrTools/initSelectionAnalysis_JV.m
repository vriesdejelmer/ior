function [ selectionData ] = initSelectionAnalysis_JV( allFixations, trialInf, experimentMessages )
        
    constantsSacExp_JV;

    allFixations.condition
    conditions = unique([allFixations.condition]);

    if( isfield(allFixations,'subCondition') & ~isempty([allFixations.subCondition]) )
        subConditions = unique([allFixations.subCondition]);
    else
        subConditions = 0;
    end

    for( u = 1:length(conditions) )
            
        for( v = 1:length(subConditions) )

            selectionData(u,v).condition = conditions(u);
            
            if( subConditions(v) ~= 0 )
                    %get a subselection of trials
                selection = [allFixations.condition] == conditions(u) & [allFixations.subCondition] == subConditions(v) & arrayfun(@(x)(sum(x.fixationNumber == 2) > 0),allFixations);
                selectionData(u,v).subCondition = subConditions(v);
            else
                    %get a subselection of trials
                selection = [allFixations.condition] == conditions(u) & arrayfun(@(x)(sum(x.fixationNumber == 2) > 0),allFixations);
            end

                %get the trial numbers
            trialNumbers = allFixations.trialNumber(selection);
            trialSelectionList = ismember(allFixations.trialNumber,trialNumbers);

            messageSelection = ismember([experimentMessages.trialid],trialNumbers);
            if( isfield(experimentMessages(messageSelection),'markerTimeStamp') && ~isempty([experimentMessages(messageSelection).markerTimeStamp]) )
                %for( length(markerTimeStamp)
                    %experiment message selection
                messagesForCondition = experimentMessages(messageSelection);
                
                for(x = 1:length(messagesForCondition) )
                    markerList = messagesForCondition(x).markerTimeStamp;                        
                    for( w = 1:length(markerList) )
                        selectionData(u,v).markerTimes(x,w) = (markerList(w) - [messagesForCondition(x).synctimeTimeStamp])';
                        selectionData(u,v).markers(x,1:length(markerList)) = [messagesForCondition(x).marker]';
                    end
                end

            end
            
                %get the list for this condition
            fixationsForCondition = allFixations(selection);
            allFixatedElements = [fixationsForCondition.fixatedElements]';
            fixationNumbers = [fixationsForCondition.fixationNumber]';
            allFixationDurations = [fixationsForCondition.duration]';
            allFixationStartTimes = [fixationsForCondition.startTime]';
            firstFixationIndices = [fixationsForCondition.fixationNumber]' == 1;
            secondFixationIndices = [fixationsForCondition.fixationNumber]' == 2;
            distanceElements = [fixationsForCondition.distanceElements]';
            radiansToEl = [fixationsForCondition.minimumRadians]';
            distanceToTar = [fixationsForCondition.dis2Tar]';
            radiansToTar = [fixationsForCondition.rad2Tar]';
            amplitudes = [fixationsForCondition.incomingAmplitude]';
            xCoords = [fixationsForCondition.xCoord]';
            yCoords = [fixationsForCondition.yCoord]';
            xVects = [fixationsForCondition.xVect]';
            yVects = [fixationsForCondition.yVect]';
            eyeMovRad = [fixationsForCondition.eyeMovRad]';
            
            
                %Now get the fixation durations for the first fixations in trials with two fixations
            selectionData(u,v).trials = trialNumbers';
            
            selectionData(u,v).latencies = allFixationDurations(firstFixationIndices);
            selectionData(u,v).secondFixStart = allFixationStartTimes(secondFixationIndices);
            selectionData(u,v).fixatedElementProps = allFixatedElements(secondFixationIndices);
            if( isstruct('allFixatedElements') )
                selectionData(u,v).fixatedElements = [allFixatedElements(secondFixationIndices).type];
            else
                selectionData(u,v).fixatedElements = allFixatedElements(secondFixationIndices);
            end
           selectionData(u,v).distanceToEl = distanceElements(secondFixationIndices);
           selectionData(u,v).radiansToEl = radiansToEl(secondFixationIndices);
           selectionData(u,v).distanceToTar = distanceToTar(secondFixationIndices);
%           selectionData(u,v).radiansToTar = radiansToTar(secondFixationIndices);
            selectionData(u,v).amplitudes = amplitudes(secondFixationIndices);
            selectionData(u,v).xEndPoint = xCoords(secondFixationIndices);
            selectionData(u,v).yEndPoint = yCoords(secondFixationIndices);
            selectionData(u,v).xBeginPoint = xCoords(firstFixationIndices);
            selectionData(u,v).yBeginPoint = yCoords(firstFixationIndices);
            selectionData(u,v).xVect = xVects(secondFixationIndices);
            selectionData(u,v).yVect = yVects(secondFixationIndices);
            selectionData(u,v).radian = eyeMovRad(secondFixationIndices);
            
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

