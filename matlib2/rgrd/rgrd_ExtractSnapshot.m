
function [grd1, state]=rgrd_ExtractSnapshot(ctl,grd,grd1,outfile,timeIN,timeOUT,decorr)



if ~exist(outfile)
rnt_makeinifile(grd1,outfile);
%disp('creating file');
end
%timeOUT
vars={'temp' 'salt' 'u' 'v' 'ubar' 'vbar' 'zeta'};
nc=netcdf(outfile,'w');
nc{'ocean_time'}(timeOUT) = ctl.time(timeIN);

      i=1;
      disp(vars{i});
	[out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,timeIN,vars{i},decorr);
	nc{vars{i}}(timeOUT,:,:,:) = perm(out.data);
      state.temp=out.data;
      i=2;
      disp(vars{i});
	[out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,timeIN,vars{i},decorr);
	nc{vars{i}}(timeOUT,:,:,:) = perm(out.data);
      state.salt=out.data;


      disp(vars{3});
	[out,grd,grd1]=rnt_grid2gridUV(grd,grd1,ctl,timeIN,vars{3},decorr);
	u=out.data;
	disp(vars{4});
	[out,grd,grd1]=rnt_grid2gridUV(grd,grd1,ctl,timeIN,vars{4},decorr);
	v=out.data;
	[u,v]=rnt_rotate(u,v,grd1.angle);
      u=rnt_2grid(u,'r','u');
      v=rnt_2grid(v,'r','v');	
	nc{vars{3}}(timeOUT,:,:,:) = perm(u);
	nc{vars{4}}(timeOUT,:,:,:) = perm(v);
	state.u=u;
	state.v=v;

      disp(vars{5});
	[out,grd,grd1]=rnt_grid2gridUV(grd,grd1,ctl,timeIN,vars{5},decorr);
	u=out.data;
	disp(vars{6});
	[out,grd,grd1]=rnt_grid2gridUV(grd,grd1,ctl,timeIN,vars{6},decorr);
	v=out.data;
	[u,v]=rnt_rotate(u,v,grd1.angle);
      u=rnt_2grid(u,'r','u');
      v=rnt_2grid(v,'r','v');	
	nc{vars{5}}(timeOUT,:,:) = perm(u);
	nc{vars{6}}(timeOUT,:,:) = perm(v);
	state.ubar=u;
	state.vbar=v;
	

        i=7;
        disp(vars{i});
        [out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,timeIN,vars{i},decorr);
        nc{vars{i}}(timeOUT,:,:) = perm(out.data);
        state.zeta=out.data;
	  
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
