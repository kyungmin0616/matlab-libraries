function sig2sig(gname1,fname1,gname2,fname2,vname,tindex,fname3,grd_global)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Interpolate vname from ROMS (gname1,fname1) to
%  (gname2,fname2) - Patrick Marchesiello 2001
%
%  fname3 is optional and can be used when fname1 does not
%  contain information on the vertical grid (restart files).
%
%  calls: zlev, nonan, ztosigma, sigmatoz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<7, fname3=fname1; end;

zstr=-5000;

disp(' '); disp(['Interpolate ',vname,' from ', ...
  fname1,' to ',fname2, ' ...']);

%.............................................
disp(' '); disp('... Get horizontal grids ...')

if vname(1)=='u',
  lonname='lon_u';
  latname='lat_u';
  maskname='mask_u';
elseif vname(1)=='v',
  lonname='lon_v';
  latname='lat_v';
  maskname='mask_v';
else,
  lonname='lon_rho';
  latname='lat_rho';
  maskname='mask_rho';
end;

nc=netcdf(gname1,'nowrite');
lon1=nc{lonname}(:);
lat1=nc{latname}(:);
h1=nc{'h'}(:);
mask1=nc{maskname}(:);
nc=close(nc); 

nc=netcdf(gname2,'nowrite');
lon2=nc{lonname}(:);
lat2=nc{latname}(:);
h2=nc{'h'}(:);
mask2=nc{maskname}(:);
nc=close(nc); 

[M1 L1]=size(lon1); [M2 L2]=size(lon2);
mask1(find(mask1==0))=NaN;

%.............................................
disp('... Get vertical grids ...');

nc=netcdf(fname3,'nowrite');
N = length(nc('s_rho'));
theta_s = nc{'theta_s'}(:);
theta_b = nc{'theta_b'}(:);
Tcline = nc{'Tcline'}(:);
nc=close(nc); 

[z1]=zlev(h1,theta_s,theta_b,Tcline,N,'r');
[z2]=zlev(h2,theta_s,theta_b,Tcline,N,'r');

if vname(1)=='u',
  z1=rho2u(z1); z2=rho2u(z2);
elseif vname(1)=='v',
  z1=rho2v(z1); z2=rho2v(z2);
end;

zl=-[5500,5000,4500,4000,3500,3000,2500,2000, ...
   1750,1500,1400,1300,1200,1100,1000, ...
   900,800,700,600,500,400,300,250,200, ...
   150,125,100,75,50,30,20,10,0];
Nl=length(zl);

zstr=zl(find(zl==max(zl(2),zstr))-1);
zmax=max(min(min(z1(1,:,:))),zstr);
kstr=min(find(zl>=zmax)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc=netcdf(fname1,'nowrite');
var=nc{vname}(tindex,:,:,:);
nc=close(nc);
%.............................................
disp(' ... Interpolation onto grid1, z levels ...')

vg1zl=zeros(Nl,M1,L1);
vtmp1=squeeze(var(N,:,:)).*mask1;
vtmp2=nonan(lon1,lat1,vtmp1);
vg1zl(Nl,:,:)=vtmp2;

for k=kstr:Nl-1;
  vtmp1=sigmatoz(var,z1,zl(k));
  vtmp1=vtmp1.*mask1;
  vtmp2=nonan(lon1,lat1,vtmp1);
  vg1zl(k,:,:)=vtmp2(:,:); 
end;

clear vtmp1 vtmp2;

%.............................................
disp(' ... Interpolate onto grid2, z levels ...')

vg2zl=zeros(Nl,M2,L2);
for k=kstr:Nl;
  vtmp1=squeeze(vg1zl(k,:,:));
  vtmp2=griddata(lon1,lat1,vtmp1,lon2,lat2,'linear');
  vg2zl(k,:,:)=vtmp2;
end;
if kstr>1,
  for k=1:kstr-1;
    vg2zl(k,:,:)=vg2zl(kstr,:,:);
  end;
end;
clear vtmp1 vtmp2;

%.............................................
disp(' ... Interpolate onto grid2, sigma levels ... ')

vg2z2 = ztosigma(vg2zl,z2,zl);

%.............................................
disp(' ... Write into fname2 ...');

nc=netcdf(fname2,'write');
nc{vname}(tindex,:,:,:)=vg2z2;
nc=close(nc); 

%.............................................
return
