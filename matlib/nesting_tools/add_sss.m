frcfile='usw15_coamps.nc';
grdfile='usw15_grid.nc';
clmfile='usw15_Lclm.nc';

time=(15:30:345);
month(1:12,1:3)=['jan'; 'feb'; 'mar' ;'apr'; 'may'; 'jun'; ...
                 'jul'; 'aug'; 'sep'; 'oct'; 'nov'; 'dec'];

%
%  create the variable in the netcdf file
%
nc=netcdf(frcfile,'write');
result = redef(nc);
nc('sss_time') = length(time);
nc{'sss_time'} = ncdouble('sss_time');
nc{'SSS'}=ncdouble('sss_time','eta_rho','xi_rho') ;
result = endef(nc);
%
%  add attributes
%
nc{'sss_time'}.long_name = ncchar('sea surface salinity time');
nc{'sss_time'}.long_name = 'sea surface salinity time';
nc{'sss_time'}.units = ncchar('days');
nc{'sss_time'}.units = 'days';
nc{'sss_time'}.cycle_length = 360.;
nc{'sss_time'}.fields = ncchar('time, scalar, series');
nc{'sss_time'}.fields = 'time, scalar, series';

nc{'SSS'}.long_name = ncchar('sea surface salinity');
nc{'SSS'}.long_name = 'sea surface salinity';
nc{'SSS'}.units = ncchar('PSU');
nc{'SSS'}.units = 'PSU';
nc{'SSS'}.fields = ncchar('sea surface salinity, scalar, series');
nc{'SSS'}.fields = 'sea surface salinity, scalar, series';
%
% put time
%
nc{'sss_time'}(:)=time;
%
% read and write sss
%
nclim=netcdf(clmfile);
N=length(nclim{'sc_r'});
for i=1:12;
  nc{'SSS'}(i,:,:)=squeeze(nclim{'salt'}(i,N,:,:));
end;
result=close(nclim);
result=close(nc);
%
% make a plot
%
nc=netcdf(frcfile);
sss=nc{'SSS'}(6,:,:);
result=close(nc);
nc=netcdf(grdfile);
lat=nc{'lat_rho'}(:);
lon=nc{'lon_rho'}(:);
mask=nc{'mask_rho'}(:);
result=close(nc);
mask(mask==0)=NaN;
pcolor(lon,lat,mask.*sss)
shading flat
colorbar
axis image

