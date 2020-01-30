function [succes, trialInf] = performTrial8(w,el,expProps,trialInf,trial,condition, subCondition,doDriftCorrect,rotationPosition)                                         

    constantsSacExp_JV;

    succes = EYL_RECORDING_INCOMPLETE;              %%%%%Als het geen succes wordt moet ie eruit of duidelijk gemarkeerd

    initiateEyelink4Trial_JV;

            %random position
    radBase = rotationPosition + floor(rand(1)*4)*(pi/2);
    
    radPosition(1) = radBase;
    [elementX(1) elementY(1)] = getCoordsFromRad_JV(radPosition(1),expProps.distance,expProps.startX,expProps.startY);
    stimProps(1).stimSize  = expProps.elementRadius*2;
    
    radPosition(2) = radBase + ceil(rand(1)*3)*(pi/2);
    [elementX(2) elementY(2)] = getCoordsFromRad_JV(radPosition(2),expProps.distance,expProps.startX,expProps.startY);
    stimProps(2).stimSize  = expProps.elementRadius*2;
    
    distractorColor = expProps.distractorColor;
    targetColor     = expProps.targetColor;
    
    trialInf.rotation = radBase;
    
    cueIndex    = ceil(rand(1)*2);
    cues        = [1 2; 2 1];
    antiCues    = [2 1; 1 2];
    cueLocs     = cues(cueIndex,:);
    antiLocs    = antiCues(cueIndex,:);
    
    if condition == CONDITION_IOR,
        stimProps(cueLocs(1)).type  = TARGET;
        stimProps(cueLocs(2)).type  = DISTRACTOR;
    else
        stimProps(antiLocs(1)).type = TARGET;
        stimProps(antiLocs(2)).type = DISTRACTOR;
    end
    
    Eyelink('command','draw_cross %d %d 15',trialInf.startX,trialInf.startY);
    for u = 1:2,
        Eyelink('command','draw_filled_box %d %d %d %d %d',round(elementX(u)-10),round(elementY(u)-10),round(elementX(u)+10),round(elementY(u)+10),stimProps(u).type+1);
    end
    
    trialInf = addPositionInf_JV(trialInf,elementX',elementY',stimProps,radPosition');
       %draw and flip to put disks onscreen
    drawFixCross_JV(w,trialInf,expProps);
    [sysTimeStimOn, trialInf.stimulusTime] = drawStimulusToBuffer(w,elementX, elementY,expProps);
        
        %draw again to fill the second buffer
    drawFixCross_JV(w,trialInf,expProps);
    [~, ~]   = drawStimulusToBuffer(w,elementX, elementY,expProps);
    
        %stap 2 teken cues
    cueOnsetTime                    = sysTimeStimOn + getValueInRange(expProps.cueDelayRange);
    [sysTimeCueOn, cueOnsetStamp]   = showDoubleCue(w, elementX(cueLocs(1)), elementY(cueLocs(1)),expProps,cueLocs,expProps.cueColor,cueOnsetTime);
    Eyelink('message', 'SYNCTIME');	 	 % zero-plot time for EDFVIEW
    trialInf.cueTime                = cueOnsetStamp - trialInf.stimulusTime; % correction for start stamp
    
        %stap 3 verwijder cues
    cueOffsetTime               = sysTimeCueOn + expProps.cueOnTime;
    [~, cueOffsetStamp]         = clearDoubleCue(w, elementX(cueLocs(1)), elementY(cueLocs(1)),expProps,cueOffsetTime);
    trialInf.cueOffTime         = cueOffsetStamp - trialInf.stimulusTime; % correction for start stamp        
    
        %stap 4 voeg target en distractor ring toe
    targetOnsetTime        = cueOnsetTime + getValueInRange(expProps.ctoaRange);
    if condition == CONDITION_NO_IOR,
        [~, offsetFixation, onsetTarget] = showTargetDistractor(w, elementX(antiLocs(1)), elementY(antiLocs(1)), elementX(antiLocs(2)), elementY(antiLocs(2)),expProps,antiLocs,targetColor,distractorColor,subCondition,targetOnsetTime);
    else
        [~, offsetFixation, onsetTarget] = showTargetDistractor(w, elementX(cueLocs(1)), elementY(cueLocs(1)), elementX(cueLocs(2)), elementY(cueLocs(2)),expProps,cueLocs,targetColor,distractorColor,subCondition,targetOnsetTime);
    end
    trialInf.offsetFixTime  = offsetFixation - trialInf.stimulusTime; % correction for start stamp    
    trialInf.targetTime     = onsetTarget - trialInf.stimulusTime; % correction for start stamp    
    
    tic;
    
        %check the recording every 1 ms
    error=Eyelink('checkrecording'); 		
    if(error~=0)
        succes=EYL_RECORDING_INTERRUPT;
        return;
    end
    newSample = 0;
    while newSample <= 0
        % get the sample in the form of an event structure
       newSample = Eyelink( 'NewFloatSampleAvailable');
       evt = Eyelink( 'NewestFloatSample');
       initialPosX = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
       initialPosY = evt.gy(eye_used+1); % do we have valid data and is the pupil visible?            
    end
    
    while (true)

        if Eyelink( 'NewFloatSampleAvailable') > 0
            % get the sample in the form of an event structure
           evt = Eyelink( 'NewestFloatSample');
           eyeX = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
           eyeY = evt.gy(eye_used+1); % do we have valid data and is the pupil visible?            
                %keep running till the time is up
            if( squaredDistance([initialPosX initialPosY],[eyeX eyeY]) > expProps.squaredRange || toc > expProps.trialTime )
                WaitSecs(0.25);
                endEyelinkTrial_JV;
                cleanScreen_JV;
                break;
            end
        end
        
            %check the recording every 1 ms
        error=Eyelink('checkrecording'); 		
        if(error~=0)
            succes=EYL_RECORDING_INTERRUPT;
            return;
        end
        
            %intentionaly slow things down a little bit so that we don't
            %sample like crazy
        WaitSecs(0.001);
            
        
    end
    
end
    
    
function [vblTime, offsetFixation, onsetTargets] = showTargetDistractor(w, cueX1, cueY1, cueX2, cueY2,expProps,cueNum,targetColor,distractorColor,subCondition,cueOnsetTime)

    constantsSacExp_JV;

    offsetTime = getValueInRange_JV(expProps.fixTimeRange);
    
    if subCondition == CONDITION_GAP
        Screen('FillOval', w, (expProps.backgroundColor),[expProps.startX-expProps.elementRadius expProps.startY-expProps.elementRadius expProps.startX+expProps.elementRadius expProps.startY+expProps.elementRadius]);
        [~, offsetFixation] = Screen('Flip', w,cueOnsetTime-offsetTime,1);
    end

    Screen('FillOval', w, (targetColor*expProps.foregroundColor),[cueX1-expProps.elementRadius cueY1-expProps.elementRadius cueX1+expProps.elementRadius cueY1+expProps.elementRadius]);
    Screen('FillOval', w, (distractorColor*expProps.foregroundColor),[cueX2-expProps.elementRadius cueY2-expProps.elementRadius cueX2+expProps.elementRadius cueY2+expProps.elementRadius]);
    [vblTime, onsetTargets] = Screen('Flip', w,cueOnsetTime,1);
    Eyelink('message', 'MARKER %d', cueNum(1));	 	 % zero-plot time for EDFVIEW
    Eyelink('message', 'MARKER %d', cueNum(2));	 	 % zero-plot time for EDFVIEW

    Screen('FillOval', w, (expProps.backgroundColor),[cueX2-expProps.elementRadius cueY2-expProps.elementRadius cueX2+expProps.elementRadius cueY2+expProps.elementRadius]);
    [vblTime, onsetTargets] = Screen('Flip', w,cueOnsetTime+0.05,1);
    
    if subCondition == CONDITION_OVERLAP
        Screen('FillOval', w, (expProps.backgroundColor),[expProps.startX-expProps.elementRadius expProps.startY-expProps.elementRadius expProps.startX+expProps.elementRadius expProps.startY+expProps.elementRadius]);
        [vblTime, offsetFixation] = Screen('Flip', w,cueOnsetTime+offsetTime,1);
    end
    
end  
    
function [vblTime onsetScreenFlip] = clearDoubleCue(w, cueX1, cueY1,expProps,cueOffsetTime)
    
        %first clear the thicker cues and then redraw thinner placeholders
    Screen('FrameOval', w, expProps.backgroundColor,[cueX1-expProps.cueSize cueY1-expProps.cueSize cueX1+expProps.cueSize cueY1+expProps.cueSize],expProps.cueThickness);
    Screen('FrameOval', w, expProps.foregroundColor,[cueX1-expProps.cueSize cueY1-expProps.cueSize cueX1+expProps.cueSize cueY1+expProps.cueSize],expProps.elementThickness);
    [vblTime onsetScreenFlip] = Screen('Flip',w, cueOffsetTime,1);
end

function [vblTime onsetScreenFlip] = showDoubleCue(w, cueX1, cueY1,expProps,cueNum,cueColor,cueOnsetTime)
        
    Screen('FrameOval', w, cueColor*expProps.foregroundColor,[cueX1-expProps.cueSize cueY1-expProps.cueSize cueX1+expProps.cueSize cueY1+expProps.cueSize],expProps.cueThickness);
    [vblTime onsetScreenFlip] = Screen('Flip', w,cueOnsetTime,1);

    Eyelink('message', 'MARKER %d', cueNum(1));	 	 % zero-plot time for EDFVIEW
    Eyelink('message', 'MARKER %d', cueNum(2));	 	 % zero-plot time for EDFVIEW
end

function [vblTime onsetScreenFlip] = drawStimulusToBuffer(w, elementX, elementY,expProps)
        
    for u = 1:length(elementX)
        Screen('FrameOval', w, expProps.foregroundColor,[elementX(u)-expProps.cueSize elementY(u)-expProps.cueSize elementX(u)+expProps.cueSize elementY(u)+expProps.cueSize],expProps.elementThickness);
    end
    [vblTime onsetScreenFlip] = Screen('Flip', w,0,1);
    
end

function [distanceSq] = squaredDistance(pos1,pos2)
    distanceSq = (pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2;
end
    
function [timing] = getValueInRange(range)
    timing = min(range) + rand(1)*(max(range) - min(range));
end
