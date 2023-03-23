

function [files, mydatenum] = qsc_getfiles(yr)
%function [files, mydatenum] = qsc_getfiles(year)
%  Return the files for the selected year and the dates.
%  Dates are in matlab format.

ncep_clima = which('NCEP_WindStress_monthly.nc');
n=length('NCEP_WindStress_monthly.nc');
datadir = [ncep_clima(1:end-n),'QSCATT_daily/'];
files=rnt_getfilenames([datadir,num2str(yr)],'QS');
for i=1:length(files)
fn=files{i};
istr=findstr(fn,'QS_STGRD3_');
istr=istr+10;    
year=datenum(str2num(fn(istr:istr+3)),0,0);
day=str2num(fn(istr+4:istr+6));
mydatenum(i) = year+day;
end
