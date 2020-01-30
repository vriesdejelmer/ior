function im = noiseGaussWindow_JV(vhSize, cyclesPer100Pix,orientation, phase, sigma , mean, amplitude)% draw  gabor patch% im = gabor(vhSize, cyclesPer100Pix, phase, sigma , mean, amplitude, orientation)% vhSize: size of pattern, [vSize hSize]% cyclesPer100Pix: cycles per 100 pixels% phase: phase of grating in degree% sigma: sigma of gaussian envelope% mean: mean color value% amplitude: amplitude of color value% orientation: orientation of grating, 0 -> horizontal, 90 -> vertical%% (c) Yukiyasu Kamitani`%% eg >>imshow(gabor([100 100], 8, 45, 0, 6 , 0.5, 0.5))X = ones(vhSize(1),1)*[-(vhSize(2)-1)/2:1:(vhSize(2)-1)/2];Y =[-(vhSize(1)-1)/2:1:(vhSize(1)-1)/2]' * ones(1,vhSize(2));    CosIm =  cos(2.*pi.*(cyclesPer100Pix/100).* (cos(deg2rad(orientation)).*X + sin(deg2rad(orientation)).*Y) - phase*ones(vhSize) );     %G = fspecial('gaussian', vhSize, sigma);     G = gaussianKernel([-(vhSize(1)-1)/2:1:(vhSize(1)-1)/2], sigma,[-(vhSize(2)-1)/2:1:(vhSize(2)-1)/2], sigma);     %G = G ./ (max(max(G))*(ones(vhSize))); 	% make the max 1    im = amplitude *  G.* CosIm + mean*ones(vhSize);    im(find(abs(im-mean) < amplitude/64)) = mean;  % remove 1-grayscale error 64->function rad = deg2rad(deg)rad = (deg/180)*pi;% Function "gauss.m":function g = gaussianKernel(u,sigma1,v,sigma2)x = meshgrid(v,u);y = ctranspose(meshgrid(u,v));g = exp(-( power(x,2)/(2*sigma1^2) + power(y,2)/(2*sigma2^2)) );