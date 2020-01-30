function [] = drawEllipsoid_JV(w,horDiam,verDiam,centerX,centerY,rotationAngle,thickness)

baseEllipse = Ellipse(horDiam/2,verDiam/2);
smallerEllipse = Ellipse(horDiam/2-thickness,verDiam/2-thickness);
smallerEllipse = (1-smallerEllipse)-1;
ellipseMat = drawSymbol_JV(baseEllipse, horDiam/2+1, verDiam/2+1, smallerEllipse);
ellipseTexture = Screen('MakeTexture',w,ellipseMat*127.5);
Screen('BlendFunction',w,GL_ONE,GL_ONE);
Screen('DrawTexture',w,ellipseTexture,[],[centerX-horDiam/2 centerY-verDiam/2 centerX+horDiam/2 centerY+verDiam/2],rotationAngle);
Screen('BlendFunction',w,GL_ONE,GL_ZERO);

