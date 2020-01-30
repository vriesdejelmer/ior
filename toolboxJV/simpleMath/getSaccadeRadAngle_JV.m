function [radianList] = getSaccadeRadAngle_JV(allFixations,selection)

    radianList = getRadFromCoords_JV(allFixations.xVect(selection), allFixations.yVect(selection));

    