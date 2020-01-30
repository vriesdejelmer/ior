function [sigmoidParameters] = fitSigmoid(xData,yData, guessA, guessB, guessC)

    a = guessA;
    b = guessB;
    c = guessC;

    if( length(xData) ~= length(yData) )
        disp('Arrays must be of same length');
        return;
    end
    
    sumSquaredError = calculateSquaredErrors(xData,yData,a,b,c);


function [sumSquaredError] = calculateSquaredErrors(xData,yData, a,b,c)

    sumSquaredError = 0;
    for(u = 1:length(xData))
        yPrediction = sigmoid(xData(u),a,b,c);
        sumSquaredError = sumSquaredError + (yPrediction-yData(u))^2;
    end
    
    
    
function [output] = sigmoid(xPoint, a,b,c)

    output = c*1/(1+exp(-b*(xPoint-a)));