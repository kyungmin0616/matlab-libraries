
function grd1=rgrd_ForcingGrid2Grid(grd,forcingfiles,grd1,forcfile,vars,varstime,decorr)


% find subset of indeces
[I,J] = rgrd_FindInsideIJ(grd1.lonr,grd1.latr,grd.lonr,grd.latr);
if length(I) < 1, disp('Grids do not match ... RETURN'); return; end

sub_I=I;
sub_J=J;

sub_Iu=sub_I(1):sub_I(end)-1;
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end)-1;
found_svstr=0;
found_sustr=0;

      I=sub_Iu; J=sub_Ju;
	grd.lonu=grd.lonu(I,J); grd.latu=grd.latu(I,J); grd.masku=grd.masku(I,J);
      I=sub_Iv; J=sub_Jv;
	grd.lonv=grd.lonv(I,J); grd.latv=grd.latv(I,J); grd.maskv=grd.maskv(I,J);
      I=sub_I; J=sub_J;
	grd.lonr=grd.lonr(I,J); grd.latr=grd.latr(I,J); grd.maskr=grd.maskr(I,J);

	

k=0;

for ivar=1:length(vars);
varname=vars{ivar};
vartimename=varstime{ivar};				  
if strcmp(varname,'sustr') 
	   grd1.pmapu=rnt_oapmap(grd.lonu,grd.latu,grd.masku,grd1.lonr,grd1.latr,10); 
	   found_sustr=1;

elseif strcmp(varname,'svstr') 
	   grd1.pmapv=rnt_oapmap(grd.lonv,grd.latv,grd.maskv,grd1.lonr,grd1.latr,10); 
	   found_svstr=1;
else
	grd1.pmapr=rnt_oapmap(grd.lonr,grd.latr,grd.maskr,grd1.lonr,grd1.latr,10); 
	k=k+1;
	vars2{k} = varname;
	varstime{k}=vartimename;
end
end
	
%==========================================================
%	do wind stress vector
%==========================================================
if found_sustr==1 & found_svstr==1	
ctlf = rnt_timectl(forcingfiles, 'sms_time');
nc=netcdf(forcfile,'w');
for it=1:length(ctlf.time)
   disp(['sustr  TIME ',num2str(it)]); 
   field=rnt_loadvar_segp(ctlf,it,'sustr',sub_Iu,sub_Ju,1);
   [dataout,error]=rnt_oa2d(grd.lonu,grd.latu,field.*grd.masku, ...
                           grd1.lonr,grd1.latr,decorr,decorr,grd1.pmapu);				   
   ustress=shapiro2(dataout,2,2);

   disp(['svstr  TIME ',num2str(it)]); 
   field=rnt_loadvar_segp(ctlf,it,'svstr',sub_Iv,sub_Jv,1);
   [dataout,error]=rnt_oa2d(grd.lonv,grd.latv,field.*grd.maskv, ...
                           grd1.lonr,grd1.latr,decorr,decorr,grd1.pmapv);				   
   vstress=shapiro2(dataout,2,2);
   [u,v]=rnt_rotate(ustress,vstress,grd1.angle);
   u=rnt_2grid(u,'r','u');
   v=rnt_2grid(v,'r','v');
   nc{'sustr'}(it,:,:)=u';
   nc{'svstr'}(it,:,:)=v';
end
close(nc);
end

%==========================================================
%	all variables but winds
%==========================================================
for ivar=1:length(vars2);
varname = vars2{ivar};
ctlf = rnt_timectl(forcingfiles, varstime2{ivar});
nc=netcdf(forcfile,'w');
for it=1:length(ctlf.time)
   disp([varname, '  TIME ',num2str(it)]); 
   field=rnt_loadvar_segp(ctlf,it,varname,sub_I,sub_J,1);
   [dataout,error]=rnt_oa2d(grd.lonr,grd.latr,field.*grd.maskr, ...
                   grd1.lonr,grd1.latr,decorr,decorr,grd1.pmapr);
   dataout=shapiro2(dataout,2,2);
   %dataout(isnan(mask1))=0.0;
   
   nc{varname}(it,:,:)=dataout';
end
close(nc);
end
