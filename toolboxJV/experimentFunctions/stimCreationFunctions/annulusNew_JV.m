function stim = annulusNew_JV(radius, amplitude, covar, padding)

if( nargin < 4 )
    padding = 1.6;
end

maxDistance = sqrt(2*(radius)^2) * padding;

base = mkGaussian([1 maxDistance],covar,[1 radius],amplitude);
  
matrixSize = round(radius*padding*1.8);
stim = zeros(matrixSize);

for u = 1:matrixSize
    for v = 1:matrixSize
        stim(u,v) = sqrt((u-matrixSize/2)^2 + (v-matrixSize/2)^2);
        stim(u,v) = base( round(stim(u,v))+1 );
    end
end

