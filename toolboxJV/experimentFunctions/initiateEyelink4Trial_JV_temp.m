constantsSacExp_JV;

trialInf.startX = min(expProps.fixationRangeX) + rand(1) * (max(expProps.fixationRangeX) - min(expProps.fixationRangeX));

if( ~exist(trialInf.startX) ) trialInf.startX = expProps.startX; end
if( ~exist(trialInf.startY) ) trialInf.startY = expProps.startY; end

succes = EYL_RECORDING_INCOMPLETE;              %%%%%Als het geen succes wordt moet ie eruit of duidelijk gemarkeerd

Eyelink('message', 'TRIALID %d', trial );
trialInf.trialId = trial;

eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
if eye_used == el.BINOCULAR | eye_used == -1; % if both eyes are tracked
    eye_used = el.RIGHT_EYE; % use right eye
end

if( exist('doDriftCorrect')  && doDriftCorrect )
    % do a final check of calibration using driftcorrection
    EyelinkDoDriftCorrectionJV(el,expProps.startX,expProps.startY,1);
        
    errorMessage = Eyelink('StartRecording');
    if( errorMessage ~= 0 )
        succes = EYL_RECORDING_NOTSTARTED;
        return;
    end
    
    %get the sample in the form of an event structure
    evt = Eyelink('NewestFloatSample');
    correctedX = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
    correctedY = evt.gy(eye_used+1); % do we have valid data and is the pupil visible?
    
        %Wait until all keys on keyboard are released:
    while KbCheck;  end;
else
    errorMessage = Eyelink('StartRecording');
    if( errorMessage ~= 0 )
        succes = EYL_RECORDING_NOTSTARTED;
        return;
    end
    w = drawFixCross_JV(w,expProps);
    Screen('Flip', w);
    if Eyelink('NewFloatSampleAvailable') > 0
        %get the sample in the form of an event structure
        evt = Eyelink('NewestFloatSample');
        x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
        y = evt.gy(eye_used+1); % do we have valid data and is the pupil visible?
    end
    tic;
    counter = 0;
    xList = [];	yList = [];
    while( true )
        if Eyelink('NewFloatSampleAvailable') > 0
            %get the sample in the form of an event structure
            evt = Eyelink( 'NewestFloatSample');
            x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
            y = evt.gy(eye_used+1); % do we have valid data and is the pupil visible?
        end
        
        if( ((x-trialInf.startX)^2+(y-trialInf.startY)^2) > expProps.fixRangeSquared )
            counter = 0;
            xList = [];	yList = [];
        elseif( ((x-trialInf.startX)^2+(y-trialInf.startY)^2) < expProps.fixRangeSquared )
            counter = counter + 1;
            xList = [xList x];	yList = [yList y];
        end
        
        WaitSecs(0.001);
        if( counter > 150 )
            break;
        end
        
        if( toc > 2 )
            Eyelink('StopRecording');
            % do a final check of calibration using driftcorrection
            EyelinkDoDriftCorrectionJV(el,startX,startY,1);
        
            errorMessage = Eyelink('StartRecording');
            if( errorMessage ~= 0 )
                succes = EYL_RECORDING_NOTSTARTED;
                return;
            end
            
            
                %Wait until all keys on keyboard are released:
            while KbCheck;  end;
            break;
        end
    end
        %soort van driftcorrected starting point. Van de 150 samples die nodig zijn om de trial te starten halen we de eerste 50 af
    correctedX = median(xList(50:end));
    correctedY = median(yList(50:end));

end

    %Wait until all keys on keyboard are released:
while KbCheck;  end;
