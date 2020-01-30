function [] = runExpWithSub(number, w, wRect,el,expProps)

constantsSacExp_JV;

trialPerCond = expProps.trialsPerCondition;

    %condities
conditions      = make2DConditionList_JV(expProps.conditions, expProps.subConditions, trialPerCond);
practiceList    = make2DConditionList_JV(expProps.conditions, expProps.subConditions, expProps.practiceTrials);
numbPractice    = length(practiceList);

totalTrials = length(conditions);

    %Trials initialiseren
trial = 1; 

HideCursor;

rotationPosition = 2 * pi * rand(1);

while ~isempty(conditions)

            %Elke x trials een driftcorrect
    if( mod(trial,expProps.trialsPerDrift) == 1 ), driftCorrect = true;
    else driftCorrect = false;
    end
    
    if( trial-numbPractice == round(totalTrials/3) )
        displayInstruction_JV(w, 'You have completed a third of the experiment, only two-thirds to go',expProps);
        driftCorrect = true;
    elseif( trial-numbPractice == round(2*(totalTrials/3)) )
        displayInstruction_JV(w, 'Only one-third to go!',expProps);
        driftCorrect = true;
    elseif( trial == 1 )
        displayInstruction_JV(w, 'Practice Trials',expProps);
        driftCorrect = true;
    elseif( trial == 1+numbPractice )
        displayInstruction_JV(w, 'The experiment Will Now Start!',expProps);
        driftCorrect = true;
    end
    
    if ~isempty(practiceList),
            %select a condition and split subcond
        [conditionSet, practiceList] = pickRandom_JV(practiceList);
        trialInfo.practice  = true;
    else
        [conditionSet, conditions] = pickRandom_JV(conditions);
        trialInfo.practice  = false;
    end

    condition       = conditionSet(1);
    subCondition    = conditionSet(2);
    trialInfo.trial     = trial;

    Eyelink('command','clear_screen 0');
    
        %Trial draaien
    eval(['[succes trialInfo] = performTrial' num2str(number) '(w,el,expProps,trialInfo,trial,condition,subCondition,driftCorrect,rotationPosition);']);
    Eyelink('message', 'TRIAL_RESULT %d', succes);

    completeTrialInfo_JV;

    trial = trial + 1;
    rotationPosition = mod(rotationPosition + (pi/4) + (rand(1)-0.5) * (pi/8),2*pi);
    clear trialInfo;
end

ShowCursor;

save(['../' expProps.stimDir 'trialInformation'],'trialInformation');