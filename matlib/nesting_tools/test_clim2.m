function test_clim(climname,vname,l)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test the climatology and initial files.
% pierrick 1/2000
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global IPRINT; IPRINT=0;

var=nc_read(climname,vname,l);
nc = netcdf(climname, 'nowrite');
grd_file = nc.grd_file(:);
result = close(nc);

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

lat=nc_read(grd_file,latname);
lon=nc_read(grd_file,lonname);
mask=nc_read(grd_file,maskname);
pm=nc_read(grd_file,'pm');
h=nc_read(grd_file,'h');
[imax jmax]=size(lon);
if vname(1)=='u',
  h=0.5*(h(1:imax,1:jmax)+h(2:imax+1,1:jmax));
elseif vname(1)=='v',
  h=0.5*(h(1:imax,1:jmax)+h(1:imax,2:jmax+1));
end;

mask(mask==0)=NaN;
theta_s=nc_read(climname,'theta_s');
theta_b=nc_read(climname,'theta_b');
Tcline=nc_read(climname,'Tcline');

dim_var=size(var);
N=dim_var(3);
kgrid=0;
column=0;
index=1;
plt=0; 
jstep=round((jmax/3)-1);
image=0;
for j=1:jstep:jmax
  index=j;
  [z,sc,Cs]=scoord2(grd_file,theta_s,theta_b,Tcline,N,kgrid,column, ...
                           index,plt);
  if vname(1)=='u',
    z=0.5*(z(1:imax,:)+z(2:imax+1,:));
  end;

  image=image+1;
  subplot(2,2,image)
  field=squeeze(var(:,j,:));
  topo=squeeze(h(:,j));
  mask_vert=squeeze(mask(:,j));
  dx=1./squeeze(pm(:,j));
  xrad(1)=0;
  for i=2:dim_var(1)
    xrad(i)=xrad(i-1)+0.5*(dx(i)+dx(i-1));
  end
  x=zeros(dim_var(1),N);
  masksection=zeros(dim_var(1),N);
  for i=1:dim_var(1)
    for k=1:N
      x(i,k)=xrad(i);
      masksection(i,k)=mask_vert(i);
    end
  end
  xrad=xrad/1000;
  x=x/1000;
  field=masksection.*field;
  pcolor(x,z,field) 
  colorbar
  shading flat
  hold on
  plot(xrad,-topo,'k')
  hold off
  title(num2str(j))
end











