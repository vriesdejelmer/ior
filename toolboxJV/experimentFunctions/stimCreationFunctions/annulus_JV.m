function stim = annulus(stimSize, amplitude)

if( nargin < 2 )
    amplitude = 0.5;
end

stimSizePadded = stimSize * 1.7;
maxDistance = sqrt(2*(stimSizePadded/2)^2);

base = mkGaussian([1 maxDistance+5],stimSize/2,[1 stimSize/2],amplitude);

stim = zeros(stimSize);

for u = 1:stimSizePadded
    for v = 1:stimSizePadded
        stim(u,v) = sqrt((u-stimSizePadded/2)^2 + (v-stimSizePadded/2)^2);
        stim(u,v) = base( round(stim(u,v))+1 );
    end
end

