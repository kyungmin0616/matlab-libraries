function [RMS]=rms(data1,data2)

%  This function computes the roor mean squared value between two
%  arrays.

RMS=sqrt(mean((data1(:)-data2(:)).^2));

return
