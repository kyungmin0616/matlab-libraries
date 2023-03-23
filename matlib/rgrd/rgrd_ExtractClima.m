
function rgrd_ExtractClima(grd,grd1,climfile,climfile1)


%rnt_makeclimafile(grd1,climfile1);

timevar={'tclm_time' 'sclm_time'  'vclm_time' 'uclm_time' 'vclm_time' 'uclm_time' 'ssh_time'};
vars={   'temp'       'salt'       'v'         'u'         'vbar'      'ubar'     'zeta'};

nc=netcdf(climfile);
nc1=netcdf(climfile1,'w');
for i=1:4
   timevar{i}
   ctl = rnt_timectl( { climfile }, timevar{i});
   for it=1:length(ctl.time)
         [out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,it,vars{i});
	   nc1{vars{i}}(it,:,:,:) = perm(out.data);
   end   
   nc1{ timevar{i} }(:) = nc{ timevar{i} }(:);
end
close(nc);
close(nc1);


nc=netcdf(climfile);
nc1=netcdf(climfile1,'w');
for i=5:7
   timevar{i}
   ctl = rnt_timectl( { climfile }, timevar{i});
   for it=1:length(ctl.time)
         [out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,it,vars{i});
	   nc1{vars{i}}(it,:,:,:) = perm(out.data);
   end   
   nc1{ timevar{i} }(:) = nc{ timevar{i} }(:);
end
close(nc);
close(nc1);

