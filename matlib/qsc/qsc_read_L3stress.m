
function [taux,tauy,LON,LAT,time]=qsc_read_L3stress(file);
% function [taux,tauy,LON,LAT,time]=qsc_read_L3stress(file);
%     Read HDF file for Level 3 stresses.
%     Gives the Liu et al. calculation of stress
%
%  Source:
%     ftp podaac.jpl.nasa.gov
%     Index of /download/pub/ocean_wind/quikscat/stress/L3/
%  ftp://podaac.jpl.nasa.gov/pub/ocean_wind/quikscat/stress/L3/
%  

%fn='QS_STGRD3_2004006.04Jan121545';
fn=file;
warning off
disp(['Reading ',fn]);
istr=findstr(fn,'QS_STGRD3_');
istr=istr+10;    
year=datenum(str2num(fn(istr:istr+3)),0,0);
day=str2num(fn(istr+4:istr+6));
time = year+day;


%[lon,lat,asc] = qsc_loadvar(fn,'asc_stress_Liu_U');
%[lon,lat,des] = qsc_loadvar(fn,'des_stress_Liu_U');

[lon,lat,ascflag] = qsc_loadvar(fn,'asc_rain_flag');
[lon,lat,desflag] = qsc_loadvar(fn,'des_rain_flag');
asc(ascflag ~=0)=0;
des(desflag ~=0)=0;

[lon,lat,asc] = qsc_loadvar(fn,'asc_stress_Large_U');
[lon,lat,des] = qsc_loadvar(fn,'des_stress_Large_U');

num=2*ones(size(des));
in=find(des ==0);
num(in) = num(in)-1;
in2=find(asc ==0);
num(in2) = num(in2)-1;
taux = (asc+des)./num;

%[lon,lat,asc] = qsc_loadvar(fn,'asc_stress_Liu_V');
%[lon,lat,des] = qsc_loadvar(fn,'des_stress_Liu_V');

[lon,lat,asc] = qsc_loadvar(fn,'asc_stress_Large_V');
[lon,lat,des] = qsc_loadvar(fn,'des_stress_Large_V');

num=2*ones(size(des));
in=find(des ==0);
num(in) = num(in)-1;
in2=find(asc ==0);
num(in2) = num(in2)-1;
tauy = (asc+des)./num;


Xgrid=1440;
Ygrid=720;

i=0:Xgrid-1;
j=0:Ygrid-1;
lon = (360/Xgrid)*(i+0.5);
lat = (180/Ygrid)*(j+0.5)-90;

[LAT,LON]=meshgrid(lat,lon);
LON=LON-360;

