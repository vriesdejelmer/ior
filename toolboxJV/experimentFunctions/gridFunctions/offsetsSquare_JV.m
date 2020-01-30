%Function to detirmine coordinates of element based on gridtype,
        %individual distances and index
function [offsetX offsetY xIndex yIndex] = offsetsSquare(index,distance, width, height, jitter)
        
        index=index-1;
        
        xIndex = mod(index,width);
        yIndex = floor(index/width);
        x = xIndex+0.5;
        y = yIndex+0.5;
        
        normalX = x - (width/2);
        normalY = y - (height/2);

            %add jitter
        jitterX = rand(1) * jitter * sign(rand(1)-0.5);
        jitterY = rand(1) * jitter * sign(rand(1)-0.5);
        
        offsetY = (normalY+jitterY) * distance;
        offsetX = (normalX+jitterX) * distance;