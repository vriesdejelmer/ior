function imMatrix = loadLetter(letterName,stimSize)
    
    name = ['/Volumes/AIO_project/Experiments/toolbox/alphabet_caps/' letterName '.bmp'];
    matrLetter = imread(name);
    matrLetter = matrLetter(:,:,1)
    
    [x y] = find(matrLetter == 0);
        
    mx = round((min(x) + max(x))/2);
    my = round((min(y) + max(y))/2);

	for u=1:length(x)
        x(u) = x(u) - mx;
    end 

    for u=1:length(y)
        y(u) = y(u) - my;
    end

    matrixSize = size(matrLetter)
    
    width = max(x) - min(x);
    height = max(y) - min(y);
    
    imMatrix = zeros(width, height);

    for u=1:length(x)
        p = x(u)+round(width/2)+1;
        r = y(u)+round(height/2)+1;
        imMatrix( p, r ) = 1;
    end 
       
    imMatrix = imresize(imMatrix,[stimSize stimSize]);
end
