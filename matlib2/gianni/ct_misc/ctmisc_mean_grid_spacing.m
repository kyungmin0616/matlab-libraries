function [area,grid_space,lon,lat] = ctmisc_mean_grid_spacing(grd)

%% ctmisc_mean_grid_spacing: Calculate grid resolution
%  [area,grid_space,lon,lat] = ctmisc_mean_grid_spacing(grd)
%  
%   INPUT: grd: grid structure
%
%   OUTPUTS: area = grid area in sq. km
%            grid_space = grid resolution in km
%            lon = average longitudinal resolution
%            lat = average lattitudinal resolution
%            

a = grd.yr(:,2:end)-grd.yr(:,1:end-1);
b = grd.xr(2:end,:)-grd.xr(1:end-1,:);

lon = mean(a(:));
lat = mean(b(:));

area = lat*lon;
grid_space = (lat+lon)/2;

end

