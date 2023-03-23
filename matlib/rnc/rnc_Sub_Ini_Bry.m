function rnc_Sub_Ini_Bry(ctl,grd,timeind_range,vars,grdo,sub_I,sub_J,bryfile,optbry,inifile,optini,timeind)
% Do a type rnt_Sub_Ini_Bry to see an example.


% extract initial
disp (['Creating Sub INI file  ',inifile]);
rnc_CreateIniFile(grdo,inifile,optini);
nc=netcdf(inifile,'w'); nc{'ocean_time'}(1)=ctl.time(timeind); close(nc);
state=rnt_loadStateSub(ctl,timeind,vars,grd,sub_I,sub_J);
ctlo=rnt_ctl(inifile);
rnt_saveState(ctlo,1,vars,state);


% extract openboundary conndition
disp (['Creating Sub BRY file  ',bryfile]);
rnc_CreateBryFile(grdo,bryfile, optbry);
rnc_SubBryEx(ctl,grd,grdo,timeind_range,bryfile,sub_I,sub_J);

% need o fix this so that it does not do biology unless it is asked for
% /drive/edl/matlib-master/rnc/rnc_SubBryEx.m


return

% example
% INPUTS
grdo=rnt_gridload('nepd-ccs');
bryfile='/drive/edl/NEPD/passive/nepd-ccs-bry.nc';
optbry.npzd=1;
optbry.bry_time = length(timeind_range);
optbry.bry_time_cycle=0;
optbry.ptracer = 0;
optbry.bry_timeVal = ctl.time(timeind_range)/60/60/24;

inifile='/drive/edl/NEPD/passive/nepd-ccs-ini.nc';
optini.npzd=1;
vars={'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta' ...
       'detritus' 'phytoplankton' 'zooplankton' 'NO3'};


rnc_Sub_Ini_Bry(ctl,grd,timeind_range,vars,grdo, ... 
          sub_I,sub_J,bryfile,optbry,inifile,optini,timeind)
