%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Compute restart file for the embedded grid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

CONFIG = 'usw15_z40';
CHILD_LEVEL = 3;

YEAR   = 2;
MONTH  = 12;

tindex  = 1;
biol    = 0;
infofile= 'usw15_z40_levdec.nc';

%..........................................................
if CHILD_LEVEL>1,
  plev=['.',num2str(CHILD_LEVEL-1)];
else,
  plev='';
end;
clev=['.',num2str(CHILD_LEVEL)];

year=num2str(YEAR); month=num2str(MONTH);
parent_grd =[CONFIG,'_grid.nc',plev];
child_grd  =[CONFIG,'_grid.nc',clev];
parent_rst =[CONFIG,'_rst_Y',year,'M',month,'.nc',plev];
child_rst  =[CONFIG,'_rst_Y',year,'M',month,'.nc',clev];

%
% Title
%
title=['Restart file for the embedded grid :',child_rst,...
       ' using parent restart file: ',parent_rst];
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
limdomchild=[imin imax jmin jmax];

refinecoeff=nc{'refine_coef'}(:);
result=close(nc);
nc=netcdf(parent_grd);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
masku=nc{'mask_u'}(:);
maskv=nc{'mask_v'}(:);
maskrho=nc{'mask_rho'}(:);
result=close(nc);
%
% Read in the parent forcing file
%
disp(' ')
disp(' Read in the parent restart file...')
nc = netcdf(parent_rst);
N = length(nc('s_rho'));
time = nc{'scrum_time'}(tindex);
time_step=nc{'time_step'}(:);
result=close(nc);
%
% Create the restart file
%
disp(' ')
disp(' Create the restart file...')
ncrst=create_rstfile(child_rst,child_grd,parent_rst,title,...
                     N,time,time_step,'clobber');
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
np=netcdf(parent_rst);
nestvar(np,ncrst,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'zeta',tindex)
nestvar(np,ncrst,igrd_u,jgrd_u,ichildgrd_u,jchildgrd_u,'ubar',tindex)
nestvar(np,ncrst,igrd_v,jgrd_v,ichildgrd_v,jchildgrd_v,'vbar',tindex)
result=close(np);
result=close(ncrst);

% 3-D fields
sig2sig(parent_grd,parent_rst,child_grd,child_rst,'u',tindex,infofile)
sig2sig(parent_grd,parent_rst,child_grd,child_rst,'v',tindex,infofile)
sig2sig(parent_grd,parent_rst,child_grd,child_rst,'temp',tindex,infofile)
sig2sig(parent_grd,parent_rst,child_grd,child_rst,'salt',tindex,infofile)

if (biol==1)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'NO3',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'NH4',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'CHLA',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'PHYTO',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'ZOO',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'SDET',tindex,infofile)
  sig2sig(parent_grd,parent_rst,child_grd,child_rst,'LDET',tindex,infofile)
end;

%
% Make a plot
%
disp(' ')
%disp(' Make a plot...')
%test_rst(child_rst,child_grd,infofile,'temp',1)
