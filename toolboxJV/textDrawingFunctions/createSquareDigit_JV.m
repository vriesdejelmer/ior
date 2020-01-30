function symbol = createSquareDigit(bools, stimHeight,lineWidth,widthFactor)
    
    if( nargin < 3 )
        lineWidth = ceil(stimHeight/10);
        widthFactor = 2/3;
    end
    
    halfWidth = ceil(lineWidth/2);

    stimWidth = ceil(stimHeight*widthFactor);
    symbol = zeros(stimHeight,stimWidth);
    
    if bools(1)
        symbol(1:lineWidth,1:stimWidth) = 1;
    end
    if bools(2)
        symbol(stimHeight/2-halfWidth+1:stimHeight/2+halfWidth,1:stimWidth) = 1;
    end
    if bools(3)
        symbol(stimHeight-lineWidth+1:stimHeight,1:stimWidth) = 1;
    end
    if bools(4)
        symbol(1:stimHeight/2,1:lineWidth) = 1;
    end
    if bools(5)
        symbol(1:stimHeight/2,(stimWidth-lineWidth+1):stimWidth) = 1;
    end
    if bools(6)
        symbol(stimHeight/2:stimHeight,1:lineWidth) = 1;
    end
    if bools(7)
        symbol(stimHeight/2:stimHeight,(stimWidth-lineWidth+1):stimWidth) = 1;
    end