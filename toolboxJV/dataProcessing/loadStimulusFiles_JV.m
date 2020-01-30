function [ experimentMessages ] = loadStimulusFiles_JV(stimDir,experimentMessages)

    stimFiles = dir(stimDir);

    fileNames = {stimFiles.name};
    matchingNameArray = regexp(fileNames,['(\w+)' zerroPad_JV(1,3) '.txt'],'match')
    fileName = char(matchingNameArray{find(~cellfun(@isempty,matchingNameArray))});
    
    for(u = 1:length(experimentMessages))
        experimentMessages(u).trialid;
        [xPos yPos elType] = loadStimulusFiles_JV.m([stimDir fileName]);
        experimentMessages(u).elementPosX = xPos;
        experimentMessages(u).elementPosY = yPos;
        experimentMessages(u).elementType = elType;
        
    end

end

