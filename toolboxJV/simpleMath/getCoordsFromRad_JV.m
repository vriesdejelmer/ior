function [elementX elementY] = getCoordsFromRad_JV(radPosition,distance,startX,startY);
    
    if( nargin < 4 )
        startX = 0;
        startY = 0;
    end
    elementY = sin(radPosition) * distance + startY;
    elementX = cos(radPosition) * distance + startX;
    
