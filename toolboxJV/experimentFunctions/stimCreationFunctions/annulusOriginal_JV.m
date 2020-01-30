function stim = annulus(stimSize)

maxDistance = sqrt(2*(stimSize/2)^2);

base = mkGaussian([1 maxDistance+5],maxDistance/2,[1 round(maxDistance/3)]);

stim = zeros(stimSize);

for u = 1:stimSize
    for v = 1:stimSize
        stim(u,v) = sqrt((u-stimSize/2)^2 + (v-stimSize/2)^2);
        stim(u,v) = base( round(stim(u,v))+1 );
    end
end

stim = stim.*100;

