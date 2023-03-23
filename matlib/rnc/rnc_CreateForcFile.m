function rnc_CreateForcFile(grd,filename, varargin) 
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function rnc_CreateForcFile(grd,filename, [OPT])
% Create a forcing file for the grid contained in GRD
%
%  If OPT is not specified it will create a climatology
% forcing file with 12 records (1 x month). Now waht is OPT?
%
% Say you want to produce a file with only 1 year of daily data for
% wind stresses and monthly values for SST
%
% opt.sms_time=365;   opt.sms_time_cycle=0; opt.sms_timeVal=[....];
% opt.sss_time=12;   opt.sss_time_cycle=360; opt.sss_timeVal=[15:30:360];
% rnc_CreateForcFile(grd,filename, opt)
%
% sms_timeVal and sst_timeVal are the actual values of time.
%
% The same can be done for the variables 
% sms_time, shf_time, swf_time, srf_time, sst_time, sss_time
% and any combination. You can edit the matlab function and
% add other forcing variables as much as you like.
% 
%  E. Di Lorenzo (edl@eas.gatech.edu)
% 
n=0;
% if no additional argument are given make a simple climatology file
if nargin == 2
   opt.sms_time=12;   opt.sms_time_cycle=360; opt.sms_timeVal=[15:30:360];
   opt.shf_time=12;   opt.shf_time_cycle=360; opt.shf_timeVal=[15:30:360];
   opt.swf_time=12;   opt.swf_time_cycle=360; opt.swf_timeVal=[15:30:360];
   opt.srf_time=12;   opt.srf_time_cycle=360; opt.srf_timeVal=[15:30:360];
   opt.sst_time=12;   opt.sst_time_cycle=360; opt.sst_timeVal=[15:30:360];
   opt.sss_time=12;   opt.sss_time_cycle=360; opt.sss_timeVal=[15:30:360];
end
   
% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

%% ncdump('forc-RSM-clima.nc')   %% Generated 07-Sep-2002 14:30:48
 
nc = netcdf(filename, 'clobber');
if isempty(nc), return, end
 
%% Global attributes:
 
nc.title = ncchar(grd.name);
nc.out_file = ncchar('');
nc.grd_file = ncchar(grd.grdfile);
nc.oa_file = ncchar('');
nc.version = ncchar('RNC - Matlab Toolbox by E. Di Lorenzo');
nc.history = ncchar(datestr(now));
nc.type = ncchar('FORCING file');
 
%% Dimensions:
 
nc('xi_rho') = grd.Lp;
nc('xi_u') = grd.L;
nc('xi_v') = grd.Lp;
nc('eta_rho') = grd.Mp;
nc('eta_u') = grd.Mp;
nc('eta_v') = grd.M;
%nc('s_rho') = grd.N;
%nc('s_w') = grd.N+1;


 
%% Variables and attributes:

%==========================================================
%	sms_time
%==========================================================
if isfield(opt,'sms_time')
nc('sms_time') = opt.sms_time;
n=n+1; forc_timevars(n)={'sms_time'};
nc{'sms_time'} = ncdouble('sms_time'); %% 12 elements.
nc{'sms_time'}.long_name = ncchar('surface momentum stress time');
nc{'sms_time'}.units = ncchar('days');
if opt.sms_time_cycle > 0
nc{'sms_time'}.cycle_length = ncdouble(opt.sms_time_cycle);
end
nc{'sms_time'}.field = ncchar('time, scalar, series');

nc{'sustr'} = ncdouble('sms_time', 'eta_u', 'xi_u'); %% 113760 elements.
nc{'sustr'}.long_name = ncchar('surface u-momentum stress');
nc{'sustr'}.units = ncchar('Newton meter-2');
nc{'sustr'}.field = ncchar('surface u-mometum stress, scalar, series');
 
nc{'svstr'} = ncdouble('sms_time', 'eta_v', 'xi_v'); %% 114240 elements.
nc{'svstr'}.long_name = ncchar('surface v-momentum stress');
nc{'svstr'}.units = ncchar('Newton meter-2');
nc{'svstr'}.field = ncchar('surface v-momentum stress, scalar, series');
end

%==========================================================
%	shf_time
%==========================================================
if isfield(opt,'shf_time')
nc('shf_time') = opt.shf_time;
n=n+1; forc_timevars(n)={'shf_time'};
nc{'shf_time'} = ncdouble('shf_time'); %% 12 elements.
nc{'shf_time'}.long_name = ncchar('surface heat flux time');
nc{'shf_time'}.units = ncchar('days');
if opt.shf_time_cycle > 0
nc{'shf_time'}.cycle_length = ncdouble(opt.shf_time_cycle);
end
nc{'shf_time'}.field = ncchar('time, scalar, series');

nc{'shflux'} = ncdouble('shf_time', 'eta_rho', 'xi_rho'); %% 115200 elements.
nc{'shflux'}.long_name = ncchar('surface net heat flux');
nc{'shflux'}.units = ncchar('Watts meter-2');
nc{'shflux'}.field = ncchar('surface heat flux, scalar, series');
nc{'shflux'}.positive = ncchar('downward flux, heating');
nc{'shflux'}.negative = ncchar('upward flux, cooling');
end

%==========================================================
%	swf_time 
%==========================================================
if isfield(opt,'swf_time')
nc('swf_time') = opt.swf_time;
n=n+1; forc_timevars(n)={'swf_time'};
nc{'swf_time'} = ncdouble('swf_time'); %% 12 elements.
nc{'swf_time'}.long_name = ncchar('surface freshwater flux time');
nc{'swf_time'}.units = ncchar('days');
if opt.swf_time_cycle > 0
nc{'swf_time'}.cycle_length = ncdouble(opt.swf_time_cycle);
end
nc{'swf_time'}.field = ncchar('time, scalar, series');

nc{'swflux'} = ncdouble('swf_time', 'eta_rho', 'xi_rho'); %% 115200 elements.
nc{'swflux'}.long_name = ncchar('surface freshwater flux (E-P)');
nc{'swflux'}.units = ncchar('centimeter day-1');
nc{'swflux'}.field = ncchar('surface freshwater flux, scalar, series');
nc{'swflux'}.positive = ncchar('net evaporation');
nc{'swflux'}.negative = ncchar('net precipitation');
end

%==========================================================
%	sst_time 
%==========================================================
if isfield(opt,'sst_time')
nc('sst_time') = opt.sst_time;
n=n+1; forc_timevars(n)={'sst_time'};
nc{'sst_time'} = ncdouble('sst_time'); %% 12 elements.
nc{'sst_time'}.long_name = ncchar('sea surface temperature time');
nc{'sst_time'}.units = ncchar('days');
if opt.sst_time_cycle > 0
nc{'sst_time'}.cycle_length = ncdouble(opt.sst_time_cycle);
end
nc{'sst_time'}.field = ncchar('time, scalar, series');

nc{'SST'} = ncdouble('sst_time', 'eta_rho', 'xi_rho'); %% 115200 elements.
nc{'SST'}.long_name = ncchar('sea surface temperature');
nc{'SST'}.units = ncchar('Celsius');
nc{'SST'}.field = ncchar('sea surface temperature, scalar, series');

 
nc{'dQdSST'} = ncdouble('sst_time', 'eta_rho', 'xi_rho'); %% 115200 elements.
nc{'dQdSST'}.long_name = ncchar('surface net heat flux sensitivity to SST');
nc{'dQdSST'}.units = ncchar('Watts meter-2 Celsius-1');
nc{'dQdSST'}.field = ncchar('dQdSST, scalar, series');
end

%==========================================================
%	sss_time
%==========================================================
if isfield(opt,'sss_time')
nc('sss_time') = opt.sss_time;
n=n+1; forc_timevars(n)={'sss_time'};
nc{'sss_time'} = ncdouble('sss_time'); %% 12 elements.
nc{'sss_time'}.long_name = ncchar('sea surface salt time');
nc{'sss_time'}.units = ncchar('days');
if opt.sss_time_cycle > 0
nc{'sss_time'}.cycle_length = ncdouble(opt.sss_time_cycle);
end
nc{'sss_time'}.field = ncchar('time, scalar, series');

nc{'SSS'} = ncdouble('sss_time', 'eta_rho', 'xi_rho'); %% 141696 elements.
nc{'SSS'}.long_name = ncchar('sea surface salinity');
nc{'SSS'}.units = ncchar('psu');
nc{'SSS'}.field = ncchar('sea surface salinity, scalar, series');
end

%==========================================================
%	srf_time
%==========================================================
if isfield(opt,'srf_time')
nc('srf_time') = opt.srf_time; 
n=n+1; forc_timevars(n)={'srf_time'};
nc{'srf_time'} = ncdouble('srf_time'); %% 12 elements.
nc{'srf_time'}.long_name = ncchar('solar shortwave radiation time');
nc{'srf_time'}.units = ncchar('days');
if opt.srf_time_cycle > 0
nc{'srf_time'}.cycle_length = ncdouble(opt.srf_time_cycle);
end
nc{'srf_time'}.field = ncchar('time, scalar, series');

nc{'swrad'} = ncdouble('srf_time', 'eta_rho', 'xi_rho'); %% 115200 elements.
nc{'swrad'}.long_name = ncchar('solar shortwave radiation');
nc{'swrad'}.units = ncchar('Watts meter-2');
nc{'swrad'}.field = ncchar('shortwave radiation, scalar, series');
nc{'swrad'}.positive = ncchar('downward flux, heating');
nc{'swrad'}.negative = ncchar('upward flux, cooling');
end
 
 
 
 
 
 
endef(nc)
close(nc)


nc = netcdf(filename, 'w');

for i=1:length(forc_timevars)
  eval(['tmp=opt.', forc_timevars{i} ,'Val;']);
  nc{ forc_timevars{i} }(:) = tmp;
end

close(nc)  
