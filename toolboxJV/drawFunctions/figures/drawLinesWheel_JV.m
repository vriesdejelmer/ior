function [] = drawSpokeIllusion(w,stimSize,centerX,centerY,numbSpokes,thickness);

spokeLength = stimSize/2-thickness/2;

listOfPIs = [1/6 8/6 2/6 7/6 4/6 11/6 5/6 10/6];

for(u=1:length(listOfPIs)/2)
    radStart = listOfPIs((u*2)-1)*pi;
    radEnd = listOfPIs(u*2)*pi;
    yStart = sin(radStart) * spokeLength;
    xStart = cos(radStart) * spokeLength;
    yEnd = sin(radEnd) * spokeLength;
    xEnd = cos(radEnd) * spokeLength;
    if( u == 1)
        linesWheel = [xStart xEnd; yStart yEnd];
    else
        linesWheel(:,end+1:end+2) = [xStart xEnd; yStart yEnd];
    end
end

Screen('DrawLines',w,linesWheel,min([thickness 7]),[],[centerX centerY]);
Screen('FrameOval',w,[],[centerX-stimSize/2 centerY-stimSize/2 centerX+stimSize/2 centerY+stimSize/2],thickness);