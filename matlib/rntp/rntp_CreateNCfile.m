function  CreateAvgNC(FileName,xdim,ydim,slev,itime,fields,varargin)
% function  CreateInitFile(FileName,xdim,ydim,slev,itime)
% Create initial condiion files of dimensions 
% xdim,ydim,slev,itime called FileName.
%  - E. Di Lorenzo (edl@ucsd.edu)


if nargin < 6
   help(mfilename)
   return
end   

nc = netcdf(FileName, 'clobber');
 
%% Global attributes:
 
nc.history = ncchar('ROMS ; created by E. Di Lorenzo');
if nargin ==7
   desc=varargin{1};
   nc.description = ncchar(desc);
end
 
%% Dimensions:
 
nc('xi_psi') = xdim-1;
nc('xi_rho') = xdim;
nc('xi_u') = xdim-1;
nc('xi_v') = xdim;
nc('eta_psi') = ydim-1;
nc('eta_rho') = ydim;
nc('eta_u') = ydim;
nc('eta_v') = ydim-1;
nc('s_rho') = slev;
nc('s_w') = slev+1;
nc('tracer') = 2;
nc('time') = itime; %% (record dimension)
 
%% Variables and attributes:
 
nc{'scrum_time'} = ncdouble('time'); %% 1 element.
nc{'scrum_time'}.long_name = ncchar('time since initialization');
nc{'scrum_time'}.units = ncchar('seconds, where 0 is YEAR=0, MONTH=1, DAY=1');
nc{'scrum_time'}.field = ncchar('time, scalar, series');
 
nc{'ocean_time'} = ncdouble('time'); %% 1 element.
nc{'ocean_time'}.long_name = ncchar('time since initialization');
nc{'ocean_time'}.units = ncchar('seconds, where 0 is YEAR=0, MONTH=1, DAY=1');
nc{'ocean_time'}.field = ncchar('time, scalar, series');

nc{'year'} = ncdouble('time'); %% 1 element.
nc{'year'}.long_name = ncchar('years; calendar is 360 days');

nc{'month'} = ncdouble('time'); %% 1 element.
nc{'month'}.long_name = ncchar('month');

nc{'day'} = ncdouble('time'); %% 1 element.
nc{'day'}.long_name = ncchar('day of month; each month is 30 days');

nc{'datenum'} = ncdouble('time'); %% 1 element.
nc{'datenum'}.long_name = ncchar('MATLAB datenum format');

nc{'cycle'}=ncdouble('time'); %% 1 element.
nc{'cycle'}.long_name = ncchar('Forcing Cycle number');

nc{'depths'} = ncdouble('s_rho'); %% 1 element.

for i = 1: length(fields)

if strcmp(fields{i},'u')
nc{'u'} = ncfloat('time', 's_rho', 'eta_u', 'xi_u'); %% 132840 elements.
nc{'u'}.long_name = ncchar('u-momentum component');
nc{'u'}.units = ncchar('meter second-1');
nc{'u'}.field = ncchar('u-velocity, scalar, series');
end

if strcmp(fields{i},'v')
nc{'v'} = ncfloat('time', 's_rho', 'eta_v', 'xi_v'); %% 132840 elements.
nc{'v'}.long_name = ncchar('v-momentum component');
nc{'v'}.units = ncchar('meter second-1');
nc{'v'}.field = ncchar('v-velocity, scalar, series');
end
 
if strcmp(fields{i},'zeta')
nc{'zeta'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 6724 elements.
nc{'zeta'}.long_name = ncchar('free-surface');
nc{'zeta'}.units = ncchar('meter');
nc{'zeta'}.field = ncchar('free-surface, scalar, series');
end

if strcmp(fields{i},'ubar')
nc{'ubar'} = ncfloat('time', 'eta_u', 'xi_u'); %% 2250 elements.
nc{'ubar'}.long_name = ncchar('vertically integrated u-momentum component');
nc{'ubar'}.units = ncchar('meter second-1');
nc{'ubar'}.field = ncchar('ubar-velocity, scalar, series');
end

if strcmp(fields{i},'vbar')
nc{'vbar'} = ncfloat('time', 'eta_v', 'xi_v'); %% 2254 elements.
nc{'vbar'}.long_name = ncchar('vertically integrated v-momentum component');
nc{'vbar'}.units = ncchar('meter second-1');
nc{'vbar'}.field = ncchar('vbar-velocity, scalar, series');
end

if strcmp(fields{i},'Hsbl') 
nc{'Hsbl'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 6724 elements.
nc{'Hsbl'}.long_name = ncchar('hbl-surface');
nc{'Hsbl'}.units = ncchar('meter');
nc{'Hsbl'}.field = ncchar('depth of surf. boundary layer, scalar, series');
end

 
if strcmp(fields{i},'temp')  
nc{'temp'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 134480 elements.
nc{'temp'}.long_name = ncchar('potential temperature');
nc{'temp'}.units = ncchar('Celsius');
nc{'temp'}.field = ncchar('temperature, scalar, series');
end

if strcmp(fields{i},'isoZ')
nc{'isoZ'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 134480 elements.
nc{'isoZ'}.long_name = ncchar('depth of isopycnal');
nc{'isoZ'}.units = ncchar('isoZ');
nc{'isoZ'}.field = ncchar('isoZ, scalar, series');
end

if strcmp(fields{i},'w')
nc{'w'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 134480 elements.
nc{'w'}.long_name = ncchar('w');
nc{'w'}.units = ncchar('w');
nc{'w'}.field = ncchar('w, scalar, series');
end

if strcmp(fields{i},'spice')
nc{'spice'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 134480 elements.
nc{'spice'}.long_name = ncchar('spice');
nc{'spice'}.units = ncchar('spice');
nc{'spice'}.field = ncchar('spice, scalar, series');
end
 
if strcmp(fields{i},'salt')  
nc{'salt'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 134480 elements.
nc{'salt'}.long_name = ncchar('salinity');
nc{'salt'}.units = ncchar('PSU');
nc{'salt'}.field = ncchar('salinity, scalar, series');
end
 
if strcmp(fields{i},'NO3') 
nc{'NO3'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'NO3'}.long_name = ncchar('averaged NO3 Nitrate');
nc{'NO3'}.units = ncchar('mmol N m-3');
nc{'NO3'}.field = ncchar('NO3, scalar, series');
end
 
if strcmp(fields{i},'NH4')  
nc{'NH4'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'NH4'}.long_name = ncchar('averaged NH4 Ammonium');
nc{'NH4'}.units = ncchar('mmol N m-3');
nc{'NH4'}.field = ncchar('NH4, scalar, series');
end
 
if strcmp(fields{i},'CHLA')  
nc{'CHLA'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'CHLA'}.long_name = ncchar('averaged Chlorophyll a');
nc{'CHLA'}.units = ncchar('mg chlorophyll a m-3');
nc{'CHLA'}.field = ncchar('Chlorophyll, scalar, series');
end
 
if strcmp(fields{i},'PHYTO')  
nc{'PHYTO'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'PHYTO'}.long_name = ncchar('averaged Phytoplankton');
nc{'PHYTO'}.units = ncchar('mmol N m-3');
nc{'PHYTO'}.field = ncchar('Phytoplankton, scalar, series');
end

 
if strcmp(fields{i},'ZOO') 
nc{'ZOO'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'ZOO'}.long_name = ncchar('averaged Zooplankton');
nc{'ZOO'}.units = ncchar('mmol N m-3');
nc{'ZOO'}.field = ncchar('Zooplankton, scalar, series');
end
 
if strcmp(fields{i},'SDET')  
nc{'SDET'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'SDET'}.long_name = ncchar('averaged Small Detritus Nitrogen');
nc{'SDET'}.units = ncchar('mmol N m-3');
nc{'SDET'}.field = ncchar('Small Detritus Nitrogen, scalar, series');
end
 
if strcmp(fields{i},'LDET')  
nc{'LDET'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'LDET'}.long_name = ncchar('averaged Large Detritus Nitrogen');
nc{'LDET'}.units = ncchar('mmol N m-3');
nc{'LDET'}.field = ncchar('Large Detritus Nitrogen, scalar, series');
end
 
if strcmp(fields{i},'rho')  
nc{'rho'} = ncdouble('time', 's_rho', 'eta_rho', 'xi_rho'); %% 2304000 elements.
nc{'rho'}.long_name = ncchar('averaged density anomaly');
nc{'rho'}.units = ncchar('kilogram meter-3');
nc{'rho'}.field = ncchar('density, scalar, series');
end

if strcmp(fields{i},'AKv')  
nc{'AKv'} = ncfloat('time', 's_w', 'eta_rho', 'xi_rho'); %% 18673284 elements.
nc{'AKv'}.long_name = ncchar('averaged vertical viscosity coefficient');
nc{'AKv'}.units = ncchar('meter2 second-1');
nc{'AKv'}.time = ncchar('ocean_time');
nc{'AKv'}.coordinates = ncchar('lat_rho lon_rho');
nc{'AKv'}.field = ncchar('AKv, scalar, series');
end
 
 if strcmp(fields{i},'AKt')  
nc{'AKt'} = ncfloat('time', 's_w', 'eta_rho', 'xi_rho'); %% 18673284 elements.
nc{'AKt'}.long_name = ncchar('averaged temperature vertical diffusion coefficient');
nc{'AKt'}.units = ncchar('meter2 second-1');
nc{'AKt'}.time = ncchar('ocean_time');
nc{'AKt'}.coordinates = ncchar('lat_rho lon_rho');
nc{'AKt'}.field = ncchar('AKt, scalar, series');
end
 
 if strcmp(fields{i},'AKs')  
nc{'AKs'} = ncfloat('time', 's_w', 'eta_rho', 'xi_rho'); %% 18673284 elements.
nc{'AKs'}.long_name = ncchar('averaged salinity vertical diffusion coefficient');
nc{'AKs'}.units = ncchar('meter2 second-1');
nc{'AKs'}.time = ncchar('ocean_time');
nc{'AKs'}.coordinates = ncchar('lat_rho lon_rho');
nc{'AKs'}.field = ncchar('AKs, scalar, series');
end

 if strcmp(fields{i},'shflux') 
nc{'shflux'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 889204 elements.
nc{'shflux'}.long_name = ncchar('averaged surface net heat flux');
nc{'shflux'}.units = ncchar('watt meter-2');
nc{'shflux'}.negative_value = ncchar('upward flux, cooling');
nc{'shflux'}.positive_value = ncchar('downward flux, heating');
nc{'shflux'}.time = ncchar('ocean_time');
nc{'shflux'}.coordinates = ncchar('lat_rho lon_rho');
nc{'shflux'}.field = ncchar('surface heat flux, scalar, series');
 end
 
  if strcmp(fields{i},'ssflux') 
nc{'ssflux'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 889204 elements.
nc{'ssflux'}.long_name = ncchar('averaged surface net salt flux, (E-P)*SALT');
nc{'ssflux'}.units = ncchar('PSU meter second-1');
nc{'ssflux'}.negative_value = ncchar('upward flux, freshening (net precipitation)');
nc{'ssflux'}.positive_value = ncchar('downward flux, salting (net evaporation)');
nc{'ssflux'}.time = ncchar('ocean_time');
nc{'ssflux'}.coordinates = ncchar('lat_rho lon_rho');
nc{'ssflux'}.field = ncchar('surface net salt flux, scalar, series');
end

  if strcmp(fields{i},'swrad')
nc{'swrad'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 20575944 elements.
nc{'swrad'}.long_name = ncchar('solar shortwave radiation');
nc{'swrad'}.units = ncchar('Watts meter-2');
nc{'swrad'}.field = ncchar('shortwave radiation, scalar, series');
nc{'swrad'}.positive = ncchar('downward flux, heating');
nc{'swrad'}.negative = ncchar('upward flux, cooling');
end


 if strcmp(fields{i},'sustr')
nc{'sustr'} = ncfloat('time', 'eta_u', 'xi_u'); %% 20448932 elements.
nc{'sustr'}.long_name = ncchar('surface u-momentum stress');
nc{'sustr'}.units = ncchar('Newton meter-2');
nc{'sustr'}.field = ncchar('surface u-mometum stress, scalar, series');
end

 if strcmp(fields{i},'svstr') 
nc{'svstr'} = ncfloat('time', 'eta_v', 'xi_v'); %% 20484900 elements.
nc{'svstr'}.long_name = ncchar('surface v-momentum stress');
nc{'svstr'}.units = ncchar('Newton meter-2');
nc{'svstr'}.field = ncchar('surface v-momentum stress, scalar, series');
end



end
 
endef(nc)
close(nc)
