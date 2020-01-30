function [rotatedX rotatedY] = rotateAroundPoint(x,y,radRotation,pivotX,pivotY)

    x = x-pivotX;
    y = y-pivotY;
    
    rotatedX = x.*cos(radRotation) - y.*sin(radRotation);
    
    rotatedY = x.*sin(radRotation) + y.*cos(radRotation);
    
    rotatedX = rotatedX+pivotX;
    rotatedY = rotatedY+pivotY;
    
end

