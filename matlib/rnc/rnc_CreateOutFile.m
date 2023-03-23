function rnc_CreateIniFile(grd,filename, varargin) 
% function rnc_CreateIniFile(grd,filename, varargin)
%    E. Di Lorenzo (edl@ucsd.edu)
% 
 
%% ncdump('init-levitus.nc')   %% Generated 07-Sep-2002 14:29:52
 
 % Default options

   opt.npzd=0;
   opt.tracer=2;
   opt.time=0;
   opt.ptracer=0;

% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      


nc = netcdf(filename, 'clobber');
if isempty(nc), return, end
 
%% Global attributes:
 
nc.type = ncchar('');
nc.title = ncchar('');
nc.out_file = ncchar('');
nc.grd_file = ncchar('');
nc.inp_file = ncchar('');
nc.history = ncchar('');
 
%% Dimensions:
nc('xi_rho') = grd.Lp;
nc('xi_u') = grd.L;
nc('xi_v') = grd.Lp;
nc('eta_rho') = grd.Mp;
nc('eta_u') = grd.Mp;
nc('eta_v') = grd.M;
nc('s_rho') = grd.N;
nc('s_w') = grd.N+1;


nc('tracer') = opt.tracer;
nc('time') = opt.time; %% (record dimension)
 
%% Variables and attributes:
 
nc{'job'} = nclong; %% 1 element.
nc{'job'}.long_name = ncchar('processing job type');
nc{'job'}.option_0 = ncchar('initial tracer fields, zero momentum');
nc{'job'}.option_1 = ncchar('tracer fields climatology');
 
nc{'vintrp'} = nclong; %% 1 element.
nc{'vintrp'}.long_name = ncchar('vertical interpolation switch');
nc{'vintrp'}.option_0 = ncchar('linear');
nc{'vintrp'}.option_1 = ncchar('cubic spline');
 
nc{'tstart'} = ncdouble; %% 1 element.
nc{'tstart'}.long_name = ncchar('start processing day');
nc{'tstart'}.units = ncchar('day');
 
nc{'tend'} = ncdouble; %% 1 element.
nc{'tend'}.long_name = ncchar('end processing day');
nc{'tend'}.units = ncchar('day');
 
nc{'theta_s'} = ncdouble; %% 1 element.
nc{'theta_s'}.long_name = ncchar('S-coordinate surface control parameter');
nc{'theta_s'}.units = ncchar('nondimensional');
 
nc{'theta_b'} = ncdouble; %% 1 element.
nc{'theta_b'}.long_name = ncchar('S-coordinate bottom control parameter');
nc{'theta_b'}.units = ncchar('nondimensional');
 
nc{'Tcline'} = ncdouble; %% 1 element.
nc{'Tcline'}.long_name = ncchar('S-coordinate surface/bottom layer width');
nc{'Tcline'}.units = ncchar('meter');
 
nc{'hc'} = ncdouble; %% 1 element.
nc{'hc'}.long_name = ncchar('S-coordinate parameter, critical depth');
nc{'hc'}.units = ncchar('meter');
 
nc{'sc_r'} = ncdouble('s_rho'); %% 20 elements.
nc{'sc_r'}.long_name = ncchar('S-coordinate at RHO-points');
nc{'sc_r'}.units = ncchar('nondimensional');
nc{'sc_r'}.valid_min = ncdouble(-1);
nc{'sc_r'}.valid_max = ncdouble(0);
nc{'sc_r'}.field = ncchar('sc_r, scalar');
 
nc{'sc_w'} = ncdouble('s_w'); %% 21 elements.
nc{'sc_w'}.long_name = ncchar('S-coordinate at W-points');
nc{'sc_w'}.units = ncchar('nondimensional');
nc{'sc_w'}.valid_min = ncdouble(-1);
nc{'sc_w'}.valid_max = ncdouble(0);
nc{'sc_w'}.field = ncchar('sc_w, scalar');
 
nc{'Cs_r'} = ncdouble('s_rho'); %% 20 elements.
nc{'Cs_r'}.long_name = ncchar('S-coordinate stretching curves at RHO-points');
nc{'Cs_r'}.units = ncchar('nondimensional');
nc{'Cs_r'}.valid_min = ncdouble(-1);
nc{'Cs_r'}.valid_max = ncdouble(0);
nc{'Cs_r'}.field = ncchar('Cs_r, scalar');
 
nc{'Cs_w'} = ncdouble('s_w'); %% 21 elements.
nc{'Cs_w'}.long_name = ncchar('S-coordinate stretching curves at W-points');
nc{'Cs_w'}.units = ncchar('nondimensional');
nc{'Cs_w'}.valid_min = ncdouble(-1);
nc{'Cs_w'}.valid_max = ncdouble(0);
nc{'Cs_w'}.field = ncchar('Cs_w, scalar');
 
nc{'ocean_time'} = ncdouble('time'); %% 1 element.
nc{'ocean_time'}.long_name = ncchar('time since initialization');
nc{'ocean_time'}.units = ncchar('second');
nc{'ocean_time'}.field = ncchar('time, scalar, series');
 
nc{'u'} = ncfloat('time', 's_rho', 'eta_u', 'xi_u'); %% 189600 elements.
nc{'u'}.long_name = ncchar('u-momentum component');
nc{'u'}.units = ncchar('meter second-1');
nc{'u'}.field = ncchar('u-velocity, scalar, series');
 
nc{'v'} = ncfloat('time', 's_rho', 'eta_v', 'xi_v'); %% 190400 elements.
nc{'v'}.long_name = ncchar('v-momentum component');
nc{'v'}.units = ncchar('meter second-1');
nc{'v'}.field = ncchar('v-velocity, scalar, series');
 
nc{'ubar'} = ncfloat('time', 'eta_u', 'xi_u'); %% 9480 elements.
nc{'ubar'}.long_name = ncchar('vertically integrated u-momentum component');
nc{'ubar'}.units = ncchar('meter second-1');
nc{'ubar'}.field = ncchar('ubar-velocity, scalar, series');
 
nc{'vbar'} = ncfloat('time', 'eta_v', 'xi_v'); %% 9520 elements.
nc{'vbar'}.long_name = ncchar('vertically integrated v-momentum component');
nc{'vbar'}.units = ncchar('meter second-1');
nc{'vbar'}.field = ncchar('vbar-velocity, scalar, series');
 
nc{'zeta'} = ncfloat('time', 'eta_rho', 'xi_rho'); %% 9600 elements.
nc{'zeta'}.long_name = ncchar('free-surface');
nc{'zeta'}.units = ncchar('meter');
nc{'zeta'}.field = ncchar('free-surface, scalar, series');
 
nc{'temp'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 192000 elements.
nc{'temp'}.long_name = ncchar('potential temperature');
nc{'temp'}.units = ncchar('Celsius');
nc{'temp'}.field = ncchar('temperature, scalar, series');
 
nc{'salt'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 192000 elements.
nc{'salt'}.long_name = ncchar('salinity');
nc{'salt'}.units = ncchar('PSU');
nc{'salt'}.field = ncchar('salinity, scalar, series');

for inert=1:opt.ptracer
if inert<10 
str=['dye_0',num2str(inert)];
else
str=['dye_',num2str(inert)];
end
nc{str} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 5183640 elem
str2=['dye concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('kilogram meter-3');
nc{str}.time = ncchar('time');
nc{str}.coordinates = ncchar('lat_rho lon_rho');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);
end

if opt.npzd == 1
nc{'NO3'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 951090 elements.
nc{'NO3'}.long_name = ncchar('nitrate concentration');
nc{'NO3'}.units = ncchar('millimole_N03 meter-3');
nc{'NO3'}.time = ncchar('ocean_time');
nc{'NO3'}.coordinates = ncchar('x_rho y_rho');
nc{'NO3'}.field = ncchar('NO3, scalar, series');
 
nc{'phytoplankton'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 951090 elements.
nc{'phytoplankton'}.long_name = ncchar('phytoplankton concentration');
nc{'phytoplankton'}.units = ncchar('millimole_nitrogen meter-3');
nc{'phytoplankton'}.time = ncchar('ocean_time');
nc{'phytoplankton'}.coordinates = ncchar('x_rho y_rho');
nc{'phytoplankton'}.field = ncchar('phytoplankton, scalar, series');
 
nc{'zooplankton'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 951090 elements.
nc{'zooplankton'}.long_name = ncchar('zooplankton concentration');
nc{'zooplankton'}.units = ncchar('millimole_nitrogen meter-3');
nc{'zooplankton'}.time = ncchar('ocean_time');
nc{'zooplankton'}.coordinates = ncchar('x_rho y_rho');
nc{'zooplankton'}.field = ncchar('zooplankton, scalar, series');
 
nc{'detritus'} = ncfloat('time', 's_rho', 'eta_rho', 'xi_rho'); %% 951090 elements.
nc{'detritus'}.long_name = ncchar('detritus concentration');
nc{'detritus'}.units = ncchar('millimole_nitrogen meter-3');
nc{'detritus'}.time = ncchar('ocean_time');
nc{'detritus'}.coordinates = ncchar('x_rho y_rho');
nc{'detritus'}.field = ncchar('detritus, scalar, series');
end

endef(nc)
close(nc)

return

nc = netcdf(filename, 'w');
for inert=1:opt.ptracer

if inert<10 
str=['dye_0',num2str(inert)];
else
str=['dye_',num2str(inert)];
end
nc{str}(:) = 0;

end
close(nc);
