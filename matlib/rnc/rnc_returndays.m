

function [daysnum, days]=rnc_returndays(year,month)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% [daysnum, days]=rnc_returndays(year,month)
%
%  Returns the days of that month for the selected year
%
%      INPUT: YEAR, MONTH 
%
%      OUTPUT: daysnum   datenum Matlab day 
%              days      1...31 or 1..30 or 1..28
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%
 
   daysnum=[];
   days=[];
   for iyear=year
   for imonth=month
   p=datenum(iyear,imonth,1:31);
   tmp=str2num(datestr( p, 5));
   in=find(tmp == imonth);
   daysnum1=p(in);
   days1=str2num(datestr( daysnum1, 7));
   daysnum=[daysnum; daysnum1'];
   days=[days; days1];
   
   
   end
   end

%rnc_Extract_Levitus_Clima.m
