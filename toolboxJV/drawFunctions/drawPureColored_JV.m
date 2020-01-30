
        %%DEZE IS FOUTIEF
%Plaats een element
function displayMatrix = drawPureColoredSymbol(displayMatrix, x, y, gabor,color)
    
    stimulusSize = size(gabor);

    x1 = round(x-stimulusSize(1)/2);
    x2 = round(x+(stimulusSize(1)/2)-1);
    y1 = round(y-stimulusSize(2)/2);
    y2 = round(y+(stimulusSize(2))/2-1);
    
    if( color == 0)
        displayMatrix( y1:y2, x1:x2, 1) = displayMatrix( y1:y2, x1:x2, 1) + gabor; 
        displayMatrix( y1:y2, x1:x2, 2) = displayMatrix( y1:y2, x1:x2, 2) + gabor; 
        displayMatrix( y1:y2, x1:x2, 3) = displayMatrix( y1:y2, x1:x2, 3) + gabor;
    else
        colors = [1 2 3];
        for v = 1:length(colors)
            if( color == colors(v) )
                displayMatrix( y1:y2, x1:x2, color) = displayMatrix( y1:y2, x1:x2, v) + gabor; 
            else
                displayMatrix( y1:y2, x1:x2, color) = displayMatrix( y1:y2, x1:x2, v) - gabor; 
                displayMatrix( y1:y2, x1:x2, color) = displayMatrix( y1:y2, x1:x2, v) - gabor; 
            end
        end
    end