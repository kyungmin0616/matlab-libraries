

function ncep = rnc_Extract_BuoyFlux_NCEP(lonr,latr, mydatenum, avg_freq,varargin)
%
% (R)oms (N)etcdf files (C)reation package - RNC
%
% function ncep = rnc_Extract_UVwinds_NCEP(grd, freq, ctlf, [ncep])
%
%      INPUT: LONR,LATR grid coordinates at RHO-points
%             MYDATENUM date at which you want to extract forcing in MATLAB 
%                       datenum format
%             AVG_FREQ  frequency of averaging 'daily', 'monthly' or 'clima'
%                       if spelled wrong, you will get the clima!
%             NCEP  is OPTIONAL. If you give it as an input it will append th
%
%  E. Di Lorenzo (edl@eas.gatech.edu)
%

if nargin==5
   ncep=varargin{1};
end
   
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
%ncep.dswrf:units = "W/m^2" ;

ncep.desc.lhtfl = 'mean Daily Latent Heat Net Flux at surface W/m^2' ;
%lhtfl:units = "W/m^2" ;

ncep.desc.nlwrs = 'mean Daily Net Longwave Radiation Flux at Surface W/m^2' ;
%nlwrs:units = "W/m^2" ;

ncep.desc.nswrs = 'mean Daily Net Shortwave Radiation Flux at Surface W/m^2' ;
%nswrs:units = "W/m^2" ;

ncep.desc.prate = 'mean Daily Precipitation Rate at surface Kg/m^2/s' ;
%prate:units = "Kg/m^2/s" ;

ncep.desc.shtfl = 'mean Daily Sensible Heat Net Flux at surface W/m^2' ;
%shtfl:units = "W/m^2" ;


TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon);
vars={'lhtfl' 'dswrf' 'nlwrs' 'shtfl' 'nswrs' 'prate'};
for iv=1:6 
 eval(['ncep.',vars{iv},'=zeros(I,J,TIMEINDEX);']);
end
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

  year=ctlf.year(TIMEINDEX);        
  % load data if needed.
  if LOADED_YEAR ~= year & ~strcmp(freq,'clima')
    disp(['Loading ... ',num2str(year)])
    myvar='lhtfl'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [lhtfl,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

    myvar='dswrf'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [dswrf,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

    myvar='nlwrs'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [nlwrs,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

    myvar='shtfl'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [shtfl,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

    myvar='nswrs'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [nswrs,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

    myvar='prate'; myear=num2str(year);
    %[fout,lon1,lat1,level,time] = cdc_readvar2  ...
    %    ([datadir,myvar,filetyp,myear,'.nc'],myvar,'time', [1:100]);
    [prate,lon1,lat1,level,time] = cdc_readvar2  ...
        ([datadir,myvar,filetyp,myear,'.nc'],myvar);

   
    time = time -time(1) + datenum(year,1,1,12,0,0);
    day_datenum=time;
    months=str2num(datestr(day_datenum,5)); 
    days=str2num(datestr(day_datenum,7));     
    LOADED_YEAR=year;
   end
     
    % you can find the dates now with datestr
   if         strcmp(freq,'daily')
	  in=find(months == ctlf.month(TIMEINDEX) & days == ctlf.day(TIMEINDEX));
        ncep.lhtfl(:,:,TIMEINDEX)=(lhtfl(i,j,in));
        ncep.dswrf(:,:,TIMEINDEX)=(dswrf(i,j,in));        
        ncep.nlwrs(:,:,TIMEINDEX)=(nlwrs(i,j,in));        
        ncep.shtfl(:,:,TIMEINDEX)=(shtfl(i,j,in));                
        ncep.nswrs(:,:,TIMEINDEX)=(nswrs(i,j,in));                
        ncep.prate(:,:,TIMEINDEX)=(prate(i,j,in));                	  

   elseif     strcmp(freq,'monthly')
	  in=find(months == ctlf.month(TIMEINDEX));
        ncep.lhtfl(:,:,TIMEINDEX)=mean(lhtfl(i,j,in),3);
        ncep.dswrf(:,:,TIMEINDEX)=mean(dswrf(i,j,in),3);        
        ncep.nlwrs(:,:,TIMEINDEX)=mean(nlwrs(i,j,in),3);        
        ncep.shtfl(:,:,TIMEINDEX)=mean(shtfl(i,j,in),3);                
        ncep.nswrs(:,:,TIMEINDEX)=mean(nswrs(i,j,in),3);                
        ncep.prate(:,:,TIMEINDEX)=mean(prate(i,j,in),3);                	  
   else
        disp('Climatology not yet implemented');	  
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
	  
vars={'lhtfl' 'dswrf' 'nlwrs' 'shtfl' 'nswrs' 'prate'};
for i=1:TIMEINDEX
    disp(['Filling nan for ... ',datestr(ncep.datenum(i))]);
    for iv=1:6 
    eval(['ncep.',vars{iv},'(:,:,i)=rnt_fill(ncep.lon,ncep.lat,ncep.',vars{iv},'(:,:,i).*ncep.mask,3,3);']);
    end
end

  
ncep.swrad = ncep.dswrf;
ncep.desc.swrad='solar shortwave radiation W/m^2 (positive,downward flux, heating)';

% I think that shflux = "surface net heat flux" ;
% should be given by:
% nlwrs + lhtfl + shtfl + nswrs
% where:
% nlwrs = "mean Daily Net Longwave Radiation Flux at Surface" ;
% lhtfl = "mean Daily Latent Heat Net Flux at surface" ;
% shtfl = "mean Daily Sensible Heat Net Flux at surface" ;
% nswrs = "mean Daily Net Shortwave Radiation Flux at Surface" ;

ncep.shflux= -(ncep.nlwrs + ncep.lhtfl + ncep.shtfl +  ncep.nswrs);
ncep.desc.shflux='surface net heat flux  W/m^2 (positive,downward flux,heating';

% For Evaporation rate: E(m/s)=lhtfl/Llv/rho
% with lhtfl = "mean Daily Latent Heat Net Flux at surface" ;
% Llv = Latent heat of vaporization (approx to 2.5*10^6 J Kg^-1)
% rho = 1025 Kg/m^3

Llv = 2.5*10^6;
rho = 1025; % using a typical value for salty water.
Et=ncep.lhtfl/Llv/rho;
E=Et*100*86400;  % to convert to cm/day

Pt=ncep.prate/1000; % to convert to a rate, using 1000 Kg/m^3 as
                                            % density of pure water.
P=Pt*100*86400;  % to convert to cm/day

ncep.swflux=E-P;
ncep.desc.swflux ='surface freshwater flux (E-P) cm/day (postive,net evaporation)';

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
