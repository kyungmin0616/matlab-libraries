
 
function forcd=rnc_Extract_dQdSST_Clima(lonr,latr, mydatenum)
%function forcd=rnc_Extract_dQdSST_Clima(lonr,latr, mydatenum)
% need to write some more info.... but it works


which dQdSST.mat
load dQdSST.mat
lon=LON; lat=LAT;
grd.lonr=lonr; grd.latr=latr;

grd

    lonmin = min(grd.lonr(:))-4;
    lonmax = max(grd.lonr(:))+4;
    latmin = min(grd.latr(:))-4;
    latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

  lon=lon(i,j);
  lat=lat(i,j);
 DQDSST=DQDSST(i,j,:);
 mask=DQDSST(:,:,1);
 mask(~isnan(mask))=1;
 

 months = str2num(datestr(mydatenum,5));
    for it=1:length(mydatenum)
        imon=months(it);
        disp([' --month ',num2str(imon)]); 	 	   
        forcd.dQdSST(:,:,it)=rnt_fill(lon,lat,DQDSST(:,:,imon),3,3);
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
