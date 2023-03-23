

function forcd=rnc_Extract_NOAA_SST(lonr,latr, varargin)
%function forcd=rnc_Extract_dQdSST_Clima(lonr,latr, mydatenum)
% need to write some more info.... but it works


%file=which('noaa-sst.mnmean.nc');
%file='/sdc/NOAA-SST/noaa-sst.mnmean.nc';
%file='/sdc/NOAA-SST/sst.mnmean.nc';
file=which('NOAA-sst.nc');
nc=netcdf(file);
time=nc{'time'}(:);
close(nc);

it=length(time);

n=0;
clear time2;
for yr=1854:2020
    for imon=1:12
        n=n+1;
        time2(n)=datenum(yr,imon,15);
    end
end


time=time2(1:it);
time2=time;

mydatenum=time2;
DO_OA=1;
if nargin > 2
    mydatenum=varargin{1};
end
if nargin > 3
    DO_OA=varargin{2};
end


istr=find( mydatenum(1) >= time); istr=istr(end);
iend=find( mydatenum(end) <= time); iend=iend(1);
time=time(istr:iend);

[fout,lon,lat] = cdc_readvar2 (file, 'sst','time',istr:iend);
% size(fout)
% size(mydatenum)
% istr
% iend

FULL_RANGE = 0;
if sum(lonr) == 0
    FULL_RANGE = 1;
    disp('SST - Extracting full range');
end

if FULL_RANGE == 0
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
    disp('SST - Extracting selected spatial range');
end

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
        
        forcd.SST(:,:,it)=tmp;
    end
else
    forcd.SST=fout;
end

forcd.lon=lon;
forcd.lat=lat;
forcd.mask=mask;
forcd.datenum=time;











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
