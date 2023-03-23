
function [pentad, month]=pentacal(jday)

pentad=floor( (jday-1)/(360*5) );

month=floor( (jday-pentad*360*5-1)/30)+1;
