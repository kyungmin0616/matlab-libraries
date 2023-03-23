clear all;
close all
global IPRINT; IPRINT=0;

fname='/disk8/patrickm/USwest/grid15/usw15_coamps.nc';
gname='/disk8/patrickm/USwest/grid15/usw15_grid.nc';

amp=nc_read(fname,'tide_Eamp',1);
phase=nc_read(fname,'tide_Ephase',1);
phase(phase<0)=phase(phase<0)+360;

lon=nc_read(gname,'lon_rho');
lat=nc_read(gname,'lat_rho');
mask=nc_read(gname,'mask_rho');
mask(mask==0)=NaN;
%................................................

lonw=-140;lone=-115;lats=24;latn=48;

figure
colormap(jet);
coastfile='/disk13/Coastlines/usw_coast_h.mat';
m_proj('mercator','lon',[lonw lone],'lat',[lats latn]);

m_contourf(lon,lat,amp(:,:,1),[0:.1:1]); shading flat; hold on;
[C,h]=m_contour(lon,lat,amp(:,:,1),[0:.1:1]); hold on;
clabel(C,h);
[C,h]=m_contour(lon,lat,phase(:,:,1).*mask,[0:20:360],'w');
clabel(C,h,'color','w');
title({['M2 Tide']});
set(gca,'Layer','top');

m_usercoast(coastfile,'patch',[.9 .9 .9]);
m_grid('box','fancy',...
       'xtick',5,'ytick',5,'tickdir','out',...
       'fontsize',10);

city_names(lonw,lone,lats,latn,1);

%................................................
set(gcf,'Color','w');
set(gcf,'InvertHardcopy','off')
set(gcf, 'PaperPositionMode', 'auto');
print -depsc M2_tide.ps;


return

