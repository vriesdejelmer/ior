function [trialInf] = addPositionInf_JV(trialInf,xPositions,yPositions,elements,radPositions)

    if( isfield(trialInf,'xPositions') )
        trialInf.xPositions = [trialInf.xPositions; xPositions]; 
        trialInf.yPositions = [trialInf.yPositions; yPositions];
        trialInf.elements = [trialInf.elements; elements];

        if( nargin == 5 )
            trialInf.radPositions = [trialInf.radPositions; radPositions];
        end

    else
        trialInf.xPositions = xPositions; 
        trialInf.yPositions = yPositions;
        trialInf.elements = elements;

        if( nargin == 5 )
            trialInf.radPositions = radPositions;
        end

    end
    
