

function ncep = rnc_Extract_ROMSsurfFluxes_NCEP(lonr,latr, mydatenum, avg_freq,vars, varargin)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function ncep = rnc_Extract_ROMSsurfFluxes_NCEP(lonr,latr, mydatenum, avg_freq,vars, [ncep])
%
%      INPUT: LONR,LATR grid coordinates at RHO-points
%             MYDATENUM date at which you want to extract forcing in MATLAB 
%                       datenum format
%             AVG_FREQ  frequency of averaging 'daily', 'monthly' or 'clima'
%                       if spelled wrong, you will get the clima!
%            
%            vars = {'swrad' 'shflux' 'swflux' 'sustr' 'svstr'};
%             NCEP  is OPTIONAL. If you give it as an input it will append th
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%

if nargin==6
   ncep=varargin{1};
end

%==========================================================
%	WINDS
%==========================================================
%First check if you need to load winds
GETwinds=0;
for iv=1:length(vars)
   if strcmp(vars{iv}, 'sustr') | strcmp(vars{iv}, 'svstr')
     GETwinds=1;
   end
end
if GETwinds==1
  if nargin ==6, ncep = rnc_Extract_UVwinds_NCEP(lonr,latr, mydatenum, avg_freq,ncep);
  else
  ncep = rnc_Extract_UVwinds_NCEP(lonr,latr, mydatenum, avg_freq);end
end
% ------------------------------rnc_Extract_UVwinds_NCEP.m

% find which variables you need for the budget
n=0;GOTlhtfl=0;
clear vars2
for iv=1:length(vars)
   if strcmp(vars{iv}, 'swrad')
        n=n+1; vars2{n} = 'dswrf';
   end
   if strcmp(vars{iv}, 'shflux')
        n=n+1; vars2{n} = 'nlwrs';
        n=n+1; vars2{n} = 'lhtfl';
        n=n+1; vars2{n} = 'shtfl';
        n=n+1; vars2{n} = 'nswrs';	 
	  GOTlhtfl=1;
   end
   if strcmp(vars{iv}, 'swflux')
        n=n+1; vars2{n} = 'prate';
	  if ~GOTlhtfl
	     n=n+1; vars2{n} = 'lhtfl';
	  end
   end   
end
if exist('vars2')
	vars=vars2;
else
      return
end
	
% -----------------------      
ncep_clima = which('NCEP_WindStress_monthly.nc');
n=length('NCEP_WindStress_monthly.nc');
datadir = [ncep_clima(1:end-n),'NCEP_daily/'];
filetyp='.sfc.gauss.';

freq=avg_freq;
grd.lonr=lonr;
grd.latr=latr;
ctlf.year=str2num(datestr(mydatenum,10)); 
ctlf.month=str2num(datestr(mydatenum,5)); 
ctlf.day=str2num(datestr(mydatenum,7)); 
ctlf.datenum=mydatenum;


[mask,lon,lat]=cdc_readvar2([datadir,'land',filetyp,'nc'],'land');
mask(mask==1)=NaN;
mask(mask==0)=1;

  lonmin = min(grd.lonr(:))-4;
  lonmax = max(grd.lonr(:))+4;
  latmin = min(grd.latr(:))-4;
  latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

% nw sw se ne
%%corn.lon = [grd.lonr(1,end) grd.lonr(1,1) grd.lonr(end,1) grd.lonr(end,end)]';
%%corn.lat = [grd.latr(1,end) grd.latr(1,1) grd.latr(end,1) grd.latr(end,end)]';
%%i=find ( squeeze(lon(:,1)) > min(corn.lon)-4 & squeeze(lon(:,1)) <  max(corn.lon)+4);
%%j=find ( squeeze(lat(1,:)) > min(corn.lat)-4 & squeeze(lat(1,:)) <  max(corn.lat)+4);

mask=mask(i,j);
lon=lon(i,j);
lat=lat(i,j);
%-----------------------------------------------------------------
% LOAD A VARIABLE
%-----------------------------------------------------------------
ncep.desc.dswrf = 'mean Daily Downward Solar Radiation Flux at surface W/m^2' ;
ncep.desc.lhtfl = 'mean Daily Latent Heat Net Flux at surface W/m^2' ;
ncep.desc.nlwrs = 'mean Daily Net Longwave Radiation Flux at Surface W/m^2' ;
ncep.desc.nswrs = 'mean Daily Net Shortwave Radiation Flux at Surface W/m^2' ;
ncep.desc.prate = 'mean Daily Precipitation Rate at surface Kg/m^2/s' ;
ncep.desc.shtfl = 'mean Daily Sensible Heat Net Flux at surface W/m^2' ;


TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon);
for iv=1:length(vars)
 eval(['ncep.',vars{iv},'=zeros(I,J,TIMEINDEX);']);
end
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

  year=ctlf.year(TIMEINDEX);        
  % load data if needed.
  if LOADED_YEAR ~= year & ~strcmp(freq,'clima')
    disp(['Loading ... ',num2str(year)])

    for iv=1:length(vars)    
    myvar=vars{iv}; myear=num2str(year);
    disp([' Variable: ',myvar]);
    [tmp,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);
	eval([vars{iv},'=tmp;']);
    end
    
   
    time = time -time(1) + datenum(year,1,1,12,0,0);
    day_datenum=time;
    months=str2num(datestr(day_datenum,5)); 
    days=str2num(datestr(day_datenum,7));     
    LOADED_YEAR=year;
   end
     
    % you can find the dates now with datestr
   if         strcmp(freq,'daily')
	  in=find(months == ctlf.month(TIMEINDEX) & days == ctlf.day(TIMEINDEX));
	  for iv=1:length(vars) 
          eval(['ncep.',vars{iv},'(:,:,TIMEINDEX)=(',vars{iv},'(i,j,in));']);
	  end
        %ncep.lhtfl(:,:,TIMEINDEX)=(lhtfl(i,j,in));
        ncep.avg_type='daily';
	  
   elseif     strcmp(freq,'monthly')
	  in=find(months == ctlf.month(TIMEINDEX));
	  for iv=1:length(vars) 
          eval(['ncep.',vars{iv},'(:,:,TIMEINDEX)=mean(',vars{iv},'(i,j,in),3);']);
	  end
        %ncep.lhtfl(:,:,TIMEINDEX)=mean(lhtfl(i,j,in),3);
	  ncep.avg_type='monthly';
	  
   else
        %disp('Climatology not yet implemented');
	  load NCEP_GlobalBuoyClima 
	  in=ctlf.month(TIMEINDEX);	
	  for iv=1:length(vars) 
          eval(['ncep.',vars{iv},'(:,:,TIMEINDEX)=(NCEP.',vars{iv},'(i,j,in));']);
	  end        	  
	  ncep.avg_type='clima';
   end
        % common to all
        ncep.year(TIMEINDEX)  = ctlf.year(TIMEINDEX);
        ncep.month(TIMEINDEX) = ctlf.month(TIMEINDEX);
	  ncep.datenum(TIMEINDEX) = ctlf.datenum(TIMEINDEX);
	  ncep.day(TIMEINDEX) = ctlf.day(TIMEINDEX);
end

% change sign for ocean convention
        ncep.lon=lon;
	  ncep.lat=lat;
	  ncep.mask=mask;


in=find(isnan(ncep.mask));
noin=find(~isnan(ncep.mask));
if ~isempty (in) 
[pmap]=rnt_oapmap(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin) ,ncep.lon(in),ncep.lat(in),20);


for i=1:TIMEINDEX
    disp(['Filling nan for month... ',num2str(i)]);
    for iv=1: length(vars)
        disp(vars{iv});
    eval(['tmp=ncep.',vars{iv},'(:,:,i);']);
    tmp(in)=rnt_oa2d(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin).*tmp(noin), ...
                 ncep.lon(in),ncep.lat(in),3,3,pmap);
    eval(['ncep.',vars{iv},'(:,:,i)=tmp;']);
    end
end
else
%  disp('No land values to be filled. DONE.');
end

%for i=1:TIMEINDEX
%    disp(['Filling nan for ... ',datestr(ncep.datenum(i))]);
%    for iv=1: length(vars)
%    disp(vars{iv})
%    eval(['ncep.',vars{iv},'(:,:,i)=rnt_fill(ncep.lon,ncep.lat,ncep.',vars{iv},'(:,:,i).*ncep.mask,3,3);']);
%    end
%end

%==========================================================
%	% SWRAD
%==========================================================


if isfield(ncep,'dswrf') 
ncep.swrad = ncep.dswrf;
ncep.desc.swrad='solar shortwave radiation W/m^2 (positive,downward flux, heating)';
end
% I think that shflux = "surface net heat flux" ;
% should be given by:
% nlwrs + lhtfl + shtfl + nswrs
% where:
% nlwrs = "mean Daily Net Longwave Radiation Flux at Surface" ;
% lhtfl = "mean Daily Latent Heat Net Flux at surface" ;
% shtfl = "mean Daily Sensible Heat Net Flux at surface" ;
% nswrs = "mean Daily Net Shortwave Radiation Flux at Surface" ;

%==========================================================
%	SHFLUX
%==========================================================
if isfield(ncep,'nlwrs') & isfield(ncep,'lhtfl') & isfield(ncep,'shtfl') & isfield(ncep,'nswrs')
ncep.shflux= -(ncep.nlwrs + ncep.lhtfl + ncep.shtfl +  ncep.nswrs);
ncep.desc.shflux='surface net heat flux  W/m^2 (positive,downward flux,heating';
end


%==========================================================
%	SWFLUX
%==========================================================
% For Evaporation rate: E(m/s)=lhtfl/Llv/rho
% with lhtfl = "mean Daily Latent Heat Net Flux at surface" ;
% Llv = Latent heat of vaporization (approx to 2.5*10^6 J Kg^-1)
% rho = 1025 Kg/m^3

if isfield(ncep,'prate') & isfield(ncep,'lhtfl') 
Llv = 2.5*10^6;
rho = 1025; % using a typical value for salty water.
Et=ncep.lhtfl/Llv/rho;
E=Et*100*86400;  % to convert to cm/day

Pt=ncep.prate/1000; % to convert to a rate, using 1000 Kg/m^3 as
                                            % density of pure water.
P=Pt*100*86400;  % to convert to cm/day

ncep.swflux=E-P;
ncep.desc.swflux ='surface freshwater flux (E-P) cm/day (postive,net evaporation)';
end
%save FLUXES lon lat YEAR MONTH LHTFL DSWRF NLWRS SHTFL NSWRS
% > The model gives only the latent heat flux. I think you can
% derive from it
% > the evaporation by the simple formula:
% >
% > EVAP [m/s] = LH [J/s/m2] / L [J/kg] * RO [kg/m3]
% >
% > where
% >
% > L  = 2.5008 x 10^6 J/kg - 2.3 * 10^3 * T
% > T  = temperature in degrees Celsius, maybe just set it to a
% representative
% > constant value, i.e. 15C
% > RO = 1025 X kg/m3
% >
% > I just looked the constants up in Gill's book, so they should be 
% > ok.
