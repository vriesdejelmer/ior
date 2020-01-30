rt = round(toc*1000);
Eyelink('message', 'REACTION_TIME %d', rt); % log reaction time (always necesarry to mark the end of the trial
succes = EYL_RECORDING_COMPLETE;
WaitSecs(0.1);
Eyelink('StopRecording');
