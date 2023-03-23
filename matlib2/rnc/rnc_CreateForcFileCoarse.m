function rnc_CreateForcFileCoarse(forcd,filename, varargin) 
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function rnc_CreateForcFileCoarse(grd,filename, [OPT])
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
 
nc.title = ncchar('');
nc.out_file = ncchar('');
nc.grd_file = ncchar('');
nc.oa_file = ncchar('');
nc.version = ncchar('RNC - Matlab Toolbox by E. Di Lorenzo');
nc.history = ncchar(datestr(now));
nc.type = ncchar('FORCING file');
 
%% Dimensions:

[I,J]=size(forcd.lon);

nc('lon') = I;
nc('lat') = J;

if isfield(forcd,'timevar')
   nc(forcd.timevar) = length(forcd.timevar_value);
   nc{forcd.timevar} = ncdouble(forcd.timevar); %% 12 elements.
   nc{forcd.timevar}.long_name = ncchar('time');
   nc{forcd.timevar}.units = ncchar('days');
   if forcd.timevar_cycle > 0
     nc{forcd.timevar}.cycle_length = ncdouble(forcd.timevar_cycle);
   end
   nc{forcd.timevar}.field = ncchar('time, scalar, series');
   
end
nc{'lon'} = ncdouble('lat', 'lon'); 
nc{'lat'} = ncdouble('lat', 'lon'); 

for i=1:length(forcd.varname)
nc{forcd.varname{i}} = ncdouble(forcd.timevar, 'lat', 'lon'); 
nc{forcd.varname{i}}.long_name = ncchar(forcd.varlongname{i});
nc{forcd.varname{i}}.units = ncchar(forcd.varunits{i});
nc{forcd.varname{i}}.field = ncchar('');
nc{forcd.varname{i}}.coordinates = ncchar('lon lat');
end 
 
 
endef(nc)
close(nc)


nc = netcdf(filename, 'w');
nc{forcd.timevar}(:)=forcd.timevar_value;
nc{'lon'}(:,:) = forcd.lon';
nc{'lat'}(:,:) = forcd.lat';
for i=1:length(forcd.varname)
  str=['tmp=perm(forcd.',forcd.varname{i},');'];
  eval(str);
  nc{forcd.varname{i}}(:)=tmp;
end

close(nc);

