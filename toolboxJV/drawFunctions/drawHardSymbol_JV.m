    %Plaats een element
function displayMatrix = drawPositiveSymbol(displayMatrix, x, y, element)

    stimulusSize = size(element);
    
    x1 = round(x-stimulusSize(2)/2);
    x2 = round(x+(stimulusSize(2)/2)-1);
    y1 = round(y-stimulusSize(1)/2);
    y2 = round(y+(stimulusSize(1))/2-1);
    
    displayMatrix( y1:y2, x1:x2 ) = element(element > 0);