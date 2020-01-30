%% Test script for excel write (xlwrite in OS X)


%  javaaddpath('jxl.jar');
%  javaaddpath('MXL.jar');
% 
%  import mymxl.*;
%  import jxl.*;   
% 
 d = {'Time','Temperature'; 12,98; 13,99; 14,97};
 
 xlwrite('mat1_excel.xls',d)