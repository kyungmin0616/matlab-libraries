%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  roms_to_roms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
global IPRINT; IPRINT=0;

gname1='usw15_grid.nc';
fname1='usw15_Mmean_BIO.nc';

gname2='mb_l2_usw17_grd.nc';
fname2='mb_l2_usw17_bioclm.nc';

vname='SDET';
zstr=-5000;
irec1=1; irec2=12;

disp(' '); disp(['Interpolate ',vname,' from ', ...
  fname1,' to ',fname2, ' ...']);

%.............................................
disp(' '); disp('Get horizontal grids ...')

nc=netcdf(gname1,'nowrite');
lon1=nc{'lon_rho'}(:);
lat1=nc{'lat_rho'}(:);
h1=nc{'h'}(:);
mask1=nc{'mask_rho'}(:);
nc=close(nc); 

nc=netcdf(gname2,'nowrite');
lon2=nc{'lon_rho'}(:);
lat2=nc{'lat_rho'}(:);
h2=nc{'h'}(:);
mask2=nc{'mask_rho'}(:);
nc=close(nc); 

[M1 L1]=size(lon1); [M2 L2]=size(lon2);
N=20;

mask1(find(mask1==0))=NaN;

%.............................................
disp('Get vertical grids ...');

theta_s=7;theta_b=0.;Tcline=200;

[z1]=scoord_pv(h1,theta_s,theta_b,Tcline,N,'r');
[z2]=scoord_pv(h2,theta_s,theta_b,Tcline,N,'r');

zl=-[5500,5000,4500,4000,3500,3000,2500,2000, ...
   1750,1500,1400,1300,1200,1100,1000, ...
   900,800,700,600,500,400,300,250,200, ...
   150,125,100,75,50,30,20,10,0];
Nl=length(zl);

zstr=zl(find(zl==max(zl(2),zstr))-1);
zmax=max(min(min(z1(1,:,:))),zstr);
kstr=min(find(zl>=zmax)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for irec=irec1:irec2

  disp(' '); disp(['Month:',num2str(irec)])

%.............................................

  nc=netcdf(fname1,'nowrite');
  var=nc{vname}(irec,:,:,:);
  nc=close(nc); 

  var(find(var<0))=0;

%.............................................
  disp(' ... Interpolation on grid1, z levels ...')

  vtmp1=squeeze(var(N,:,:)).*mask1;
  vtmp2=nonan(lon1,lat1,vtmp1);
  vg1zl(Nl,:,:)=vtmp2;

  for k=kstr:Nl-1;
    vtmp1=hslice_pv(var,z1,zl(k));
    vtmp1=vtmp1.*mask1;
    vtmp2=nonan(lon1,lat1,vtmp1);
    vg1zl(k,:,:)=vtmp2(:,:); 
  end;

  clear vtmp1 vtmp2;

%.............................................
  disp(' ... Interpolate on grid2, z levels ...')

  for k=kstr:Nl;
    vtmp1=squeeze(vg1zl(k,:,:));
    vtmp2=griddata(lon1,lat1,vtmp1,lon2,lat2,'linear');
    vg2zl(k,:,:)=vtmp2;
  end;
  if kstr>1;
    for k=1:kstr-1;
      vg2zl(k,:,:)=vg2zl(kstr,:,:);
    end;
  end;
  clear vtmp1 vtmp2;

%.............................................
  disp(' ... Interpolation to grid2, sigma levels ... ')

  vg2z2 = ztosigma(vg2zl,z2,zl);

%.............................................
  disp(' ... Write into fname2 ...');

  nc=netcdf(fname2,'write');
  nc{vname}(irec,:,:,:)=vg2z2;
  nc=close(nc); 

end;

%.............................................
disp(' ... Plot ...')

ilat=50;
[x,dum]=meshgrid(squeeze(lon2(ilat,:)),[1:1:N]);
y=squeeze(z2(:,ilat,:));
z=squeeze(vg2z2(:,ilat,:));
mask2(find(mask2==0))=NaN;
[m,dum]=meshgrid(squeeze(mask2(ilat,:)),[1:1:N]);
contourf(x,y,m.*z); colorbar;
title(vname);


result=close(nc);
return



