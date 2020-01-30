function [colorTriple] = fromNum2RGB(colorNumber)

    if(colorNumber == 1)
        colorTriple = [255 0 0];
    elseif(colorNumber == 2)
        colorTriple = [0 255 0];
    elseif(colorNumber == 3)
        colorTriple = [0 0 255];
    elseif(colorNumber == 0)
        colorTriple = [255 255 255];
    end