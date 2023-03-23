function forcd = rnc_Extract_Fluxes_ECMWF(lonr,latr, mydatenum, freq)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function forcd = rnc_Extract_Fluxes_ECMWF(grd, freq, ctlf)
%
%      INPUT: LONR,LATR grid coordinates at RHO-points
%             MYDATENUM date at which you want to extract forcing in MATLAB 
%                       datenum format
%             AVG_FREQ  frequency of averaging 'daily', 'monthly' or 'clima'
%                       if spelled wrong, you will get the clima!
%
%  Mer 
%



url='http://apdrc.soest.hawaii.edu:80/dods/public_data/ORA-S3/1x1_grid';

nc=netcdf(url);
lon=nc{'lon'}(:)-360;
lat=nc{'lat'}(:);
depth=nc{'lev'}(:);
time=nc{'time'}(:) + datenum(1,1,1) - 2;
[lat,lon]=meshgrid(lat,lon);
mask=nc{'ssh'}(1,:,:)';
mask(mask > 1.0e+10)=nan; mask(~isnan(mask))=1;
close(nc);

lon=[lon ; lon+360];
lat=[lat; lat];
mask=[mask; mask];

% select the i j indeces of the subregion of interest
    lonmin = min(lonr(:))-4;
    lonmax = max(lonr(:))+4;
    latmin = min(latr(:))-4;
    latmax = max(latr(:))+4;

  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

forcd.lon=lon(i,j);
forcd.lat=lat(i,j);
forcd.mask=mask(i,j);
forcd.time=time;
[year,month]=dates_datenum(time);
forcd.year=year;
forcd.month=month;

[year,month]=dates_datenum(mydatenum);


if strcmp(freq,'monthly')

k=0;
for it=1:length(mydatenum)
    in=find( year(it) == forcd.year & month(it) == forcd.month);
    k=k+1; indeces(k)=in(1);
end

forcd.sustr=zeros(length(i), length(j), length(indeces));
forcd.svstr=zeros(length(i), length(j), length(indeces));
forcd.qnet=zeros(length(i), length(j), length(indeces));
forcd.temp=zeros(length(i), length(j), length(indeces));
forcd.salt=zeros(length(i), length(j), length(indeces));

nc=netcdf(url);

for it=1:length(indeces)
str=['Extracting ... ',datestr(forcd.time(it))];
disp(str);
  tmp=sq(nc{'temp'}(indeces(it),1, :,:))'; tmp=[tmp;tmp]; tmp(tmp>1.0e+10)=nan;
  forcd.temp(:,:,it)=rnt_fill( forcd.lon, forcd.lat, tmp(i,j).*forcd.mask, 3,3);

  tmp=sq(nc{'salt'}(indeces(it),1, :,:))'; tmp=[tmp;tmp];tmp(tmp>1.0e+10)=nan;
  forcd.salt(:,:,it)=rnt_fill( forcd.lon, forcd.lat, tmp(i,j).*forcd.mask, 3,3);

  tmp=nc{'taux'}(indeces(it), :,:)'; tmp=[tmp;tmp];tmp(tmp>1.0e+10)=nan;
  forcd.sustr(:,:,it)=rnt_fill( forcd.lon, forcd.lat, tmp(i,j).*forcd.mask, 3,3);
  
  tmp=nc{'tauy'}(indeces(it), :,:)'; tmp=[tmp;tmp];tmp(tmp>1.0e+10)=nan;
  forcd.svstr(:,:,it)=rnt_fill( forcd.lon, forcd.lat, tmp(i,j).*forcd.mask, 3,3);
  
  tmp=nc{'qnet'}(indeces(it), :,:)'; tmp=[tmp;tmp];tmp(tmp>1.0e+10)=nan;
  forcd.qnet(:,:,it)=rnt_fill( forcd.lon, forcd.lat, tmp(i,j).*forcd.mask, 3,3);
  
end

end


if strcmp(freq,'clima')
load ECMWF_ORA_S3.mat
end



