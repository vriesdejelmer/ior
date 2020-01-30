        %Plaats een element
function displayMatrix = drawColoredSymbol(displayMatrix, x, y, gabor,color)
    
    if( nargin < 5 )
        color = 0;
    end

    stimulusSize = size(gabor);

    x1 = round(x-stimulusSize(1)/2);
    x2 = round(x+(stimulusSize(1)/2)-1);
    y1 = round(y-stimulusSize(2)/2);
    y2 = round(y+(stimulusSize(2))/2-1);
    
    if( length(color) == 3 )
        displayMatrix( y1:y2, x1:x2, 1) = displayMatrix( y1:y2, x1:x2, 1) + gabor * color(1); 
        displayMatrix( y1:y2, x1:x2, 2) = displayMatrix( y1:y2, x1:x2, 2) + gabor * color(2); 
        displayMatrix( y1:y2, x1:x2, 3) = displayMatrix( y1:y2, x1:x2, 3) + gabor * color(3);
    elseif( color == 0)
        displayMatrix( y1:y2, x1:x2, 1) = displayMatrix( y1:y2, x1:x2, 1) + gabor; 
        displayMatrix( y1:y2, x1:x2, 2) = displayMatrix( y1:y2, x1:x2, 2) + gabor; 
        displayMatrix( y1:y2, x1:x2, 3) = displayMatrix( y1:y2, x1:x2, 3) + gabor;
    else
        displayMatrix( y1:y2, x1:x2, color) = displayMatrix( y1:y2, x1:x2, color) + gabor; 
    end