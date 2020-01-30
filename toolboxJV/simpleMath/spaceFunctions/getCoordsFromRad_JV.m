function [elementX elementY] = getCoordsFromRad_JV(radPosition,startX,startY,distance)
    
    elementY = sin(radPosition) * distance + startY;
    elementX = cos(radPosition) * distance + startX;
    
