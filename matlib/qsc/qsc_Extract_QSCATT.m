function [qsc]=qsc_Extract_QSCATT(lonr,latr, mydatenum, avg_freq,varargin)



freq=avg_freq;
grd.lonr=lonr;
grd.latr=latr;
ctlf.year=str2num(datestr(mydatenum,10)); 
ctlf.month=str2num(datestr(mydatenum,5)); 
ctlf.day=str2num(datestr(mydatenum,7)); 
ctlf.datenum=mydatenum;



% read the first file
[files, mydatenum2] = qsc_getfiles(1999);
month=str2num(datestr(mydatenum2,5));
[TAUXn,TAUYn,lon,lat,time]=qsc_read_L3stress(files{1});
[I1,J1]=size(lon);

  lonmin = min(grd.lonr(:))-4;
  lonmax = max(grd.lonr(:))+4;
  latmin = min(grd.latr(:))-4;
  latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);
  lon=lon(i,j);
  lat=lat(i,j);


qsc.lon=lon;
qsc.lat=lat;





TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon)

qsc.sustr=zeros(I,J,TIMEINDEX);
qsc.svstr=zeros(I,J,TIMEINDEX);
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

  year=ctlf.year(TIMEINDEX);        
  % load data if needed.
  if LOADED_YEAR ~= year & ~strcmp(freq,'clima')
    disp(['Loading ... ',num2str(year)])
    [files, mydatenum2] = qsc_getfiles(year);
    month=str2num(datestr(mydatenum2,5));
    LOADED_YEAR=year;
   end
     
    % you can find the dates now with datestr
   if         strcmp(freq,'daily')
	  in=find(mydatenum2 == ctlf.datenum(TIMEINDEX) );
	  [taux,tauy,LON,LAT,time]=qsc_read_L3stress(files{in});
        qsc.svstr(:,:,TIMEINDEX)=(tauy(i,j));
        qsc.sustr(:,:,TIMEINDEX)=(taux(i,j));        
	  qsc.avg_type='daily';

   elseif     strcmp(freq,'monthly')
        ifiles=find(month == ctlf.month(TIMEINDEX) );
        TAUXn=zeros(I1,J1);
        TAUYn=zeros(I1,J1);
        TAUX=TAUXn;
        TAUY=TAUYn;
        for ii=ifiles'
            [taux,tauy,LON,LAT,time]=qsc_read_L3stress(files{ii});
		  in = find(~isnan(taux));
            TAUXn(in) = TAUXn(in) +1;
            TAUX(in) = TAUX(in) + taux(in);
    
            in = find(~isnan(tauy));
            TAUYn(in) = TAUYn(in) +1;
            TAUY(in) = TAUY(in) + tauy(in) ;
         end    
         % end of average
         taux = TAUX./TAUXn;
         tauy = TAUY./TAUYn;
         qsc.svstr(:,:,TIMEINDEX)=(tauy(i,j));
         qsc.sustr(:,:,TIMEINDEX)=(taux(i,j));   

	   ncep.avg_type='monthly';
   else
	  ncep.avg_type='clima';
	  
   end
        % common to all
        qsc.year(TIMEINDEX)  = ctlf.year(TIMEINDEX);
        qsc.month(TIMEINDEX) = ctlf.month(TIMEINDEX);
	  qsc.datenum(TIMEINDEX) = ctlf.datenum(TIMEINDEX);
	  qsc.day(TIMEINDEX) = ctlf.day(TIMEINDEX);
end











return

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

