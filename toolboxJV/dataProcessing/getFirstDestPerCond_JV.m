function [ selectionData ] = initSelectionAnalysis_JV( allFixations, trialInf )
        
    constantsSacExp_JV;

    conditions = unique(allFixations.condition);
    if( isfield(allFixations,'subConditions') )
        subConditions = unique(allFixations.subCondition);
    else
        subConditions = 0;
    end

    for( u = 1:length(conditions) )
            
        for( v = 1:length(subConditions) )
            
            selectionData(u,v).condition = conditions(u);
            
            if( subConditions(u) ~= 0 )
                    %get a subselection of trials
                selection = allFixations.fixationNumber == 2 & allFixations.condition == conditions(u) & allFixations.subCondition == subConditions(v);
                selectionData(u,v).subCondition = subConditions(u);
            else
                    %get a subselection of trials
                selection = allFixations.fixationNumber == 2 & allFixations.condition == conditions(u);                    
            end

                %get the trial numbers
            trialNumbers = allFixations.trialNumber(selection);

                %Now get the fixation durations for the first fixations in trials with two fixations
            selectionData(u,v).fixatedElements = allFixations.fixatedElements(selection);
            selectionData(u,v).distanceToEl = allFixations.distanceElements(selection);

            %Here we calculate the distance in angle between the saccade and the targer
                %radiansToElement
            selectionData(u,v).radian = getSaccadeRadAngle_JV(allFixations,selection);
                %getRadians for elements in trials(selection)
            radialList = [trialInf(ismember([trialInf.trialId],trialNumbers)).radials];
                %Now reduce the list to only target radian
            targetRadialList = radialList([trialInf(ismember([trialInf.trialId],trialNumbers)).elements] == TARGET);
                %Now calculate the difference between target angle and saccade angle
            radianTarDist = abs(selectionData(u).radian - targetRadialList);
                %the maximum radianDistance is pi, after that it get closer again
            radianTarDist( radianTarDist > pi ) = 2*pi - (radianTarDist( radianTarDist > pi ));
            selectionData(u,v).radianTarDist = radianTarDist;

            if( ~isempty(allFixations.dis2Tar) )
                selectionData(u,v).distanceToTarget = allFixations.distanceElements(selection);
            end
        end
    end

end

