function stim = annulusEllipse(width, height, amplitude)

if( nargin < 3 )
    amplitude = 0.5;
end

baseEllipses = 40;

widthScaled = width * 1.7;
heightScaled = height * 1.7;

thickness = height/5;
stepSize = thickness/40;

centerY = heightScaled/2;

base = mkGaussian([1 baseEllipses*2+1],height,[1 baseEllipses+1],amplitude);
base(1) = 0;
base(end) = 0;

indices = -baseEllipses*stepSize:stepSize:baseEllipses*stepSize;

focus1 = []; focus2 = []; distance = [];

length(indices)
for(u=1:length(indices))
    
    ellipseNum = indices(u);
    
    a = width/2 + ellipseNum;
    b = height/2 + ellipseNum;
    f = sqrt(a^2 - b^2);
    
    focus1 = [focus1; widthScaled/2-f centerY];
    focus2 = [focus2; widthScaled/2+f centerY];
    distance = [distance; (a*2)];
    
    
end

for( u = 1:widthScaled )
    for( v = 1:heightScaled )    
        distancePerEllipse = abs(distance - (sqrt((u-focus1(:,1)).^2+(v-focus1(:,2)).^2) + sqrt((u-focus2(:,1)).^2+(v-focus2(:,2)).^2)));
        [mi ind] = min(distancePerEllipse);
        stim(v,u) = base(ind);
    end
end
