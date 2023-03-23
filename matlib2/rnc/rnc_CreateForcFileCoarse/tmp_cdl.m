 
%% ncdump('ias20_hflux.nc')   %% Generated 27-Jan-2006 13:59:29
 
nc = netcdf('tmp.nc', 'clobber');
if isempty(nc), return, end
 
%% Global attributes:
 
nc.title = ncchar('UWM/COADS Monthly climatology (1945-89) ');
nc.history = ncchar('FORCING file, Thursday - November 10, 2005 - 2:30:00 PM');
nc.type = ncchar('CLIMATOLOGY FORCING file');
 
%% Dimensions:
 
nc('lon') = 60;
nc('lat') = 57;
nc('shf_time') = 12;
 
%% Variables and attributes:
 
nc{'shf_time'} = ncdouble('shf_time'); %% 12 elements.
nc{'shf_time'}.long_name = ncchar('surface net heat flux time');
nc{'shf_time'}.units = ncchar('day');
nc{'shf_time'}.calendar = ncchar('360_day');
nc{'shf_time'}.cycle_length = ncdouble(360);
 
nc{'lon'} = ncdouble('lon'); %% 60 elements.
nc{'lon'}.long_name = ncchar('longitude');
nc{'lon'}.units = ncchar('degrees_east');
 
nc{'lat'} = ncdouble('lat'); %% 57 elements.
nc{'lat'}.long_name = ncchar('latitude');
nc{'lat'}.units = ncchar('degrees_north');
 
nc{'mask'} = ncfloat('lat', 'lon'); %% 3420 elements.
nc{'mask'}.long_name = ncchar('land-water mask');
nc{'mask'}.land = ncdouble(0);
nc{'mask'}.water = ncdouble(1);
nc{'mask'}.coordinate = ncchar('lon lat');
 
nc{'shflux'} = ncfloat('shf_time', 'lat', 'lon'); %% 41040 elements.
nc{'shflux'}.long_name = ncchar('surface net heat flux');
nc{'shflux'}.units = ncchar('Watts meter-2');
nc{'shflux'}.negative = ncchar('downward flux, heating');
nc{'shflux'}.positive = ncchar('upward flux, cooling');
nc{'shflux'}.coordinates = ncchar('lon lat');
nc{'shflux'}.time = ncchar('shf_time');
 
endef(nc)
close(nc)
