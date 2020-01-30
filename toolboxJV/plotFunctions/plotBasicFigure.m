function figHandle = plotBasicFigure(figureProps,index)
%%plotBasicFigure allows for the plot of a basic figure with less hastle. Does it really?
% figureProps(1).xData
% figureProps(1).yData

if( ~isfield(figureProps,'figHandle') )
    figHandle = figure;
else
    figure(figureProps(1).figHandle);
end

if( nargin > 1 )
    subplot(figureProps(1).height,figureProps(1).width,index);
end

if( ~isfield(figureProps,'lineColors') )
    figureProps(1).lineColors = {'b','r','g','k','c','m','y'};
end
if( ~isfield(figureProps,'lineType') )
    figureProps(1).lineType = '-';
end
if( ~isfield(figureProps,'lineWidth') )
    figureProps(1).lineWidth = 1;
end

if( ~isfield(figureProps,'fontSize') )
    figureProps(1).fontSize = 14;
end
if( ~isfield(figureProps,'titleFontSize') )
    figureProps(1).titleFontSize = figureProps(1).fontSize;
end
if( ~isfield(figureProps,'labelFontSize') )
    figureProps(1).labelFontSize = figureProps(1).fontSize;
end
if( ~isfield(figureProps,'tickFontSize') )
    figureProps(1).tickFontSize = figureProps(1).fontSize;
end

lineColors = figureProps.lineColors;

for( u = 1:length(figureProps) )
    if( isfield(figureProps, 'figureType') && strcmpi(figureProps.figureType,'bar') )        
        lineHandle = bar(figureProps(u).xData,figureProps(u).yData),[lineColors{u}];
        hold on;
        if( isfield(figureProps,'errorData') & isfield(figureProps,'xErrorData') )
            errorbar(figureProps(u).xErrorData,figureProps(u).yData,figureProps(u).errorData,'LineWidth', [lineColors{u} '.'],figureProps(1).lineWidth);
        end
    else
        lineHandle(u) = plot(figureProps(u).xData,figureProps(u).yData,[lineColors{u} figureProps(u).lineType],'LineWidth',figureProps(1).lineWidth);
        hold on;
        if( isfield(figureProps,'errorData') )
            errorbar(figureProps(u).xData,figureProps(u).yData,figureProps(u).errorData, [lineColors{u} '.'],'LineWidth',figureProps(1).lineWidth);
        end
    end
    
end

if( isfield(figureProps,'xLabel') )
    xlabel(figureProps(1).xLabel,'FontSize',figureProps(1).labelFontSize);
end
if( isfield(figureProps,'yLabel') )
    ylabel(figureProps(1).yLabel,'FontSize',figureProps(1).labelFontSize);
end
if( isfield(figureProps,'axis') )
    axis(figureProps(1).axis);
end

if( isfield(figureProps,'xTicks') )
    set(gca, 'Xtick',figureProps.xTicks);
end
if( isfield(figureProps,'xTickLabels') )
    set(gca, 'XtickLabel',figureProps.xTickLabels,'FontSize',figureProps.tickFontSize);
end
if( isfield(figureProps,'legendEntries') )
    legend(lineHandle,figureProps(1).legendEntries);
end

if( isfield(figureProps,'title') )
    title(figureProps.title,'FontSize',figureProps.titleFontSize); 
end