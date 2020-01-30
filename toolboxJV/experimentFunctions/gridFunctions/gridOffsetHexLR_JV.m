%Function to determine coordinates of element based on gridtype,
        %individual distances and index
function [offsetX offsetY] = gridOffsetHexLR(index,distance,width, height,jitterRange)

        index = index - 1;

        stepX = distance;
        stepY = sqrt(power(stepX,2) - power(stepX/2,2));

        x = mod(index,width)+1;
        y = floor(index/width)+1;
        
        deltaY = ((height+1)/2) * stepY;
        deltaX = (width/2+1) * stepX;
   
        offsetY = (y*stepY) - deltaY;
        offsetX = (x*stepX) + stepX/4 + mod(y,2) * stepX/2 - deltaX;
            
            %Option to add some jitter
        offsetY = offsetY + (rand(1) -0.5)*distance * jitterRange;
        offsetX = offsetX + (rand(1) -0.5)*distance * jitterRange;