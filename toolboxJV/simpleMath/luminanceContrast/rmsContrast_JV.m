function rms = rmsContrast(image, stimSize)
    mean(mean(image));

    normImage = image - mean(mean(image));
    normImage = power(normImage,2);
    rmsSquare = sum(sum(normImage)) / (stimSize * stimSize);
    rms = sqrt(rmsSquare);