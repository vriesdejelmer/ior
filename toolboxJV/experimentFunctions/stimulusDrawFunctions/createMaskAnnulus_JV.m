function [stimulusScreen stimDescription] = createMask(resolutionX,resolutionY,expProps);

constantsSacExp;

stimDescription = ['x' 9 'y' 9 'el' 13];

stimSize= expProps.stimSize;

distance = expProps.distance/expProps.maskLumDenseFactor;
gridWidth = expProps.gridWidth *expProps.maskLumDenseFactor;
gridHeight = expProps.gridHeight *expProps.maskLumDenseFactor-2;
numbElements = gridWidth * gridHeight;

stimulusScreen = ones(resolutionY,resolutionX) *0.5;      %Maak een nieuw plaatje aan

centerX = resolutionX/2;
centerY = resolutionY/2;

[elements] = loadImages(stimSize,expProps);

for h=1:numbElements;
        
        [offsetX offsetY] = offsetsSquare(h,distance,gridWidth, gridHeight,expProps.maskLumJitterRange);
        element(:,:) = elements(ceil(rand(1)*expProps.maskContrasts),:,:) * sign(rand(1)-0.5);
        stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, element);
        
        
end

stimulusScreen(stimulusScreen > 1) = 1;
stimulusScreen(stimulusScreen < 0) = 0;

    
function [elements] = loadImages(stimSize,expProps)

    constantsSacExp;

    ring = annulus(stimSize * 2.3);
      
    max(max(ring * (expProps.maskContrastBase * 10+ expProps.maskContrastOffset)))
    
    for( u = 1:expProps.maskContrasts)
        elements(u,:,:) = ring * (expProps.maskContrastBase * u+ expProps.maskContrastOffset);
    end