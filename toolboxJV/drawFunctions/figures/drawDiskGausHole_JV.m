function [] = drawSpokeIllusion(w,stimSize,centerX,centerY,numbSpokes);

spokeLength = stimSize/2;

circleShape = Circle(spokeLength)*0.5 + 0.5;
gaussianDip = mkGaussian(spokeLength*2,spokeLength*10,[],0.5);
gaussianDip(circleShape == 0.5) = 0;
gaussianCenterWheel = circleShape - gaussianDip;
gaussWheelTexture = Screen('MakeTexture',w,gaussianCenterWheel*255);
Screen('DrawTexture',w,gaussWheelTexture,[],[centerX-spokeLength centerY-spokeLength centerX+spokeLength centerY+spokeLength]);

