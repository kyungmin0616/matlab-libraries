function data=rnc_Extract_SPEEDY_SSTa(xlim,ylim,trange,varargin);

lat=[ -87.16  -83.47  -79.78  -76.07  -72.36  -68.65  -64.94 ...
-61.23  -57.52  -53.81  -50.10  -46.39  -42.68  -38.97  -35.26  -31.54  ...
-27.83  -24.12  -20.41  -16.70  -12.99   -9.28   -5.57   -1.86    1.86  ...
  5.57    9.28   12.99   16.70   20.41   24.12   27.83   31.54   35.26  ...
 38.97   42.68   46.39   50.10   53.81   57.52   61.23   64.94   68.65  ...
 72.36   76.07   79.78   83.47   87.16]';
lon=0:3.75:3.75*95;

[LON,LAT]=meshgrid(lon,lat); LON=LON'; LAT=LAT';
lon=LON-360;
lat=LAT;


files=rnt_getfilenames('/sdd/PALEO/speedy2/code/speedy_ver40/output/exp_CLIMA','att*.nc');
ctlc=rnt_timectl(files,'datenum');
in=1:length(ctlc.time);

slp=rnt_loadvar(ctlc,in,'SSTA');

i=find(lon(:,1) >= xlim(1) & lon(:,1) <= xlim(2));
j=find(lat(1,:) >= ylim(1) & lat(1,:) <= ylim(2));

it=find(ctlc.datenum >= trange(1) & ctlc.datenum <= trange(2));

addpath /sdd/PALEO/speedy2/matlib
p=SPEEDY_LoadBC;
mask=p.sst(:,:,1);
mask(~isnan(mask))=1;

data.SST=slp(i,j,:);
data.lon=lon(i,j);
data.lat=lat(i,j);
data.mask=mask(i,j);
data.datenum=ctlc.datenum;

