
function [grdp, grdc ]=rgrd_ex_init_nested_oa(ctlp,grdp,grdc,initfile,time,opt)
%function [grd1, state]=rgrd_ExtractInitial_2(ctl,grd,grd1,initfile,time,decorr)
%  Extract  model state at time index TIME from CTL from grid GRD
% and store it in file INITFILE on grid GRD1
%
%
%  04/05  E. Di Lorenzo (edl@eas.gatech.edu)

%vars={'temp' 'salt' 'v' 'u' 'ubar' 'vbar' 'zeta'};
vars=opt.vars;
decorr=opt.decorr
nc=netcdf(initfile,'w');

for i=1:length(vars)
  if opt.dims(i)==3
      vars{i}
	[out,grdp,grdc]=rnt_grid2gridN(grdp,grdc,ctlp,time,vars{i},decorr);
	nc{vars{i}}(1,:,:,:) = perm(out.data);
  end
  if opt.dims(i)==2
       vars{i}
       [out,grdp,grdc]=rnt_grid2gridN(grdp,grdc,ctlp,time,vars{i},decorr);
       nc{vars{i}}(1,:,:) = perm(out.data);  
  end
end
close(nc)

% /d6/edl/ROMS-pak/matlib/rnt/rnt_grid2gridN.m
return

