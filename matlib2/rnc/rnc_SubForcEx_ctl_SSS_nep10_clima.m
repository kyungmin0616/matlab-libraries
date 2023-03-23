function rnc_SubForcEx_ctl_SSS_nep10(ctlf,grd,forcfileo,grdo,sub_I,sub_J,forc_timevars,forc_vars)

sub_Iu=sub_I(1):sub_I(end-1);
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end-1);


% Create empty forcing file
clear opt
for iv=1:length(forc_timevars)
   myvar=forc_timevars{iv};
   timeVal=ctlf.time;
   idn=length(timeVal);
   %cycle=nc{forc_timevars{iv}}.cycle_length(1);
   cycle=360;
   
   str=['opt.',forc_timevars{iv},'=idn;']; eval(str);
   str=['opt.',forc_timevars{iv},'_cycle=cycle;'];eval(str);
   str=['opt.',forc_timevars{iv},'Val=timeVal;'];eval(str);
end   
   rnc_CreateForcFile(grdo, forcfileo, opt);
   

I=sub_I; J=sub_J;
disp('SSS');
sss=rnt_loadvar_segp(ctlf,1:length(ctlf.time),'salt',I,J,grd.N);
disp('swflux');
swflux=rnt_loadvar_segp(ctlf,1:length(ctlf.time),'ssflux',I,J,1);
swflux=swflux./sss;
swflux(isnan(swflux))=0;

nco=netcdf(forcfileo,'w');
nco{'swflux'}(:,:,:) = perm(swflux);
nco{'SSS'}(:,:,:) = perm(sss);
close(nco);

