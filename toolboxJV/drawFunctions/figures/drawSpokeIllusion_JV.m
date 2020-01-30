function [] = drawSpokeIllusion(w,stimSize,centerX,centerY,numbSpokes,thickness);

spokeLength = stimSize/2-thickness;

for(u=1:numbSpokes*2)
    radStart = (pi/numbSpokes)*(u-1);
    y = sin(radStart) * spokeLength;
    x = cos(radStart) * spokeLength;
    if( u == 1)
        linesSpokeIllusion = [x x/2; y y/2]
    else
        linesSpokeIllusion(:,end+1:end+2) = [x x/2; y y/2];
    end
end

Screen('DrawLines',w,linesSpokeIllusion,min([thickness 7]),[],[centerX centerY]);
Screen('FrameOval',w,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2],thickness);