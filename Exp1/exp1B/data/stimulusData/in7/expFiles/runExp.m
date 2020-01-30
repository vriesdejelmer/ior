function [] = runExp(number, w, wRect,el,expProps)

constantsSacExp_JV;

trialPerCond = expProps.trialsPerCondition;

    %luminantie condities
conditions = makeConditionList_JV(expProps.conditions, trialPerCond);
totalTrials = length(conditions);

conditions = [makeConditionList_JV(expProps.conditions, expProps.practiceTrials) conditions];

    %Trials initialiseren
trial = 1; 

HideCursor;

rotationPosition = 2 * pi * rand(1);

while ~isempty(conditions)

            %Elke x trials een driftcorrect
    if( mod(trial,expProps.trialsPerDrift) == 1 ), driftCorrect = true;
    else driftCorrect = false;
    end
    
    if( trial == round(totalTrials/3) )
        displayInstruction_JV(w, 'You have completed a third of the experiment, only two-thirds to go',expProps);
        driftCorrect = true;
    elseif( trial == round(2*(totalTrials/3)) )
        displayInstruction_JV(w, 'Only one-third to go!',expProps);
        driftCorrect = true;
    elseif( trial == 1 )
        displayInstruction_JV(w, 'Practice Trials',expProps);
        driftCorrect = true;
    elseif( trial == 1+expProps.practiceTrials*2 )
        displayInstruction_JV(w, 'The experiment Will Now Start!',expProps);
        driftCorrect = true;
    end

        %get your conditions
    [condition conditions] = pickRandom_JV(conditions);

    trialInfo.trial     = trial;

    Eyelink('command','clear_screen 0');
    
        %Trial draaien
    eval(['[succes trialInfo] = performTrial' num2str(number) '(w,el,expProps,trialInfo,trial,condition,driftCorrect,rotationPosition);']);
    Eyelink('message', 'TRIAL_RESULT %d', succes);

    completeTrialInfo_JV;

    trial = trial + 1;
    rotationPosition = mod(rotationPosition + (pi/2) + (rand(1)-0.5) * (pi/4),2*pi);
    clear trialInfo;
end

ShowCursor;

save(['../' expProps.stimDir 'trialInformation'],'trialInformation');