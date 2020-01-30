function [] = drawGausBlob_JV(w,stimSize,centerX,centerY,stimProps);

gaussianBlob = mkGaussian(stimSize,stimSize/2,[],stimProps.contrast*0.5) + 0.5;
gaussBlobTexture = Screen('MakeTexture',w,gaussianBlob*255);
Screen('DrawTexture',w,gaussBlobTexture,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2]);

