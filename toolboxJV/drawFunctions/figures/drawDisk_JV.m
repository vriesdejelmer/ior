function [] = drawSpokeIllusion(w,stimSize,centerX,centerY,numbSpokes,thickness);

Screen('FillOval',w,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2]);