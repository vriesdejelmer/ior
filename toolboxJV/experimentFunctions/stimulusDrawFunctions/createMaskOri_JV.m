function [stimulusScreen stimDescription] = createMask(resolutionX,resolutionY,expProps);

constantsSacExp;

stimDescription = ['x' 9 'y' 9 'el' 13];

stimSize= expProps.stimSize;

distance = expProps.distance/expProps.maskOriDenseFactor;
gridWidth = expProps.gridWidth *expProps.maskOriDenseFactor + 3;
gridHeight = expProps.gridHeight *expProps.maskOriDenseFactor;
numbElements = gridWidth * gridHeight;

stimulusScreen = ones(resolutionY,resolutionX) *0.5;      %Maak een nieuw plaatje aan

centerX = resolutionX/2;
centerY = resolutionY/2;

[elements] = loadImages(stimSize,expProps);

for h=1:numbElements;
        
        [offsetX offsetY] = offsetsSquare(h,distance,gridWidth, gridHeight,expProps.maskOriJitterRange);
        element(:,:) = elements(ceil(rand(1)*expProps.maskOrientations),:,:) * sign(rand(1)-0.5);
        stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, element);
        
        
end

stimulusScreen(stimulusScreen > 1) = 1;
stimulusScreen(stimulusScreen < 0) = 0;

    
function [elements] = loadImages(stimSize,expProps)

    constantsSacExp;

    offsetX = stimSize/4;
    offsetY = 3*(stimSize/7);

    matr = zeros(stimSize);
    matr(offsetX+1:stimSize-offsetX,offsetY+1:stimSize-offsetY) = 0.5;
    element = matr;
    
    for( u = 1:expProps.maskOrientations)
        elements(u,:,:) = imrotate(element,u*expProps.maskOrientationBase,'crop');
    end
     