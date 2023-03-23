

function ncep = rnc_MakeClima_SurfFluxes_NCEP(YEARS)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function ncep = rnc_MakeClima_SurfFluxes_NCEP(years)
%
%      INPUT: YEARS over which to compute the monthly climatology
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%

vars = { 'dswrf' 'nlwrs' 'lhtfl' 'shtfl' 'nswrs' 'prate'};
% -----------------------      
ncep_clima = which('NCEP_WindStress_monthly.nc');
n=length('NCEP_WindStress_monthly.nc');
datadir = [ncep_clima(1:end-n),'NCEP_daily/'];
filetyp='.sfc.gauss.';

[mask,lon,lat]=cdc_readvar2([datadir,'land',filetyp,'nc'],'land');
mask(mask==1)=NaN;
mask(mask==0)=1;

%-----------------------------------------------------------------
% LOAD A VARIABLE
%-----------------------------------------------------------------
ncep.desc.dswrf = 'mean Daily Downward Solar Radiation Flux at surface W/m^2' ;
ncep.desc.lhtfl = 'mean Daily Latent Heat Net Flux at surface W/m^2' ;
ncep.desc.nlwrs = 'mean Daily Net Longwave Radiation Flux at Surface W/m^2' ;
ncep.desc.nswrs = 'mean Daily Net Shortwave Radiation Flux at Surface W/m^2' ;
ncep.desc.prate = 'mean Daily Precipitation Rate at surface Kg/m^2/s' ;
ncep.desc.shtfl = 'mean Daily Sensible Heat Net Flux at surface W/m^2' ;


TIMEINDEX=12;
[I,J]=size(lon);
for iv=1:length(vars)
 eval(['ncep.',vars{iv},'=zeros(I,J,TIMEINDEX);']);
end

for year=YEARS

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
     
    for imon=1:12
    in=find(months == imon);
	  for iv=1:length(vars) 
          eval(['ncep.',vars{iv},'(:,:,imon)=  ncep.',vars{iv},'(:,:,imon)+ mean(',vars{iv},'(:,:,in),3);']);
	  end
    end
end



% change sign for ocean convention
        ncep.lon=lon;
	  ncep.lat=lat;
	  ncep.mask=mask;
	  
for i=1:12
    for iv=1: length(vars)
    eval(['ncep.',vars{iv},'(:,:,i)=ncep.',vars{iv},'(:,:,i)/length(YEARS);']);
    end
end

in=find(isnan(ncep.mask));
noin=find(~isnan(ncep.mask));
[pmap]=rnt_oapmap(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin) ,ncep.lon(in),ncep.lat(in),20);


for i=1:12
    disp(['Filling nan for month... ',num2str(i)]);
    for iv=1: length(vars)
    eval(['tmp=ncep.',vars{iv},'(:,:,i);']);
    tmp(in)=rnt_oa2d(ncep.lon(noin),ncep.lat(noin),ncep.mask(noin).*tmp(noin), ...
                 ncep.lon(in),ncep.lat(in),3,3,pmap);
    eval(['ncep.',vars{iv},'(:,:,i)=tmp;']);
    end
end

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
