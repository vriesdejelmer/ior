function [stimulusScreen stimDescription] = createStimulus(resolutionX,resolutionY,expProps,condition,order);

constantsSacExp;

stimDescription = ['x' 9 'y' 9 'el' 13];

stimSize= expProps.stimSize;

stimulusScreen = ones(resolutionY,resolutionX) *0.5;      %Maak een nieuw plaatje aan

centerX = resolutionX/2;
centerY = resolutionY/2;

ring = annulus(stimSize * 2.3);

if( condition == CONDITION_MOST_MIDDLE_SALIENT )
    targetAngle = expProps.highAngle;
    distractorAngle = expProps.mediumAngle;
elseif( condition == CONDITION_MOST_LEAST_SALIENT )
    targetAngle = expProps.highAngle;
    distractorAngle = expProps.lowAngle;
elseif( condition == CONDITION_MIDDLE_LEAST_SALIENT )
    targetAngle = expProps.mediumAngle;
    distractorAngle = expProps.lowAngle;
    
    
elseif( condition == CONDITION_MOST_SALIENT )
    targetAngle = expProps.highAngle;
    distractorAngle = 0;
elseif( condition == CONDITION_MIDDLE_SALIENT )
    targetAngle = expProps.mediumAngle;
    distractorAngle = 0;
elseif( condition == CONDITION_LEAST_SALIENT )
    targetAngle = expProps.lowAngle;
    distractorAngle = 0;
end

[element target distractor] = loadImages(stimSize,expProps,targetAngle,distractorAngle);

for h=1:expProps.numbElements;

        if h == 29 
            typeSelection = order(1);
        elseif h == 32
            typeSelection = order(2);
        elseif h == 58 
            typeSelection = order(3);
        elseif h == 94 
            typeSelection = order(4);
        elseif h == 116 
            typeSelection = order(5);
        elseif h == 113 
            typeSelection = order(6);
        elseif h == 87 
            typeSelection = order(7);
        elseif h == 51
            typeSelection = order(8);            
        else
            typeSelection = ALTERN;
        end

        
        [offsetX offsetY] = offsetsSquare(h,expProps.distance,expProps.gridWidth, expProps.gridHeight,expProps.oriJitterRange);
        
        
        if( typeSelection == ALTERN )
            stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, element);
        elseif( typeSelection == TARGET )
            stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, target);
            stimDescription = [stimDescription num2str(centerX+offsetX) 9 num2str(centerY+offsetY) 9 num2str(typeSelection) 13 ];
        elseif( typeSelection == DISTRACTOR )
            stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, distractor);
            stimDescription = [stimDescription num2str(centerX+offsetX) 9 num2str(centerY+offsetY) 9 num2str(typeSelection) 13 ];
        end

%         
%         if( (condition == CONDITION_HIGH_SALIENT & typeSelection == TARGET) || (condition == CONDITION_HIGH_NON_SALIENT & typeSelection == DISTRACTOR)) 
%              stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, ring*expProps.highContrast);
%         elseif( (condition == CONDITION_LOW_NON_SALIENT & typeSelection == DISTRACTOR) || (condition == CONDITION_LOW_SALIENT & typeSelection == TARGET)  ||  (condition == CONDITION_HIGH_SALIENT & typeSelection == DISTRACTOR) || (condition == CONDITION_HIGH_NON_SALIENT & typeSelection == TARGET))
%              stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, ring*expProps.mediumContrast);
%         elseif( (condition == CONDITION_LOW_SALIENT & typeSelection == DISTRACTOR) || (condition == CONDITION_LOW_NON_SALIENT & typeSelection == TARGET))
%              stimulusScreen = drawSymbol(stimulusScreen, centerX+offsetX, centerY+offsetY, ring*expProps.lowContrast);
%         end
% 
        
end

stimulusScreen(stimulusScreen > 1) = 1;

    
function [element target distractor] = loadImages(stimSize,expProps,targetAngle,distractorAngle)

    constantsSacExp;

%    padding = expProps.gausSize;
    offsetX = stimSize/4;
    offsetY = 3*(stimSize/7);
    
%     matr = ones(stimSize+padding);
%     matr(offsetX+1:stimSize+padding-offsetX,offsetY+1:stimSize+padding-offsetY) = 0;
%     
%     element= conv2(matr,mkGaussian(expProps.gausSize,expProps.sigma1)-mkGaussian(expProps.gausSize,expProps.sigma2),'valid');
%     scaleFactor = 0.35/max(max(abs(element)));
%     element = element .*scaleFactor;


    matr = zeros(stimSize);
    matr(offsetX+1:stimSize-offsetX,offsetY+1:stimSize-offsetY) = 0.5;
    element = matr;
    
    target = imrotate(element,targetAngle * sign(rand(1)-0.5),'loose');
	distractor = imrotate(element,distractorAngle * sign(rand(1)-0.5),'loose');
    element = imrotate(element,expProps.elementAngle,'loose');
%     rmsContrast(imLoPass,stimSize)
% 
%     imHighPass=filter2(mkGaussian(50,4)-mkGaussian(50,3),matr,'valid');
%     rmsContrast(imHighPass,stimSize)
% 
%     factor = rmsContrast(imHighPass,stimSize)/rmsContrast(imLoPass,stimSize)*2; %370

%    scaling = 128;
%         selection = SquareLL < 0.001 & SquareLL > -0.001;
%         SquareLL(selection) = 0;
%         selection = SquareLH < 0.001 & SquareLH > -0.001;
%         SquareLH(selection) = 0;
%         
%     end
%     
    
% function rms = rmsContrast(image, stimSize)
%     mean(mean(image));
% 
%     normImage = image - mean(mean(image));
%     normImage = power(normImage,2);
%     rmsSquare = sum(sum(normImage)) / ((stimSize * stimSize) -1);
%     rms = sqrt(rmsSquare);
% 
%     