
function rgrd_ExtractInitial_noInterp(ctl,grd,grd1,initfile,time,sub_I,sub_J)

sub_Iu=sub_I(1):sub_I(end-1);
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end-1);

rnt_makeinifile(grd1,initfile);
vars={'temp' 'salt' 'v' 'u' 'ubar' 'vbar' 'zeta'};
nc=netcdf(initfile,'w');
nc{'ocean_time'}(1) = ctl.time(time);

for i=1:4
      vars{i}
	tmp=rnt_loadvar(ctl,time,vars{i});
      sub_i=sub_I; sub_j=sub_J;
	if i==3, sub_i=sub_Iv; sub_j=sub_Jv; end
	if i==4, sub_i=sub_Iu; sub_j=sub_Ju; end
	
	tmp=tmp(sub_i,sub_j,:);
%	size(tmp)
%	nc{vars{i}}
	nc{vars{i}}(1,:,:,:) = perm(tmp);
end
close(nc)

nc=netcdf(initfile,'w');
for i=5:7
        vars{i}
	tmp=rnt_loadvar(ctl,time,vars{i});
      sub_i=sub_I; sub_j=sub_J;
	if i==6, sub_i=sub_Iv; sub_j=sub_Jv; end
	if i==5, sub_i=sub_Iu; sub_j=sub_Ju; end
	
	tmp=tmp(sub_i,sub_j);
        nc{vars{i}}(1,:,:) = perm(tmp);
end
close(nc);

% /d6/edl/ROMS-pak/matlib/rnt/rnt_grid2gridN.m
return

