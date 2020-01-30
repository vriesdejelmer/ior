function [] = drawSpokeWheel(w,stimSize,centerX,centerY,numbSpokes,thickness);

spokeLength = stimSize/2-thickness/2;

for(u=1:numbSpokes)
    radStart = (pi/numbSpokes)*(u-1);
    y = sin(radStart) * spokeLength;
    x = cos(radStart) * spokeLength;
    if( u == 1)
        linesSpokeWheel = [x -x; y -y]
    else
        linesSpokeWheel(:,end+1:end+2) = [x -x; y -y];
    end
end

Screen('DrawLines',w,linesSpokeWheel,min([thickness 7]),[],[centerX centerY]);
Screen('FrameOval',w,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2],thickness);