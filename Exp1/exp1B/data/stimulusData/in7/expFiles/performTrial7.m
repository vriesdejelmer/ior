function [succes, trialInf] = performTrial7(w,el,expProps,trialInf,trial,condition,doDriftCorrect,rotationPosition)                                         

    constantsSacExp_JV;

    succes = EYL_RECORDING_INCOMPLETE;              %%%%%Als het geen succes wordt moet ie eruit of duidelijk gemarkeerd

    initiateEyelink4Trial_JV;

            %random position
    radBase = rotationPosition + floor(rand(1)*4)*(pi/2);
    
    for u = 1:4,
        radPosition(u) = (1/2)*pi*(u-1) + radBase;
        [elementX(u) elementY(u)] = getCoordsFromRad_JV(radPosition(u),expProps.distance,expProps.startX,expProps.startY);
        stimProps(u).stimSize  = expProps.elementRadius*2;
    end
    
    cueIndex    = ceil(rand(1)*3);
    cues        = [1 2; 1 4; 1 3];
    antiCues    = [3 4; 3 2; 2 4];
    cueLocs     = cues(cueIndex,:);
    antiLocs    = antiCues(cueIndex,:);
    
    if condition == CONDITION_IOR,
        stimProps(cueLocs(1)).type  = TARGET;
        stimProps(cueLocs(2)).type  = DISTRACTOR;
        stimProps(antiLocs(1)).type = ALTERN;
        stimProps(antiLocs(2)).type = ALTERN;       
    else
        stimProps(antiLocs(1)).type = TARGET;
        stimProps(antiLocs(2)).type = DISTRACTOR;
        stimProps(cueLocs(1)).type  = ALTERN;
        stimProps(cueLocs(2)).type  = ALTERN;
    end
    
    Eyelink('command','draw_cross %d %d 15',trialInf.startX,trialInf.startY);
    for u = 1:4,
        Eyelink('command','draw_filled_box %d %d %d %d %d',round(elementX(u)-10),round(elementY(u)-10),round(elementX(u)+10),round(elementY(u)+10),stimProps(u).type+1);
    end
    
    trialInf = addPositionInf_JV(trialInf,elementX',elementY',stimProps,radPosition');
       %draw and flip to put disks onscreen
    drawFixCross_JV(w,trialInf,expProps);
    [sysTime, trialInf.stimulusTime] = drawStimulusToBuffer(w,elementX, elementY,expProps);
        
        %draw again to fill the second buffer
    drawFixCross_JV(w,trialInf,expProps);
    [ignored_value, ignored_value]   = drawStimulusToBuffer(w,elementX, elementY,expProps);
    
        %stap 2 teken cues
    cueOnsetTime                    = sysTime + getValueInRange(expProps.cueDelayRange);
    [sysTime, cueOnsetStamp]      = showDoubleCue(w, elementX(cueLocs(1)), elementY(cueLocs(1)), elementX(cueLocs(2)), elementY(cueLocs(2)),expProps,cueLocs,expProps.cueColor,cueOnsetTime);
    Eyelink('message', 'SYNCTIME');	 	 % zero-plot time for EDFVIEW
    trialInf.cueTime                = cueOnsetStamp - trialInf.stimulusTime; % correction for start stamp
    
        %stap 3 verwijder cues
    cueOffsetTime                   = sysTime + expProps.cueOnTime;
    [sysTime, cueOffsetStamp, fixationIncrease]        = clearDoubleCue(w, elementX(cueLocs(1)), elementY(cueLocs(1)), elementX(cueLocs(2)), elementY(cueLocs(2)),expProps,cueOffsetTime);
    trialInf.cueOffTime             = cueOffsetStamp - trialInf.stimulusTime; % correction for start stamp    
    trialInf.fixationIncrease       = fixationIncrease - trialInf.stimulusTime; % correction for start stamp        
        
        %return to normal fix cross
    Screen('FillOval',w,expProps.backgroundColor,[expProps.startX-20 expProps.startY-20 expProps.startX+20 expProps.startY+20])
    drawFixCross_JV(w,trialInf,expProps);
    [sysTime, fixationDecrease] = Screen('Flip',w, sysTime+0.3,1);
    trialInf.fixationNormal = fixationDecrease - trialInf.stimulusTime; % correction for start stamp        
    
        %stap 4 voeg target en distractor ring toe
    cueOnsetTime    = sysTime + getValueInRange(expProps.cueTargetAsyncRange);
    if condition == CONDITION_IOR,
        [sysTime, targetTimeStamp] = showTargetDistractor(w, elementX(cueLocs(1)), elementY(cueLocs(1)), elementX(cueLocs(2)), elementY(cueLocs(2)),0,90,expProps,cueLocs,cueOnsetTime);
    else
        [sysTime, targetTimeStamp] = showTargetDistractor(w, elementX(antiLocs(1)), elementY(antiLocs(1)), elementX(antiLocs(2)), elementY(antiLocs(2)),0,90,expProps,antiLocs,cueOnsetTime);
    end
    trialInf.targetTime     = targetTimeStamp - trialInf.stimulusTime; % correction for start stamp    
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
    
    
function [vblTime onsetScreenFlip] = showTargetDistractor(w, cueX1, cueY1, cueX2, cueY2,stim1Color,stim2Color,expProps,cueNum,cueOnsetTime)

        %remove fix cross
    Screen('FillOval', w, expProps.backgroundColor,[expProps.startX-expProps.cueSize expProps.startY-expProps.cueSize expProps.startX+expProps.cueSize expProps.startY+expProps.cueSize], expProps.cueThickness);
                
        %draw target
    Screen('FrameOval', w, stim1Color,[cueX1-expProps.elementRadius cueY1-expProps.elementRadius cueX1+expProps.elementRadius cueY1+expProps.elementRadius],expProps.elementThickness);
        
        %draw distractor
    Screen('FrameOval', w, stim2Color,[cueX2-expProps.elementRadius cueY2-expProps.elementRadius cueX2+expProps.elementRadius cueY2+expProps.elementRadius],expProps.elementThickness);
            
    [vblTime, onsetScreenFlip] = Screen('Flip', w,cueOnsetTime,1);
    
    Eyelink('message', 'MARKER %d', cueNum(1));	 	 % zero-plot time for EDFVIEW
    Eyelink('message', 'MARKER %d', cueNum(2));	 	 % zero-plot time for EDFVIEW
end  
    
function [vblTime, onsetScreenFlip, fixationIncrease] = clearDoubleCue(w, cueX1, cueY1, cueX2, cueY2,expProps,cueOffsetTime)
    
    Screen('FrameOval', w, expProps.foregroundColor,[cueX1-expProps.cueSize cueY1-expProps.cueSize cueX1+expProps.cueSize cueY1+expProps.cueSize],expProps.cueThickness);
    Screen('FillOval', w, expProps.backgroundColor,[cueX1-expProps.fixElRadius cueY1-expProps.fixElRadius cueX1+expProps.fixElRadius cueY1+expProps.fixElRadius]);
    Screen('FrameOval', w, expProps.foregroundColor,[cueX2-expProps.cueSize cueY2-expProps.cueSize cueX2+expProps.cueSize cueY2+expProps.cueSize],expProps.cueThickness);
    Screen('FillOval', w, expProps.backgroundColor,[cueX2-expProps.fixElRadius cueY2-expProps.fixElRadius cueX2+expProps.fixElRadius cueY2+expProps.fixElRadius]);
    
    [vblTime, onsetScreenFlip] = Screen('Flip',w, cueOffsetTime,1);
    
    Screen('FrameOval', w, expProps.foregroundColor,[expProps.startX-15 expProps.startY-15 expProps.startX+15 expProps.startY+15],10);
    
    [vblTime2, fixationIncrease] = Screen('Flip',w, cueOffsetTime+0.25,1);
end

function [vblTime, onsetScreenFlip] = showDoubleCue(w, cueX1, cueY1, cueX2, cueY2,expProps,cueNum,cueColor,cueOnsetTime)
        
    Screen('FrameOval', w, cueColor,[cueX1-expProps.cueSize cueY1-expProps.cueSize cueX1+expProps.cueSize cueY1+expProps.cueSize],expProps.cueThickness);
    Screen('FrameOval', w, cueColor,[cueX2-expProps.cueSize cueY2-expProps.cueSize cueX2+expProps.cueSize cueY2+expProps.cueSize],expProps.cueThickness);
    [vblTime, onsetScreenFlip] = Screen('Flip', w,cueOnsetTime,1);
    
    Eyelink('message', 'MARKER %d', cueNum(1));	 	 % zero-plot time for EDFVIEW
    Eyelink('message', 'MARKER %d', cueNum(2));	 	 % zero-plot time for EDFVIEW
end

function [vblTime, onsetScreenFlip] = drawStimulusToBuffer(w, elementX, elementY,expProps)
        
    for u = 1:length(elementX)
        Screen('FrameOval', w, 255,[elementX(u)-expProps.cueSize elementY(u)-expProps.cueSize elementX(u)+expProps.cueSize elementY(u)+expProps.cueSize],expProps.cueThickness);
        Screen('FillOval', w, expProps.backgroundColor,[elementX(u)-expProps.fixElRadius elementY(u)-expProps.fixElRadius elementX(u)+expProps.fixElRadius elementY(u)+expProps.fixElRadius]);
    end
    [vblTime, onsetScreenFlip] = Screen('Flip', w,0,1);
    
end

function [distanceSq] = squaredDistance(pos1,pos2)
    distanceSq = (pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2;
end
    
function [timing] = getValueInRange(range)
    timing = min(range) + rand(1)*(max(range) - min(range));
end
