function [intensity] = intensityFromContrast_JV(weberContrast,expProps) 

intensity = weberContrast * expProps.backgroundColor + expProps.backgroundColor;