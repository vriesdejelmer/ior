function [slope intercept] = linearRegressionLine(x_data,y_data)

n = length(x_data);

slope =  (sum(x_data.*y_data) - (sum(x_data)*sum(y_data))/n)/(sum(x_data.^2)-sum(x_data)^2/n)
intercept = (sum(y_data) - slope*(sum(x_data)))/n