function rnc_SubForcEx_ctl_SST_nep10(ctlf,grd,forcfileo,grdo,sub_I,sub_J,forc_timevars,forc_vars)

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
   cycle=ctlf.time(end);
   
   str=['opt.',forc_timevars{iv},'=idn;']; eval(str);
   str=['opt.',forc_timevars{iv},'_cycle=cycle;'];eval(str);
   str=['opt.',forc_timevars{iv},'Val=timeVal;'];eval(str);
end   
   rnc_CreateForcFile(grdo, forcfileo, opt);
   

nco=netcdf(forcfileo,'w');
for iv=1:length(forc_timevars)
   myvar=forc_vars{iv};
   disp(myvar);
   I=sub_I; J=sub_J;
   if strcmp(myvar,'sustr') == 1, I=sub_Iu; J=sub_Ju; end
   if strcmp(myvar,'svstr') == 1, I=sub_Iv; J=sub_Jv; end
   tmp=rnt_loadvar_segp(ctlf,1:length(ctlf.time),'temp',I,J,grd.N);
   nco{myvar}(:,:,:) = perm(tmp);
end
close(nco);

