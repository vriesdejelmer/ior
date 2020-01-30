

    succes = EYL_RECORDING_INCOMPLETE;              %%%%%Als het geen succes wordt moet ie eruit of duidelijk gemarkeerd
    
    %write a trialid message so trial can be matched to stimulus description
    Eyelink('message', 'TRIALID %d', trial );
        
        %do a final check of calibration using driftcorrection
    EyelinkDoDriftCorrectionJV(el,expProps.startX,expProps.startY);
        
    errorMessage = Eyelink('StartRecording');
    if( errorMessage ~= 0 )
        succes = EYL_RECORDING_NOTSTARTED;
        return;
    end
  
    eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    if eye_used == el.BINOCULAR; % if both eyes are tracked
        eye_used = el.LEFT_EYE; % use left eye
    end

        % Wait until all keys on keyboard are released:
    while KbCheck;  end;
    
    