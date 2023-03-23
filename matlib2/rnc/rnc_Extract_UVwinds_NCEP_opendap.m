

function ncep = rnc_Extract_UVwinds_NCEP_opendap(lonr,latr, mydatenum, avg_freq,varargin)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function ncep = rnc_Extract_UVwinds_NCEP(grd, freq, ctlf)
%
%      INPUT: LONR,LATR grid coordinates at RHO-points
%             MYDATENUM date at which you want to extract forcing in MATLAB 
%                       datenum format
%             AVG_FREQ  frequency of averaging 'daily', 'monthly' or 'clima'
%                       if spelled wrong, you will get the clima!
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%

YES_LAND = 0;
if nargin==5
   ncep=varargin{1};
   YES_LAND = 0;
end
filetyp='.sfc.gauss.';

freq=avg_freq;
grd.lonr=lonr;
grd.latr=latr;
ctlf.year=str2num(datestr(mydatenum,10)); 
ctlf.month=str2num(datestr(mydatenum,5)); 
ctlf.day=str2num(datestr(mydatenum,7)); 
ctlf.datenum=mydatenum;

%ncep_landmask = which('NCEP_landmask.nc');
%[mask,lon,lat]=cdc_readvar2(ncep_landmask,'land');
datadir='http://www.cdc.noaa.gov/cgi-bin/opendap/nph-nc/Datasets/ncep.reanalysis.dailyavgs/surface_gauss/';

[mask,lon,lat]=cdc_readvar2([datadir,'land',filetyp,'nc'],'land');
mask(mask==1)=NaN;
mask(mask==0)=1;

  lonmin = min(grd.lonr(:))-4;
  lonmax = max(grd.lonr(:))+4;
  latmin = min(grd.latr(:))-4;
  latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

% nw sw se ne
%%corn.lon = [grd.lonr(1,end) grd.lonr(1,1) grd.lonr(end,1) grd.lonr(end,end)]';
%%corn.lat = [grd.latr(1,end) grd.latr(1,1) grd.latr(end,1) grd.latr(end,end)]';
%%i=find ( squeeze(lon(:,1)) > min(corn.lon)-4 & squeeze(lon(:,1)) <  max(corn.lon)+4);
%%j=find ( squeeze(lat(1,:)) > min(corn.lat)-4 & squeeze(lat(1,:)) <  max(corn.lat)+4);

mask=mask(i,j);
lon=lon(i,j);
lat=lat(i,j);
%-----------------------------------------------------------------
% LOAD A VARIABLE


TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon);
ncep.sustr=zeros(I,J,TIMEINDEX);
ncep.svstr=zeros(I,J,TIMEINDEX);
ncep.i=i;
ncep.j=j;
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

  year=ctlf.year(TIMEINDEX)       
  % load data if needed.
  if LOADED_YEAR ~= year & ~strcmp(freq,'clima')
    disp(['Loading ... ',num2str(year)])
    
    myvar='vflx'; myear=num2str(year);
    disp([' Variable: ',myvar]);
   [foutv,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);
	  

    myvar='uflx'; myear=num2str(year);
    disp([' Variable: ',myvar]);
    [foutu,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);
    
    time = time -time(1) + datenum(year,1,1,12,0,0);
    day_datenum=time;
    months=str2num(datestr(day_datenum,5)); 
    days=str2num(datestr(day_datenum,7));     
    LOADED_YEAR=year;
   end
     
    % you can find the dates now with datestr
   if         strcmp(freq,'daily')
	  in=find(months == ctlf.month(TIMEINDEX) & days == ctlf.day(TIMEINDEX));
        ncep.svstr(:,:,TIMEINDEX)=(foutv(i,j,in));
        ncep.sustr(:,:,TIMEINDEX)=(foutu(i,j,in));        
	  ncep.avg_type='daily';

   elseif     strcmp(freq,'monthly')
	  in=find(months == ctlf.month(TIMEINDEX));
        ncep.svstr(:,:,TIMEINDEX)=mean(foutv(i,j,in),3);
        ncep.sustr(:,:,TIMEINDEX)=mean(foutu(i,j,in),3);        
	  ncep.avg_type='monthly';
   else
        nc=netcdf(ncep_clima);
	  in=ctlf.month(TIMEINDEX);	  
	  ncep.svstr(:,:,TIMEINDEX)=-nc{'svstr'}(i,j,in);
	  ncep.sustr(:,:,TIMEINDEX)=-nc{'sustr'}(i,j,in);
	  close(nc);
	  ncep.avg_type='clima';
	  
   end
        % common to all
        ncep.year(TIMEINDEX)  = ctlf.year(TIMEINDEX);
        ncep.month(TIMEINDEX) = ctlf.month(TIMEINDEX);
	  ncep.datenum(TIMEINDEX) = ctlf.datenum(TIMEINDEX);
	  ncep.day(TIMEINDEX) = ctlf.day(TIMEINDEX);
end

% change sign for ocean convention
        ncep.svstr=-ncep.svstr;
	  ncep.sustr=-ncep.sustr;
        ncep.lon=lon;
	  ncep.lat=lat;
	  ncep.mask=mask;


if YES_LAND ==0
in=find(isnan(ncep.mask));
noin=find(~isnan(ncep.mask));
[pmap]=rnt_oapmap(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin) ,ncep.lon(in),ncep.lat(in),20);
tmp=0;
vars={'sustr' 'svstr'};
for i=1:TIMEINDEX
    disp(['Filling nan for month... ',num2str(i)]);
    for iv=1: length(vars)
        disp(vars{iv});
    eval(['tmp=ncep.',vars{iv},'(:,:,i);']);
    tmp(in)=rnt_oa2d(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin).*tmp(noin), ...
                 ncep.lon(in),ncep.lat(in),3,3,pmap);
    eval(['ncep.',vars{iv},'(:,:,i)=tmp;']);
    end
end
else
   disp('Keeping land values');
end


	 	  
%for i=1:TIMEINDEX
%    disp(['Filling nan for ... ',datestr(ncep.datenum(i))]);
%    ncep.svstr(:,:,i)=rnt_fill(lon,lat,ncep.svstr(:,:,i).*mask,3,3);
%    ncep.sustr(:,:,i)=rnt_fill(lon,lat,ncep.sustr(:,:,i).*mask,3,3);
%end

  
%rnc_Extract_ROMSsurfFluxes_NCEP.m
