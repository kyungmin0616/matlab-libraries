

function rnc_Interp2grid_NCEP(ctl,dd,grd);
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function rnc_Interp2grid_NCEP(ctlf,ncep,grd)
%
%      INPUT: ctlf    control array for forcing files
%             MYDATENUM date at which you want to extract forcing in MATLAB 
%                       datenum format
%             AVG_FREQ  frequency of averaging 'daily', 'monthly' or 'clima'
%                       if spelled wrong, you will get the clima!
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%


%==========================================================
%	Radiation flux
%==========================================================

for it=1:length(ctl.datenum)

if isfield(dd,'swrad')
    tmp=dd.swrad(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'swrad',field);
end

if isfield(dd,'shflux')
    tmp=dd.shflux(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'shflux',field);
end

if isfield(dd,'swflux')
    tmp=dd.swflux(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'swflux',field);
end

if isfield(dd,'SST')
    tmp=dd.SST(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'SST',field);
end

if isfield(dd,'SSS')
    tmp=dd.SSS(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'SSS',field);
end

if isfield(dd,'dQdSST')
    tmp=dd.dQdSST(:,:,it);
    field= interp2((dd.lon)',(dd.lat)', tmp', ...
                      grd.lonr,grd.latr,'cubic');   
    rnt_savevar(ctl,it,'dQdSST',field);
end

pp=0;
if isfield(dd,'sustr') & isfield(dd,'svstr') 
    
    sv=interp2((dd.lon)',(dd.lat)', dd.svstr(:,:,it)', ...
       grd.lonr,grd.latr,'cubic');
    su=interp2((dd.lon)',(dd.lat)', dd.sustr(:,:,it)', ...
       grd.lonr,grd.latr,'cubic');
	 
    [ su, sv ] = rnt_rotate(su,sv,grd.angle);
    sustr_tmp=rnt_2grid(su,'r','u');
    svstr_tmp=rnt_2grid(sv,'r','v');
    rnt_savevar(ctl,it,'sustr',sustr_tmp);
    rnt_savevar(ctl,it,'svstr',svstr_tmp);      
end

end
