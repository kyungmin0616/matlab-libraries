
 
function forcd=rnc_Extract_NOAA_SST(lonr,latr, mydatenum)
%function forcd=rnc_Extract_dQdSST_Clima(lonr,latr, mydatenum)
% need to write some more info.... but it works


file=which('noaa-sst.mnmean.nc');
file='/sdc/NOAA-SST/noaa-sst.mnmean.nc';
n=0;
clear time2;
for yr=1854:2004
for imon=1:12
n=n+1;
time2(n)=datenum(yr,imon,15);
end
end

yr=2005;
for imon=1:2
n=n+1;
time2(n)=datenum(yr,imon,15);
end

time=time2;

istr=find( mydatenum(1) > time); istr=istr(end);
iend=find( mydatenum(end) < time); iend=iend(1);
time=time(istr:iend);

[fout,lon,lat] = cdc_readvar (file, 'sst','time',istr:iend);

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
[pmap]=rnt_oapmap(lon(noin),lat(noin),mask(noin) ,lon(in),lat(in),20);


 for it=1:length(mydatenum)
     in2 = find( time == datenum( years(it), months(it), 15));
     if length(in2) < 1 ; disp('error - time do not match'); return; end
     tmp = fout(:,:,in2);
	tmp(in)=rnt_oa2d(lon(noin),lat(noin),mask(noin).*tmp(noin), ...
                 lon(in),lat(in),3,3,pmap);

     forcd.SST(:,:,it)=tmp;
 end
     
     forcd.lon=lon;
     forcd.lat=lat;
     forcd.mask=mask;
     forcd.datenum=mydatenum;
     










return
nc = netcdf(which('dQdSST.nc'));
% load variables
lon = nc{'lon'}(:) -0.5;
lon = lon - 360;
lat = nc{'lat'}(:)-90.5;
clm = nc{'clm'}(:);

in = find (clm < -12945 ); clm(in)=nan;
in = find (clm > 933 ); clm(in)=nan;
clm = clm * 0.01;
clm = clm';


[LAT,LON]=meshgrid(-77.5:89.5, -359.5:-0.5);


[I,J] = size(LAT);
DQDSST=zeros(12,J,I)*nan;
n=0;

for j=1:J
for i=1:I
   
   in=find( lat == LAT(i,j) & lon == LON(i,j));
   if length(in) > 0
      n=n+1;
      disp(n)
      DQDSST(:,j,i) = clm(in,:)';
   end
end
end
      DQDSST=perm(DQDSST);
save dQdSST.mat LON LAT DQDSST
