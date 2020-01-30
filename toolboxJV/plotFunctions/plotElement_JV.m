function [] = plotElement_JV(elementX,elementY,elementProps)

constantsSacExp_JV;

lineThickness = 3;

if( elementProps.type == TARGET ) color = [0 1 0];
elseif( elementProps.type == DISTRACTOR ) color = [1 0 0];
elseif( elementProps.type == ALTERN ) color = [0 0 1];
elseif( elementProps.type == ALTERN2 ) color = [1 1 0];
elseif( elementProps.type == EMPTY ) color = [0 0 0];
else color = [0 0 0];
end

if( isfield(elementProps,'shapeType') & strcmpi(elementProps.shapeType,'ellipse') )
    %vervangen voor ellipse functie....
    circleX = 0:0.1:(2*pi+0.1);
    plot(cos(circleX)*elementProps.horDiam/2+elementX,sin(circleX)*elementProps.verDiam/2+elementY,'Color',color,'LineWidth',lineThickness);
else
    circleX = 0:0.1:(2*pi+0.1);

    if isfield(elementProps,'stimSize'), stimSize = elementProps.stimSize;
    else stimSize = 20; end
    plot(cos(circleX)*stimSize/2+elementX,sin(circleX)*stimSize/2+elementY,'Color',color,'LineWidth',lineThickness);
end