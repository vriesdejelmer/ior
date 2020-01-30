function [grating] = gratingOnBlack_JV(stimSize,cov,cyclesPer100Pix,orientation,phase,ampl)

X = ones(stimSize,1)*[-(stimSize-1)/2:1:(stimSize-1)/2];
Y =[-(stimSize-1)/2:1:(stimSize-1)/2]' * ones(1,stimSize);

cosIm = (cos(2.*pi.*(cyclesPer100Pix/100).* (cos(deg2rad_JV(orientation)).*X + sin(deg2rad_JV(orientation)).*Y) - phase*ones(stimSize) ) +1)/2; 
y = mkGaussian([stimSize stimSize],cov,floor(stimSize/2));
y = y.*1/max(max(y));
grating = y.*cosIm*ampl;