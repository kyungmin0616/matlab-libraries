
function rgrd_ExtractForcing_noInterp(ncfile1,ncfile2,sub_I,sub_J)

disp('this function is not complete. sorry. -manu');
return
vars1= ...
    {'shf_time' 'srf_time' 'swf_time'  'sms_time'  'sst_time' 'sss_time'};

vars= ...
    {'shflux'   'swrad'    'swflux' 'SST'  'SSS' 'dQdSST' 'sustr' 'svstr' };


sub_Iu=sub_I(1):sub_I(end-1);
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end-1);


nc1=netcdf(ncfile1);
nc2=netcdf(ncfile2,'w');
for i=1:6
   nc2{vars1{i}}(:)=nc1{vars1{i}}(:);
end
close(nc1);
close(nc2);
 

ctl=rnt_ctl(ncfile1,'sms_time');


nc=netcdf(initfile,'w');
for time=1:length(ctl.time);
time
for i=7:8
      disp(vars{i})
	tmp=rnt_loadvar(ctl,time,vars{i});
      sub_i=sub_I; sub_j=sub_J;
	if i==8, sub_i=sub_Iv; sub_j=sub_Jv; end
	if i==7, sub_i=sub_Iu; sub_j=sub_Ju; end
	
	tmp=tmp(sub_i,sub_j);
%	size(tmp)
%	nc{vars{i}}
	nc{vars{i}}(time,:,:) = perm(tmp);
end
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

