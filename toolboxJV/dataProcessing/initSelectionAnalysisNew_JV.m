function [ selectionData ] = initSelectionAnalysis_JV( allFixations, trialInf, experimentMessages )
        
    constantsSacExp_JV;         %load constants
    
        %get the condition list
    conditions = unique([allFixations.condition]);

        %if there are no subconditions we just label the field zero for later processing
    if( isfield(allFixations,'subCondition') & ~isempty([allFixations.subCondition]) )
        subConditions = unique([allFixations.subCondition]);
    else
        subConditions = 0;
    end
    
        %for each condition
    for( u = 1:length(conditions) )
            
            %and each subconition
        for( v = 1:length(subConditions) )

                %and subcondition if available
            if( subConditions(v) ~= 0 )
                    %get a subselection of trials
                selection = [allFixations.condition] == conditions(u) & [allFixations.subCondition] == subConditions(v) & arrayfun(@(x)(sum(x.fixationNumber == 2) > 0),allFixations);
            else
                    %get a subselection of trials
                selection = [allFixations.condition] == conditions(u) & arrayfun(@(x)(sum(x.fixationNumber == 2) > 0),allFixations);
            end

            
                %get the trial numbers
            trialNumbers = [allFixations(selection).trialNumber];
            trialSelectionList = ismember([allFixations.trialNumber],trialNumbers);

                %get the list for this condition
            fixationsForCondition   = allFixations(selection);  %limit selection to trials for the current condition
            allFixatedElements      = [fixationsForCondition.fixatedElements]';
            fixationNumbers         = [fixationsForCondition.fixationNumber]';
            allFixationDurations    = [fixationsForCondition.duration]';
            allFixationStartTimes   = [fixationsForCondition.startTime]';
            firstFixationIndices    = [fixationsForCondition.fixationNumber]' == 1;
            secondFixationIndices   = [fixationsForCondition.fixationNumber]' == 2;
            distanceElements        = [fixationsForCondition.distanceElements]';
            radiansToEl             = [fixationsForCondition.minimumRadians]';
            distanceToTar           = [fixationsForCondition.dis2Tar]';
            radiansToTar            = [fixationsForCondition.rad2Tar]';
            if isfield(fixationsForCondition,'peakVel')  peakVelocity            = [fixationsForCondition.peakVel]';
            end
            amplitudes              = [fixationsForCondition.incomingAmplitude]';
            xCoords                 = [fixationsForCondition.xCoord]';
            yCoords                 = [fixationsForCondition.yCoord]';
            xVects                  = [fixationsForCondition.xVect]';
            yVects                  = [fixationsForCondition.yVect]';
            eyeMovRad               = [fixationsForCondition.eyeMovRad]';
            
            
                %Now get the saccade characteristics for the initial selection
            selectionData(u,v).trials               = trialNumbers';
            selectionData(u,v).latencies            = allFixationDurations(firstFixationIndices);
            selectionData(u,v).secondFixStart       = allFixationStartTimes(secondFixationIndices);
            selectionData(u,v).fixatedElementProps  = allFixatedElements(secondFixationIndices);
            selectionData(u,v).distanceToEl         = distanceElements(secondFixationIndices);
            selectionData(u,v).radiansToEl          = radiansToEl(secondFixationIndices);
            selectionData(u,v).distanceToTar        = distanceToTar(secondFixationIndices);
            selectionData(u,v).radiansToTar         = radiansToTar(secondFixationIndices);
            selectionData(u,v).amplitudes           = amplitudes(secondFixationIndices);
            if exist('peakVelocity')  selectionData(u,v).peakVelocity         = peakVelocity(secondFixationIndices); end
            selectionData(u,v).xEndPoint            = xCoords(secondFixationIndices);
            selectionData(u,v).yEndPoint            = yCoords(secondFixationIndices);
            selectionData(u,v).xBeginPoint          = xCoords(firstFixationIndices);
            selectionData(u,v).yBeginPoint          = yCoords(firstFixationIndices);
            selectionData(u,v).xVect                = xVects(secondFixationIndices);
            selectionData(u,v).yVect                = yVects(secondFixationIndices);
            selectionData(u,v).radian               = eyeMovRad(secondFixationIndices);
            
                    %depending on whether the fixation elements are coded new (struct) or old (constant) style we add them to fixatedElement field
            if( isstruct('allFixatedElements') )
                selectionData(u,v).fixatedElements = [allFixatedElements(secondFixationIndices).type];
            else
                selectionData(u,v).fixatedElements = allFixatedElements(secondFixationIndices);
            end
            
                %finally add the trialInformation for the specific trials based on the current condition
            trialInfSelection = ismember([trialInf.trial],trialNumbers);
            selectionData(u,v).trialInf = trialInf(trialInfSelection)';
            
            
                %we distill the selection markers
            messageSelection = ismember([experimentMessages.trialid],trialNumbers);
            if( isfield(experimentMessages(messageSelection),'markerTimeStamp') && ~isempty([experimentMessages(messageSelection).markerTimeStamp]) )
                
                    %experiment message selection
                messagesForCondition = experimentMessages(messageSelection);
                entriesPerTrial = ceil(length([messagesForCondition.markerTimeStamp])/length(messagesForCondition));
                
                for( y = 1:length(messagesForCondition) )
                    markerTimeStamps = messagesForCondition(y).markerTimeStamp;
                    markers = messagesForCondition(y).marker;
                    for( z = 1:entriesPerTrial )
                        if( z > length(markers) | z > length(markerTimeStamps) )
                            eval(['selectionData(u,v).markerTimes' num2str(z) '(y) = NaN;']);
                            eval(['selectionData(u,v).markers' num2str(z) '(y) = NaN;']);
                        else
                            eval(['selectionData(u,v).markerTimes' num2str(z) '(y) = markerTimeStamps(z) - messagesForCondition(y).synctimeTimeStamp;']);
                            eval(['selectionData(u,v).markers' num2str(z) '(y) = markers(z);']);
                        end
                    end
                end

                for( z = 1:entriesPerTrial )
                    eval(['selectionData(u,v).markers' num2str(z) ' = selectionData(u,v).markers' num2str(z) ''';']);
                    eval(['selectionData(u,v).markerTimes' num2str(z) ' = selectionData(u,v).markerTimes' num2str(z) ''';']);
                end

                    
            end
               
                %for which experient is this applicable??
            if( isfield(experimentMessages,'orientation') )
%                     %experiment message selection
%                 rotateSelectionData_JV(selectionData(u,v),experimentMessages(messageSelection).orientation) 
                selectionData(u,v).rotation = [experimentMessages(messageSelection).orientation]';
            end
            
                %get the current condition
            %selectionData(u,v).condition = ones(size(selectionData(u,v).trials)) * conditions(u);
            
            selectionData(u,v).condition = conditions(u);
            
                %and subcondition if available
            if( subConditions(v) ~= 0 )
                    selectionData(u,v).subCondition = ones(size(selectionData(u,v).trials)) * subConditions(v); %get a subselection of trials 
            end



        end
    end

end

