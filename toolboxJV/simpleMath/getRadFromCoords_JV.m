function [rad] = getRadFromCoords_JV(xDisp,yDisp)
    
    rad = atan(yDisp./xDisp);
        
        %Als de Y-waarde negatief is
    selectionNegativeY = (xDisp >= 0 & yDisp < 0);
    rad(selectionNegativeY) = 2*pi+rad(selectionNegativeY);
    
        %Als beide waardes negatief zijn
    selectionNegativeXY = (xDisp < 0 & yDisp < 0);
	rad(selectionNegativeXY) = rad(selectionNegativeXY)+pi;
    
        %Als de X-waarde negatief is
    selectionNegativeXY = (xDisp < 0 & yDisp >= 0);
    rad(selectionNegativeXY) = rad(selectionNegativeXY)+pi;
