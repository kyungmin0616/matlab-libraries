% cdc toolbox - manu
%
% FUNCTION [fout,lon,lat,level,time] = cdc_readvar (datafile, variable)
%
% options:
%     ( ..., 'time' , [ 1:10 ],..) to specify which time index to extract
%     ( ..., 'level' , [ 1:10 ],..) to specify which time index to extract
%     ( ..., 'dim' , ..)           to extract only the dimensions, lon, lat ..time..
%     ( ..., 'verbose' , ..)       display variable attributes.
% [fout,lon,lat,level,time] = cdc_readvar ('data/salt.mnmean.nc','salt','time', 1, 'level' , 1);
% [fout,lon,lat,level,time] = cdc_readvar ('data/otemp.mnmean.nc','otemp','time', 1, 'level' , 1);
function [fout,lon,lat,level,time] = cdc_read (varargin)

datafile=varargin{1};
if nargin == 1
   ncdump (datafile);
   return
end   
variable=varargin{2};

nc=netcdf(datafile);
[ndims, nvars, ngatts, recdim] = size(nc);
dims = dim(nc); ndims = length(dims);
vars = var(nc); nvar = length(vars);
gatts = att(nc); ngatts = length(gatts);

% Parse the string inputs
dim=0;
tind=0;
levelind=0;
verbose=1;
fout=0;
for nin=1:nargin
    if ischar(varargin{nin})
        vv = varargin{nin};
        if strcmp('dim',vv)
            dim=1;
        end       
        if strcmp('time',vv)
            tind= varargin{nin+1};
        end       
        if strcmp('level',vv)
            levelind= varargin{nin+1};
        end       
                if strcmp('verbose',vv)
            verbose=1;
        end       

        
    end
end



lon=nc{'lon'}(:);
lon=lon-360;
lat=nc{'lat'}(:);
level=nc{'level'}(:);

if strcmp(nc{'level'}.units(:), 'cm') level=level/100; end
time=nc{'time'}(:);

if tind == 0 , tind=1:length(time); end
if levelind == 0 , levelind=1:length(level); end

if dim ==1, return, end

[lon,lat]=meshgrid(lon,lat);

if isempty(level) 
	fout=nc{variable}(tind,:,:);
else
	fout=nc{variable}(tind,levelind,:,:);
end
	
% Nan the missing values
missing=  nc{variable}.missing_value(:);
fout(fout == missing) = NaN;
fout=fout*nc{variable}.scale_factor(:);

fout=fout + nc{variable}.add_offset(:);
if strcmp('salt',variable), fout=fout*1000 + 35; end

len=size(fout);
order=length(len):-1:1;
fout=permute(fout,order);
lon=lon';
lat=lat';


if verbose ==1
    disp(['UNITS   :',nc{variable}.units]); 
    disp(['DESC    :', nc{variable}.var_desc]);
    disp(['DATASET :', nc{variable}.dataset]);
    disp(['LEVELS  :', nc{variable}.level_desc]);
    disp(['STATS   :', nc{variable}.statistic]);
    disp(['PARENT  :', nc{variable}.parent_stat]);
end


