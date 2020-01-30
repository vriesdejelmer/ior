        %Plaats een element
function displayMatrix = drawCombColoredSymbol(displayMatrix, x, y, gabor,rg,conv,convCompl)
    
    stimulusSize = size(gabor);
        
    x1 = round(x-stimulusSize(2)/2);
    x2 = round(x+(stimulusSize(2)/2)-1);
    y1 = round(y-stimulusSize(1)/2);
    y2 = round(y+(stimulusSize(1))/2-1);
    
    shapeRed = conv .*gabor * rg(1) + convCompl .* displayMatrix( y1:y2, x1:x2,1);
    shapeGreen = conv .*gabor * rg(2) + convCompl .* displayMatrix( y1:y2, x1:x2,2);

    displayMatrix( y1:y2, x1:x2, 1) = shapeRed;
    displayMatrix( y1:y2, x1:x2, 2) = shapeGreen;
