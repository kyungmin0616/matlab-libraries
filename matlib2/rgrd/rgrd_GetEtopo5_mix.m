function [topo,lon,lat] = GetEtopo5 (file,lonmin,lonmax,latmin,latmax);
%
%-------------------------------------------------------------------------------
%|                                                                             |
%| function [topo,lon,lat] = get_etopo5 (file,lonmin,lonmax,latmin,latmax);    |
%|                                                                             |
%| This function reads in topography and positions from a netCDF ETOPO5 file.  |
%|                                                                             |
%| Input:                                                                      |
%|                                                                             |
%|    file.....Name of ETOPO5 netCDF file.                                     |
%|    lonmin...Minimum longitude to extract.                                   |
%|    lonmax...Maximum longitude to extract.                                   |
%|    latmin...Minimum latitude to extract.                                    |
%|    latmax...Maximum latitude to extract.                                    |
%|                                                                             |
%| Output:                                                                     |
%|                                                                             |
%|    topo.....Extracted topography.  (matrix)                                 |
%|    lon......Extracted longitudes.  (vector)                                 |
%|    lat......Extracted latitudes.  (vector)                                  |
%-------------------------------------------------------------------------------
%    lonmin = min(grd.lonr(:))-2;
%    lonmax = max(grd.lonr(:))+2;
%    latmin = min(grd.latr(:))-2;
%    latmax = max(grd.latr(:))+2;

%-------------------------------------------------------------------------------
% Open netCDF file.
%-------------------------------------------------------------------------------

nc =netcdf (file);

%-------------------------------------------------------------------------------
% Read topography, longitude and latitude.
%-------------------------------------------------------------------------------

lon=nc{'topo_lon'}(:);
lat=nc{'topo_lat'}(:);
topo = nc{'topo'}(:,:);
topo=topo';

% need to shift
inm=find(lon<0);inp=find(lon>=0);
lon=[lon(inm); lon(inp)];
topom=topo;
topom(1:length(inm), :)=topo(inm,:);
topom(length(inm)+1:end, :)=topo(inp,:);


% extract Southern California Region
  i=find ( lon > lonmin-1.5 & lon < lonmax+1.5);
  j=find ( lat > latmin-1.5 & lat <latmax+1.5);


[lon,lat]=meshgrid(lon(i),lat(j));
lon=lon';
lat=lat';
topo=topom(i,j);
close(nc);
