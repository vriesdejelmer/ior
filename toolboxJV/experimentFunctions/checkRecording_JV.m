    error=Eyelink('checkrecording'); 		
    if(error~=0)
        succes=EYL_RECORDING_INTERRUPT;
        return;
    end