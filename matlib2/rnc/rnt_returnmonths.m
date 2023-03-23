

function [daysnum]=rnc_returnmonths(year,month)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function [daysnum]=rnc_returnmonths(year,month)
%
%  Returns the months selected years
%
%      INPUT: YEAR, MONTH 
%
%      OUTPUT: daysnum   datenum Matlab format 
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%
 
   daysnum=[];
   days=[];
   k=0;
   for iyear=year
   for imonth=month
   k=k+1;
   daysnum(k)=datenum(iyear,imonth,15);   
   
   end
   end

%rnc_Extract_Levitus_Clima.m
