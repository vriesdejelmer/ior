%Function to detirmine coordinates of element based on gridtype,
        %individual distances and index
function [offsetX offsetY] = offsetsSquareTranspose(index,distance, width, height, jitter)
        
        index=index-1;
        y = mod(index,height)+0.5;
        x = floor(index/height)+0.5;
        
        normalX = x - (width/2);
        normalY = y - (height/2);

            %add jitter
        jitterX = rand(1) * jitter;
        jitterY = rand(1) * jitter;
        
        offsetY = (normalY+jitterY) * distance;
        offsetX = (normalX+jitterX) * distance;