

function arr = datestr2(time)
% function arr = datestr2(time)
% time is in datenum format, returns
% arr.day, arr.month, arr.year
% edl@ucsd.edu - Oct. 2003

arr.month = str2num(datestr(time,5));
arr.year = str2num(datestr(time,10));
arr.day = str2num(datestr(time,7));
