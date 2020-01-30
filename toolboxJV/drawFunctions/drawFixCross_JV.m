function [w] = drawFixCross_JV(w,trialInf,expProps,fgColor) 

if( nargin < 4 )
    fgColor = expProps.foregroundColor;
end

Screen('FillOval', w, fgColor , [trialInf.startX-expProps.radiusOutFix trialInf.startY-expProps.radiusOutFix trialInf.startX+expProps.radiusOutFix trialInf.startY+expProps.radiusOutFix]);
Screen('FillOval', w, expProps.backgroundColor, [trialInf.startX-expProps.radiusInFix trialInf.startY-expProps.radiusInFix trialInf.startX+expProps.radiusInFix trialInf.startY+expProps.radiusInFix]);
    