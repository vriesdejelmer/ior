function [timeCost] = drawFigure_JV(w,stimProps,centerX,centerY)

tic;

if( strcmpi(stimProps.shapeType,'GaussianDip') )
    drawDiskGausHole_JV(w,stimSize,centerX,centerY,stimProps.numbSpokes);
elseif( strcmpi(stimProps.shapeType,'GaussianBlob') )
    drawGausBlob_JV(w,stimProps.stimSize,centerX,centerY,stimProps);
elseif( strcmpi(stimProps.shapeType,'Gabor') )
    drawGabor_JV(w,stimProps.stimSize,centerX,centerY,stimProps);
elseif( strcmpi(stimProps.shapeType,'SpokeIllusion') )
    drawSpokeIllusion_JV(w,stimSize,centerX,centerY,stimProps.numbSpokes,stimProps.thickness);
elseif( strcmpi(stimProps.shapeType,'SpokeWheel') )
    drawSpokeWheel_JV(w,stimProps.stimSize,centerX,centerY,stimProps.numbSpokes,stimProps.thickness);
elseif( strcmpi(stimProps.shapeType,'LinesWheel') )
    drawLinesWheel_JV(w,stimProps.stimSize,centerX,centerY,stimProps.numbSpokes,stimProps.thickness);
elseif( strcmpi(stimProps.shapeType,'Disc') )
    drawDisk_JV(w,stimProps.stimSize,centerX,centerY,stimProps.numbSpokes,stimProps.thickness);
elseif( strcmpi(stimProps.shapeType,'Ellipse') )
    drawEllipsoid_JV(w,stimProps.horDiam,stimProps.verDiam,centerX,centerY,stimProps.rotationAngle,stimProps.thickness)
elseif( strcmpi(stimProps.shapeType,'Triangle') )
    Screen('FillPoly',w,stimProps.color,[stimProps.point1X+centerX stimProps.point1Y+centerY; stimProps.point2X+centerX stimProps.point2Y+centerY; stimProps.point3X+centerX stimProps.point3Y+centerY]);
elseif( strcmpi(stimProps.shapeType,'Ring') )
    Screen('FrameOval',w,stimProps.color,[centerX-stimProps.stimSize/2 centerY-stimProps.stimSize/2 centerX+stimProps.stimSize/2 centerY+stimProps.stimSize/2],stimProps.thickness);
elseif( strcmpi(stimProps.shapeType,'orientedRing') )
    if( stimProps.clockwise )
        startFirstSegment = stimProps.offset+stimProps.gapSize;
        startSecondSegment = 180+stimProps.offset+stimProps.gapSize;
    else
        startFirstSegment = 0-stimProps.offset;
        startSecondSegment = 180-stimProps.offset;
    end
    
    Screen('FrameArc',w,stimProps.color,[centerX-stimProps.stimSize/2 centerY-stimProps.stimSize/2 centerX+stimProps.stimSize/2 centerY+stimProps.stimSize/2],startFirstSegment,(180 - stimProps.gapSize),stimProps.thickness);
    Screen('FrameArc',w,stimProps.color,[centerX-stimProps.stimSize/2 centerY-stimProps.stimSize/2 centerX+stimProps.stimSize/2 centerY+stimProps.stimSize/2],startSecondSegment,(180 - stimProps.gapSize),stimProps.thickness);
elseif( strcmpi(figureType,'C-Shape') )
    orientation = floor(rand(1)*360);
    Screen('FrameArc',w,stimProps.color,[centerX-stimProps.stimSize/2 centerY-stimProps.stimSize/2 centerX+stimProps.stimSize/2 centerY+stimProps.stimSize/2],stimProps.orientation,360-stimProps.numbSpokes,stimProps.thickness);
end

timeCost = toc;