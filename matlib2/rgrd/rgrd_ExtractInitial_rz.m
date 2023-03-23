
function [grd1, state]=rgrd_ExtractInitial(ctl,grd,grd1,initfile,time,decorr)
%function [grd1, state]=rgrd_ExtractInitial(ctl,grd,grd1,initfile,time,decorr)
%  Extract  model state at time index TIME from CTL from grid GRD
% and store it in file INITFILE on grid GRD1

rnc_CreateIniFile(grd1,initfile);
vars={'temp' 'salt' 'v' 'u' 'ubar' 'vbar' 'zeta'};
nc=netcdf(initfile,'w');
nc{'ocean_time'}(1) = ctl.time(time);

for i=1:4
      vars{i}
	[out,grd,grd1]=rnt_grd2grd_rz(grd,grd1,ctl,time,vars{i},decorr);
	nc{vars{i}}(1,:,:,:) = perm(out.data);
end
close(nc)
nc=netcdf(initfile,'w');
for i=5:7
        vars{i}
        [out,grd,grd1]=rnt_grd2grd_rz(grd,grd1,ctl,time,vars{i},decorr);
        nc{vars{i}}(1,:,:) = perm(out.data);
end
close(nc);

% /d6/edl/ROMS-pak/matlib/rnt/rnt_grid2gridN.m
return

% Kraig and Manu
% Wed Apr 14 17:46:29 PDT 2004

temp = rnt_loadvar(ctl,time,'temp');
maxz=max(grd.h(:));
z = [0:20:200 250:50:500 600:100:1000 1300:300:5000];
zr=rnt_setdepth(0,grd);
tempz=rnt_2z(temp,zr,-z);

for k=1:length(z)
k
   tmp(:,:,k) = rnt_fill(grd.lonr,grd.latr,tempz(:,:,k),4, 4);
end   
