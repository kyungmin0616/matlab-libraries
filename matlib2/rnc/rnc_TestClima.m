
function rnc_TestClima(grd,clim)


figure;

subplot(3,1,1)
p=interp2(clim.lon',clim.lat',clim.temp(:,:,1,1)',grd.lonr,grd.latr,'cubic');
rnt_plc(p,grd,0,5,0,0);
rnt_font
title 'on model grid'
ax=caxis;


subplot(3,1,2)
rnt_plc(grd.h*nan,grd,0,5,0,0);
pcolor(clim.lon,clim.lat,clim.mask(:,:,1,1).*clim.temp(:,:,1,1));
shading interp ; colorbar
caxis(ax);colorbar
rnt_font
title 'natural resolution of climatology'

subplot(3,1,3)
rnt_plc(grd.h*nan,grd,0,5,0,0);
pcolor(clim.lon,clim.lat,clim.temp(:,:,1,1));
shading interp ; caxis(ax);colorbar
rnt_font
title 'after extrpolation (decor legnth used was 3 deg'


% check depths
[I,J]=size(clim.lon);
for i=1:I
for j=1:J
  p=squeeze(clim.mask(i,j,:,1));
  in=find(isnan(p));
  if length(in) ==0
     Z(i,j) = clim.z(1);
  elseif length(in) ==length(clim.z)
     Z(i,j) =nan;
  else    
     Z(i,j) = clim.z(in(1) -1);
  end
end
end


figure
subplot(3,1,1)
rnt_plc(grd.h*nan,grd,0,7,0,0);
pcolor(clim.lon,clim.lat,Z);

shading interp ; colorbar
rnt_font
title 'climatology bathymetry'
ax=caxis;

subplot(3,1,2)
%p=rnt_oa2d(grd.lonr,grd.latr,grd.h.*grd.maskr,clim.lon,clim.lat,2,2);
rnt_plc(grd.h,grd,0,7,0,0);
caxis(ax);colorbar
rnt_font
title 'model bath grid'


subplot(3,1,3)
p=interp2(clim.lon',clim.lat',Z',grd.lonr,grd.latr,'linear');
rnt_plc(p-grd.h,grd,0,7,0,0);
caxis([-0.01 0.01]);colorbar
rnt_font
title 'negative values indicate that grid topo is deeper than clima'



