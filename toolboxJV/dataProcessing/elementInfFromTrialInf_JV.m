function [ xPositions yPositions elements] = elementInfFromTrialInf_JV( trialInf )

    if( isfield(trialInf,'elements') )
        elements = trialInf.elements;
        xPositions = trialInf.xPositions;
        yPositions = trialInf.yPositions;
    else
        elements = [];
        xPositions = [];
        yPositions = [];
    
    end

end

