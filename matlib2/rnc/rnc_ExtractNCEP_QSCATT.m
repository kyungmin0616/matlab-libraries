function  qscb = rnc_ExtractNCEP_QSCATT_Forcing(lonr,latr, mydatenum, avg_freq, varargin);
% get ncep winds.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.
  

if nargin > 4
   YES_LAND=1;
else
   YES_LAND=0;
end

ncep_clima = which('NCEP_WindStress_monthly.nc');
n=length('NCEP_WindStress_monthly.nc');
datadir = [ncep_clima(1:end-n),'QSCATT_NCEP_daily'];

files=rnt_getfilenames(datadir,'qscb_');
ctl=rnt_timectl(files,'sms_time');


freq=avg_freq;
grd.lonr=lonr;
grd.latr=latr;
ctlf.year=str2num(datestr(mydatenum,10)); 
ctlf.month=str2num(datestr(mydatenum,5)); 
ctlf.day=str2num(datestr(mydatenum,7)); 
ctlf.datenum=mydatenum;

  
  nc = netcdf(ctl.file{1});
  lon=perm(nc{'lon'}(:));
  lat=perm(nc{'lat'}(:));
  mask=perm(nc{'mask'}(:));
  mask(mask==0)=nan;
  lon=[lon ; lon+360];
  mask=[mask ; mask];  
  lat=[lat;lat];
  close(nc);
  
  lonmin = min(grd.lonr(:))-4;
  lonmax = max(grd.lonr(:))+4;
  latmin = min(grd.latr(:))-4;
  latmax = max(grd.latr(:))+4;
  
  
  % extract grid Region
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);
  
  lon=lon(i,j);
  lat=lat(i,j);
  mask=mask(i,j);
  % use only 31 levels ..below that not much data
  
%-----------------------------------------------------------------
% LOAD A VARIABLE


TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon);
qscb.sustr=zeros(I,J,TIMEINDEX);
qscb.svstr=zeros(I,J,TIMEINDEX);
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

     disp(['QSCATT_NCEP_blend exracting ...',datestr(ctlf.datenum(TIMEINDEX))]);
    % you can find the dates now with datestr
   if         strcmp(freq,'daily')
	  in=find(ctl.datenum == ctlf.datenum(TIMEINDEX) );
	 if length(in)==0
	     in=inlast;
	     disp('missing date (hit return to continue)');
       pause
	  else
	      inlast=in;
        end
        tmp=rnt_loadvar(ctl,in,'svstr'); tmp=[tmp;tmp];
	  qscb.svstr(:,:,TIMEINDEX)=tmp(i,j);
        tmp=rnt_loadvar(ctl,in,'sustr');tmp=[tmp;tmp];qscb.sustr(:,:,TIMEINDEX)=tmp(i,j);
	  qscb.avg_type='daily';

   elseif     strcmp(freq,'monthly')
	  in=find(ctl.month == ctlf.month(TIMEINDEX) & ctl.year == ctlf.year(TIMEINDEX));	  
        tmp=mean(rnt_loadvar(ctl,in,'svstr'),3);tmp=[tmp;tmp]; qscb.svstr(:,:,TIMEINDEX)=tmp(i,j);
        tmp=mean(rnt_loadvar(ctl,in,'sustr'),3);tmp=[tmp;tmp]; qscb.sustr(:,:,TIMEINDEX)=tmp(i,j);
	  qscb.avg_type='monthly';
   end
        % common to all
        qscb.year(TIMEINDEX)  = ctlf.year(TIMEINDEX);
        qscb.month(TIMEINDEX) = ctlf.month(TIMEINDEX);
	  qscb.datenum(TIMEINDEX) = ctlf.datenum(TIMEINDEX);
	  qscb.day(TIMEINDEX) = ctlf.day(TIMEINDEX);
end

% change sign for ocean convention
        qscb.lon=lon;
	  qscb.lat=lat;
	  qscb.mask=mask;


if YES_LAND == 0
in=find(isnan(qscb.mask));
noin=find(~isnan(qscb.mask));
[pmap]=rnt_oapmap(qscb.lon(noin),qscb.lat(noin),qscb.mask(noin) ,qscb.lon(in),qscb.lat(in),20);

vars={'sustr' 'svstr'};
for i=1:TIMEINDEX
    %disp(['Filling nan for month... ',num2str(i)]);
    for iv=1: length(vars)
        disp(vars{iv});
    eval(['tmp=qscb.',vars{iv},'(:,:,i);']);
    tmp(in)=rnt_oa2d(qscb.lon(noin),qscb.lat(noin),qscb.mask(noin).*tmp(noin), ...
                 qscb.lon(in),qscb.lat(in),3,3,pmap);
    eval(['qscb.',vars{iv},'(:,:,i)=tmp;']);
    end
end
	 	  
else
   disp('Keeping Land values');
end
