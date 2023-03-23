%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute initial file for the embedded grid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

CONFIG      = 'sd';
CHILD_LEVEL = 1;
tindex      = 1;

%..........................................................
if CHILD_LEVEL>1,
  plev=['.',num2str(CHILD_LEVEL-1)]; else, plev='';
end;
clev=['.',num2str(CHILD_LEVEL)];

grdname = [CONFIG,num2str(CHILD_LEVEL - 1)];
grd_parent = rnt_gridload(grdname);

grdname = [CONFIG,num2str(CHILD_LEVEL)];
grd_child = rnt_gridload(grdname);

grd_global.parent = grd_parent;
grd_global.child = grd_child;

parent_grd =[CONFIG,'_grid.nc',plev];
child_grd  =[CONFIG,'_grid.nc',clev];
parent_ini =[CONFIG,'_his_n100.nc',plev];
child_ini  =[CONFIG,'_his_n100.nc',clev];

title=['Initial file for the embedded grid :',child_ini,...
' using parent initial file: ',parent_ini];
disp(' ')
disp(title)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Read in the embedded grid
%
disp(' ')
disp(' Read in the embedded grid...')
nc=netcdf(child_grd);
%parent_grd=nc.parent_grid(:);
imin=nc{'grd_pos'}(1);
imax=nc{'grd_pos'}(2);
jmin=nc{'grd_pos'}(3);
jmax=nc{'grd_pos'}(4);
refinecoeff=nc{'refine_coef'}(:);
result=close(nc);
nc=netcdf(parent_grd);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
result=close(nc);
%
% Read in the parent forcing file
%
disp(' ')
disp(' Read in the parent initial file...')
nc = netcdf(parent_ini);
theta_s = nc{'theta_s'}(:);
theta_b = nc{'theta_b'}(:);
Tcline = nc{'Tcline'}(:);
N = length(nc('s_rho'));
time = nc{'scrum_time'}(tindex);
result=close(nc);
%
% Create the initial file
%
disp(' ')
disp(' Create the initial file...')
ncini=create_inifile(child_ini,child_grd,parent_ini,title,...
                     theta_s,theta_b,Tcline,N,time,'clobber');
%
% parent indices
%
[igrd_r,jgrd_r]=meshgrid((1:1:Lp),(1:1:Mp));
[igrd_p,jgrd_p]=meshgrid((1:1:Lp-1),(1:1:Mp-1));
[igrd_u,jgrd_u]=meshgrid((1:1:Lp-1),(1:1:Mp));
[igrd_v,jgrd_v]=meshgrid((1:1:Lp),(1:1:Mp-1));
%
% the children indices
%
ipchild=(imin:1/refinecoeff:imax);
jpchild=(jmin:1/refinecoeff:jmax);
irchild=(imin+0.5-0.5/refinecoeff:1/refinecoeff:imax+0.5+0.5/refinecoeff);
jrchild=(jmin+0.5-0.5/refinecoeff:1/refinecoeff:jmax+0.5+0.5/refinecoeff);
[ichildgrd_p,jchildgrd_p]=meshgrid(ipchild,jpchild);
[ichildgrd_r,jchildgrd_r]=meshgrid(irchild,jrchild);
[ichildgrd_u,jchildgrd_u]=meshgrid(ipchild,jrchild);
[ichildgrd_v,jchildgrd_v]=meshgrid(irchild,jpchild);

%
% interpolations
% 
disp(' ')
disp(' Do the interpolations...')   
                  
% 2-D fields
np=netcdf(parent_ini);
disp('zeta ...')
nestvar3d_manu(np,ncini,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'zeta',tindex,grd_global)
disp('ubar ...')
nestvar3d_manu(np,ncini,igrd_u,jgrd_u,ichildgrd_u,jchildgrd_u,'ubar',tindex,grd_global)
disp('vbar ...')
nestvar3d_manu(np,ncini,igrd_v,jgrd_v,ichildgrd_v,jchildgrd_v,'vbar',tindex,grd_global)
result=close(np);
result=close(ncini);

% 3-D fields
disp('u ...')
sig2sig_manu(parent_grd,parent_ini,child_grd,child_ini,'u',tindex,grd_global)
disp('v ...')
sig2sig_manu(parent_grd,parent_ini,child_grd,child_ini,'v',tindex,grd_global)
disp('temp ...')
sig2sig_manu(parent_grd,parent_ini,child_grd,child_ini,'temp',tindex,grd_global)
disp('salt ...')
sig2sig_manu(parent_grd,parent_ini,child_grd,child_ini,'salt',tindex,grd_global)

%
% Make a plot
%
%disp(' ')
%disp(' Make a plot...')
%test_clim(child_ini,'temp',1)


