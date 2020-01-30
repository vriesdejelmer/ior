function [] = drawGabor_JV(w,stimSize,centerX,centerY,gaborProps);

gaborEl = gabor_JV([gaborProps.stimSize gaborProps.stimSize],gaborProps.cyclesPer100,gaborProps.orientation,gaborProps.gaborPhase,gaborProps.gaborSigma,gaborProps.mean,gaborProps.gaborAmpl);

gaborTexture = Screen('MakeTexture',w,gaborEl*255);
Screen('DrawTexture',w,gaborTexture,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2]);
