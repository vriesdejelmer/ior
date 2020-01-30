%Function to determine coordinates of element based on gridtype,
        %individual distances and index
function [offsetX offsetY] = gridOffsetHex(index,distance,width, height,jitterRange)
                           
        stepX = distance;
        stepY = sqrt(power(stepX,2) - power(stepX/2,2));

        deltaY = ((height+1)/2) * stepY;
        deltaX = (width/2) * stepX;
        
        x = mod(index,width);
        y = ceil(index/width);

        offsetY = (y*stepY) - deltaY;
        offsetX = (x*stepX) + stepX/4 + mod(y,2) * stepX/2 - deltaX;
            %Option to add some jitter
        offsetY = offsetY + (rand(1) -0.5)*distance * jitterRange;
        offsetX = offsetX + (rand(1) -0.5)*distance * jitterRange;