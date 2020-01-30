    %save the information pertinent to this trial.
trialInfo.condition = condition;
trialInfo.succes    = succes;
if( exist('subCondition') ) 
    trialInfo.subCondition = subCondition;
end    


    %save the information pertinent to this trial.
trialInfo = orderfields(trialInfo);

if( succes == EYL_RECORDING_COMPLETE ) 
    if( ~exist('trialInformation') )
        trialInformation(1) = trialInfo;
    else
            %adds empty fields to trialInfo when fields are missing
        missingFields = setdiff(fieldnames(trialInformation),fieldnames(trialInfo));
        if( length(fieldnames(trialInfo)) < length(fieldnames(trialInformation)) && ~isempty(missingFields) )
            disp('Warning trial information for a trial has not been stored correctly, this line should not appear often');
            for( uu = 1:length(missingFields) )
                trialInfo = setfield(trialInfo, missingFields{uu}, []);
            end
                %reorder everything
            trialInfo = orderfields(trialInfo);
        end
        trialInformation(end+1) = trialInfo;
    end
    save(['../' expProps.stimDir 'trialInformation'],'trialInformation');
end


trialInfo = [];