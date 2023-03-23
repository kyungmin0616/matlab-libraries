function [year, month, day, a]=ctana_date_datenum(time,varargin);

if nargin > 1
   a=varargin{1};
end

  year=str2num( datestr(time,10) );
  month=str2num( datestr(time,5) );
  day=str2num( datestr(time,7) );
  a.year=year;
  a.month=month;
  a.day=day;