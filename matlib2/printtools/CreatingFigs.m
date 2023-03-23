
grd=rnt_gridload('calc');
rnt_plc2(grd.h,grd,2,0,0,0);
load /d1/manu/BIO/CTL

zeta=rnt_loadvar(ctl_lf,300,'zeta');

%contourfill(grd.lonr,grd.latr,grd.h.*grd.maskr);
rnt_plc(zeta,grd,2,0,0,0);

%pcolor(grd.lonr,grd.latr,grd.h); shading interp

hold on


clf
load(grd.cstfile)
tmp=zeta.*grd.maskr;
ccolor(grd.lonr,grd.latr,tmp,100);
hold on;
plot(lon,lat,'k')
xmin=min(grd.lonr(:)); xmax=max(grd.lonr(:));
ymin=min(grd.latr(:)); ymax=max(grd.latr(:));
set(gca,'xlim',[xmin xmax]);
set(gca,'ylim',[ymin ymax]);

return
print -r200 -painters -dtiff pp.tif
print -depsc2 -painters -tiff zpp.eps
print -painters -djpeg100 pp.jpg

ls -rtla


%==========================================================
%	% subplotting
%==========================================================
%subplot('position',[left bottom width height]) 
subplot('position',[0 0 .1 .1]) ;
set(gcf,'paperposition',[0.25 0.25 8 10.5]);
