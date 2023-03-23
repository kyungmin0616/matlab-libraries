function [datestr,day,mon,yr,unix,leetmaa,gdays,gday] = dates(lday, date_type)
%Syntax:
%
%   [datestr,day,mon,yr,unix,leetmaa,gdays,gday] = dates(316209600,'u')
%
% INPUT:
%  time = unix or leetmaa
%  time_type = type of input date: 'u' for unix, 'l' for leetmaa, 
%                                  'g' for Julian Total day roms out
%
% OUTPUT:
%  datestr = string of date (for plotting ..)
%  gdays   = total Julian days
%  gday    = Julian day of the current year
%
%  Range of dates to be computed are Jan 1980 - Dec 2002
%
% NOTES: this routine has been build to make tings faster for myself
% but in no way is intended to be perfect. Please make sure there are no
% NaN values, since I am not checking the inouts for that.
% 
%        Emanuele Di Lorenzo (edl@ucsd.edu)
	  

  format long g	  
  load([which('dates'),'at']); dates=dates_array;
  
  
  dayi=1; moni=2; yri=3; let=4; unixi=5; julian=6; gd=7;
  months=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug', 'Sep', 'Oct',  'Nov', 'Dec'];  
  [num,ttmp]=size(lday(:));
  
  index=let;
  if date_type == 'u', index=unixi; end;
  if date_type == 'l', index=let; end;
  if date_type == 'g', index=gd; end;
  
  
  for i=1:num   
  ind=find(dates(:,index) <= lday(i));  
    if isempty(ind) == 1 
	unix(i)=NaN;
	leetmaa(i)=NaN;
	day(i) =NaN;
	yr(i)  =NaN;
	mon(i)=NaN;
	datestr(i)=cellstr('No date found');
	gdays(i)=NaN;
	gday(i)= NaN;    
    else
      ind=ind(end);
	day_fraz=lday(i)-dates(ind,index);
	unix_fraz = day_fraz*24*60*60;
	if date_type == 'u'
	   unix_fraz=lday(i)-dates(ind,index);
	   day_fraz=unix_fraz/(24*60*60);
	end
	   unix(i)=dates(ind,unixi)+unix_fraz;
	   leetmaa(i)=dates(ind,let)+day_fraz;
	   day(i) =dates(ind,dayi)+day_fraz;
	   yr(i)  =dates(ind,yri);
	   mon(i)=dates(ind,moni);
	   monii=(mon(i)-1)*3 +1;
	   datatit1=[num2str(dates(ind,dayi)),[' '],months(monii:monii+2),[' '],num2str(yr(i))];
	   datestr(i)=cellstr(datatit1);
	   gdays(i)=dates(ind,7)+day_fraz;
	   gday(i)= dates(ind,6)+day_fraz;
    end
  end

