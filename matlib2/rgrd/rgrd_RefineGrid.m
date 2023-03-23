
function rgrd_RefineGrid(inp)
disp('need to complete...')
return
%function rgrd_RefineGrid(inp)
%parent_grd=inp.parent_grd;
%refine_grd=inp.refine_grd;
%refinecoeffe=inp.refinecoeffe;
%refinecoeffx=inp.refinecoeffx;
%newtopo = inp.newtopo; 
%topofile=inp.topofile;
%rtarget=inp.rtarget;
%nband=inp.nband;    %number of point used to connect the parent to 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  compute the embedded grid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%close all
parent_grd=inp.parent_grd;
refine_grd=inp.refine_grd;
%refinecoeff=2;
refinecoeffe=inp.refinecoeffe;
refinecoeffx=inp.refinecoeffx;

newtopo = inp.newtopo; % newtopo =1 if we add and smooth a new topo instead 
             % of simply interpoling the parent one
topofile=inp.topofile;
%rtarget=0.15; %r maximum value for the smoothing
rtarget=inp.rtarget;%0.15; %r maximum value for the smoothing
nband=inp.nband;    %number of point used to connect the parent to 

% Title
%
%
% Read in the parent grid
%
disp(' ')
disp(' Read in the parent grid ...')

nc=netcdf(parent_grd);
latp_parent=nc{'lat_psi'}(:);
lonp_parent=nc{'lon_psi'}(:);
xp_parent=nc{'x_psi'}(:);
yp_parent=nc{'y_psi'}(:);
maskp_parent=nc{'mask_psi'}(:);

latu_parent=nc{'lat_u'}(:);
lonu_parent=nc{'lon_u'}(:);
xu_parent=nc{'x_u'}(:);
yu_parent=nc{'y_u'}(:);
masku_parent=nc{'mask_u'}(:);


latv_parent=nc{'lat_v'}(:);
lonv_parent=nc{'lon_v'}(:);
xv_parent=nc{'x_v'}(:);
yv_parent=nc{'y_v'}(:);
maskv_parent=nc{'mask_v'}(:);


latr_parent=nc{'lat_rho'}(:);
lonr_parent=nc{'lon_rho'}(:);
xr_parent=nc{'x_rho'}(:);
yr_parent=nc{'y_rho'}(:);
maskr_parent=nc{'mask_rho'}(:);

h_parent=nc{'h'}(:);
f_parent=nc{'f'}(:);
angle_parent=nc{'angle'}(:);
pm_parent=nc{'pm'}(:);

result=close(nc);

hmin = min(min(h_parent));
hmin=250;
disp(' ')
%disp(['  hmin force XA = ',num2str(hmin)])
%
% Parent indices
%
[Mp,Lp]=size(h_parent);
[igrd_r,jgrd_r]=meshgrid((1:1:Lp),(1:1:Mp));
[igrd_p,jgrd_p]=meshgrid((1:1:Lp-1),(1:1:Mp-1));
[igrd_u,jgrd_u]=meshgrid((1:1:Lp-1),(1:1:Mp));
[igrd_v,jgrd_v]=meshgrid((1:1:Lp),(1:1:Mp-1));
%
jmin=1;
jmax=Mp-1;
imin=1;
imax=Lp-1;

title=['USWC Grid at 7km ',parent_grd, ...
' - positions in the parent grid: ',num2str(imin),' - ',...
num2str(imax),' - ',num2str(jmin),' - ',num2str(jmax)];
disp(title)

ipchild=(imin:1/refinecoeffx:imax)
%jpchild=(jmin+1/refinecoeff:1/refinecoeff:jmax-1/refinecoeff);
jpchild=(jmin:1/refinecoeffe:jmax)
irchild=(imin+0.5/refinecoeffx:1/refinecoeffx:imax+1-0.5/refinecoeffx);
jrchild=(jmin+0.5/refinecoeffe:1/refinecoeffe:jmax+1-0.5/refinecoeffe);
[ichildgrd_p,jchildgrd_p]=meshgrid(ipchild,jpchild);
[ichildgrd_r,jchildgrd_r]=meshgrid(irchild,jrchild);
[ichildgrd_u,jchildgrd_u]=meshgrid(ipchild,jrchild);
[ichildgrd_v,jchildgrd_v]=meshgrid(irchild,jpchild);
%
% interpolations
%
disp(' ')
disp(' Do the interpolations...')
lonpchild=interp2(igrd_p,jgrd_p,lonp_parent,ichildgrd_p,jchildgrd_p,'linear');
latpchild=interp2(igrd_p,jgrd_p,latp_parent,ichildgrd_p,jchildgrd_p,'linear');
xpchild=interp2(igrd_p,jgrd_p,xp_parent,ichildgrd_p,jchildgrd_p,'linear');
ypchild=interp2(igrd_p,jgrd_p,yp_parent,ichildgrd_p,jchildgrd_p,'linear');

lonuchild=interp2(igrd_u,jgrd_u,lonu_parent,ichildgrd_u,jchildgrd_u,'linear');
latuchild=interp2(igrd_u,jgrd_u,latu_parent,ichildgrd_u,jchildgrd_u,'linear');
xuchild=interp2(igrd_u,jgrd_u,xu_parent,ichildgrd_u,jchildgrd_u,'linear');
yuchild=interp2(igrd_u,jgrd_u,yu_parent,ichildgrd_u,jchildgrd_u,'linear');


lonvchild=interp2(igrd_v,jgrd_v,lonv_parent,ichildgrd_v,jchildgrd_v,'linear');
latvchild=interp2(igrd_v,jgrd_v,latv_parent,ichildgrd_v,jchildgrd_v,'linear');
xvchild=interp2(igrd_v,jgrd_v,xv_parent,ichildgrd_v,jchildgrd_v,'linear');
yvchild=interp2(igrd_v,jgrd_v,yv_parent,ichildgrd_v,jchildgrd_v,'linear');

lonrchild=interp2(igrd_r,jgrd_r,lonr_parent,ichildgrd_r,jchildgrd_r,'linear');
latrchild=interp2(igrd_r,jgrd_r,latr_parent,ichildgrd_r,jchildgrd_r,'linear');
xrchild=interp2(igrd_r,jgrd_r,xr_parent,ichildgrd_r,jchildgrd_r,'linear');
yrchild=interp2(igrd_r,jgrd_r,yr_parent,ichildgrd_r,jchildgrd_r,'linear');
maskrold=interp2(igrd_r,jgrd_r,maskr_parent,ichildgrd_r,jchildgrd_r,'nearest');

hchild=interp2(igrd_r,jgrd_r,h_parent,ichildgrd_r,jchildgrd_r,'linear');
anglechild=interp2(igrd_r,jgrd_r,angle_parent,ichildgrd_r,jchildgrd_r,'linear');
fchild=interp2(igrd_r,jgrd_r,f_parent,ichildgrd_r,jchildgrd_r,'linear');
pmchild=interp2(igrd_r,jgrd_r,pm_parent,ichildgrd_r,jchildgrd_r,'linear');
%
% Create the grid file
%
disp(' ')
disp(' Create the grid file...')
[Mchild,Lchild]=size(latpchild);
create_grid(Lchild,Mchild,refine_grd,parent_grd,title)
%
% Fill the grid file
%
disp(' ')
disp(' Fill the grid file...')
nc=netcdf(refine_grd,'write');
nc{'refine_coef'}(:)=refinecoeffe;
nc{'grd_pos'}(:) = [imin,imax,jmin,jmax];
size(latuchild)
size(latrchild)
nc{'lat_u'}
nc{'lat_u'}(:)=latuchild;
nc{'lon_u'}(:)=lonuchild;
nc{'x_u'}(:)=xuchild;
nc{'y_u'}(:)=yuchild;

nc{'lat_v'}(:)=latvchild;
nc{'lon_v'}(:)=lonvchild;
nc{'x_v'}(:)=xvchild;
nc{'y_v'}(:)=yvchild;

nc{'lat_rho'}(:)=latrchild;
nc{'lon_rho'}(:)=lonrchild;
nc{'x_rho'}(:)=xrchild;
nc{'y_rho'}(:)=yrchild;

nc{'lat_psi'}(:)=latpchild;
nc{'lon_psi'}(:)=lonpchild;
nc{'x_psi'}(:)=xpchild;
nc{'y_psi'}(:)=ypchild;

nc{'hraw'}(2,:,:)=hchild;
nc{'angle'}(:)=anglechild;
nc{'f'}(:)=fchild;
nc{'spherical'}(:)='T';
result=close(nc);
%
%  Compute the metrics
%
disp(' ')
disp(' Compute the metrics...')
[pm,pn,dndx,dmde]=get_metrics(refine_grd);
%
%  Add topography
%
  disp(' Add topography...')
  hnew=add_topo(refine_grd,topofile);
nc=netcdf(refine_grd,'write');
nc{'hraw'}(1,:,:)=hnew;

%
% Compute the mask
%
%maskrchild=(hnew>=0.);
maskrchild=maskrold;
maskrchild(Mchild,:)=maskrold(Mchild,:);
maskrchild(1,:)=maskrold(1,:);
maskrchild(:,1)=maskrold(:,1);
maskrchild(:,Lchild)=maskrold(:,Lchild);
[maskuchild,maskvchild,maskpchild]=uvp_mask(maskrchild);
%
%  Smooth the topography
%
hnew2=hnew;
hnew2 = smoothgrid2(hnew2,hmin,rtarget);
%  disp(' Connect the topography...')
%  [hnew2,alpha]=connect_topo(hnew2,hchild,nband);
end
%
%  Write it down
%
disp(' ')
disp(' Write it down...')
nc=netcdf(refine_grd,'write');
%nc{'alpha'}(:)=alpha;
nc{'h'}(:)=hnew2;
%if newtopo ==1
%nc{'hraw'}(2,:,:)=hnew;
%end
nc{'pm'}(:)=pm;
nc{'pn'}(:)=pn;
nc{'dndx'}(:)=dndx;
nc{'dmde'}(:)=dmde;
nc{'mask_u'}(:)=maskuchild;
nc{'mask_v'}(:)=maskvchild;
nc{'mask_psi'}(:)=maskpchild;
nc{'mask_rho'}(:)=maskrchild;
result=close(nc);
disp(' ')
disp(['  Size of the grid (param.h values) :  Lm = ',...
      num2str(Lchild-1),' - Mm = ',num2str(Mchild-1)])
%
% make a plot
%
disp(' ')
disp(' Do a plot...')
warning off
themask=maskr_parent./maskr_parent;
warning on
pcolor(lonr_parent,latr_parent,h_parent.*themask)
axis image 
colorbar
shading interp
hold on
lonbox=cat(1,lonp_parent(jmin:jmax,imin),  ...
                lonp_parent(jmax,imin:imax)' ,...
                lonp_parent(jmax:-1:jmin,imax),...
                lonp_parent(jmin,imax:-1:imin)' );
latbox=cat(1,latp_parent(jmin:jmax,imin),  ...
                latp_parent(jmax,imin:imax)' ,...
                latp_parent(jmax:-1:jmin,imax),...
                latp_parent(jmin,imax:-1:imin)' );
plot(lonbox,latbox,'k')
loncbox=cat(1,lonpchild(1:Mchild,1),  ...
                lonpchild(Mchild,1:Lchild)' ,...
                lonpchild(Mchild:-1:1,Lchild),...
                lonpchild(1,Lchild:-1:1)' );
latcbox=cat(1,latpchild(1:Mchild,1),  ...
               latpchild(Mchild,1:Lchild)' ,...
                latpchild(Mchild:-1:1,Lchild),...
                latpchild(1,Lchild:-1:1)' );

plot(loncbox,latcbox,'w--')
hold off

figure
warning off
themask=maskrchild./maskrchild;
warning on
pcolor(lonrchild,latrchild,themask.*(hnew2-hnew))
caxis([-1000 100])
%pcolor(lonrchild,latrchild,(0.*hnew2+hgene).*themask)
shading flat
axis image 
colorbar
hold on
contour(lonrchild,latrchild,hnew2,[100 200 500 1000 2000 4000],'k')
contour(lonrchild,latrchild,hchild,[100 200 500 1000 2000 4000],'k--')
handle=plot_coast('coast.dat');
set(handle,'LineWidth',2)
plot(lonbox,latbox,'k')
plot(loncbox,latcbox,'w--')
hold off
axis([min(min(lonrchild)) max(max(lonrchild)),...
      min(min(latrchild)) max(max(latrchild))])

