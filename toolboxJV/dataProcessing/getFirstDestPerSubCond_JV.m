function [ fixationData ] = getFirstDestPerSubCond_JV( allFixations, trialInf,conditions )
        
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
            fixationData(v,u).condition = conditions(u);
            fixationData(v,u).subCondition = subConditions(v);
            fixationData(v,u).fixatedElements = allFixations.fixatedElements(selection);
            fixationData(v,u).distanceToEl = allFixations.distanceElements(selection);
            fixationData(v,u).trialId = trialNumbers;

            %Here we calculate the distance in angle between the saccade and the targer
                %radiansToElement
            fixationData(v,u).radian = getSaccadeRadAngle_JV(allFixations,selection);
                %getRadians for elements in trials(selection)
            radialList = [trialInf(ismember([trialInf.trialId],trialNumbers)).radials];
                %Now reduce the list to only target radian
            targetRadialList = radialList([trialInf(ismember([trialInf.trialId],trialNumbers)).elements] == TARGET);
                        
                %Now calculate the difference between target angle and saccade angle
            radianTarDist = abs(fixationData(v,u).radian - targetRadialList);
                %the maximum radianDistance is pi, after that it get closer again
            radianTarDist( radianTarDist > pi ) = 2*pi - (radianTarDist( radianTarDist > pi ));
            fixationData(v,u).radianTarDist = radianTarDist;
            fixationData(v,u).targetRadial = targetRadialList;

            if( ~isempty(allFixations.dis2Tar) )
                fixationData(v,u).distanceToTarget = allFixations.distanceElements(selection);
            end
        end
    end

end

