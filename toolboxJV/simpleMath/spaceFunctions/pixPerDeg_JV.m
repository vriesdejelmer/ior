cmPerDeg    = tand(1)*expProps.disToScreen;
pixelPerCM  = expProps.horRes/expProps.screenWidth;
pixPerDeg   = pixelPerCM*cmPerDeg;
