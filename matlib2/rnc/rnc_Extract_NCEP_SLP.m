
 
function forcd=rnc_Extract_NCEP_SLP(lonr,latr, varargin)
%function forcd=rnc_Extract_NCEP_SLP(lonr,latr, mydatenum)
% need to write some more info.... but it works



%file=('/sdc/NCEP/slp.mon.mean.nc');
file=which('NCEP-slp.nc');
nc=netcdf(file); t=nc{'time'}(:); close(nc); t=length(t);

n=0;
clear time2;
for yr=1948:2050
for imon=1:12
  n=n+1;
  if n <=t
  time2(n)=datenum(yr,imon,15);
  end
end
end

time=time2;

mydatenum=time2;

DO_OA=0;
if nargin > 2
  mydatenum=varargin{1};
end
if nargin > 3
  DO_OA=varargin{2};
end

istr=find( mydatenum(1) >= time); istr=istr(end);
iend=find( mydatenum(end) <= time); iend=iend(1);
time=time(istr:iend);

[fout,lon,lat] = cdc_readvar2 (file, 'slp','time',istr:iend);

grd.lonr=lonr; grd.latr=latr;
    lonmin = min(grd.lonr(:))-4;
    lonmax = max(grd.lonr(:))+4;
    latmin = min(grd.latr(:))-4;
    latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);
  lon=lon(i,j);
  lat=lat(i,j);
 fout=fout(i,j,:);
 mask=fout(:,:,1);
 mask(~isnan(mask))=1;
 
 years  = str2num(datestr(mydatenum,10));
 months = str2num(datestr(mydatenum,5));

in=find(isnan(mask));
noin=find(~isnan(mask));

if DO_OA==1
[pmap]=rnt_oapmap(lon(noin),lat(noin),mask(noin) ,lon(in),lat(in),20);


 for it=1:length(mydatenum)
     in2 = find( time == datenum( years(it), months(it), 15));
     if length(in2) < 1 ; disp('error - time do not match'); return; end
     tmp = fout(:,:,in2);
	tmp(in)=rnt_oa2d(lon(noin),lat(noin),mask(noin).*tmp(noin), ...
                 lon(in),lat(in),3,3,pmap);

     forcd.SLP(:,:,it)=tmp;
 end

else
forcd.SLP=fout;
end
     
     forcd.lon=lon;
     forcd.lat=lat;
     forcd.mask=mask;
     forcd.datenum=time;
     










return
