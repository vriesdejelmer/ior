    %Plaats een element
function displayMatrix = drawAppertureSymbol(displayMatrix, x, y, element)

    stimulusSize = size(element);
    gaus = circle(round(stimulusSize(1)/3));
    
    gaus = drawSymbol(zeros(stimulusSize),stimulusSize/2,stimulusSize/2,gaus);
    
    gausCompl = 1 - gaus;
    
    x1 = round(x-stimulusSize(2)/2);
    x2 = round(x+(stimulusSize(2)/2)-1);
    y1 = round(y-stimulusSize(1)/2);
    y2 = round(y+(stimulusSize(1))/2-1);
    
    shape = gaus .*element + gausCompl .* displayMatrix( y1:y2, x1:x2 );

    displayMatrix( y1:y2, x1:x2 ) = shape;