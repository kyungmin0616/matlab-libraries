%function add_tides_new(Fname,Gname,Ntides)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2003 UCLA 			                             	     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Meinte Blaas, Patrick Marchesiello  %
%                                                                            %
% add_tides                           					           %
%                                                                            %
% This script:										     %
%                                                                            %
% * Extracts tidal model data (elevation elev, transports UV), from  	     %
%   OSU's TPXO.6 tidal model, (Egbert & Erofeeva 1994, 2000;		     %
%   http://www.oce.orst.edu/po/research/tide/global.html)			     %
% * Shifts the transport data UV to ssh grid nodes 				     %
% * Converts UV  to velocities uv  by devision by TPXO.6 depth (hz)	     %
% * Cuts out a subdomain of the global data set as 				     %
%   determined by the grid file of ROMS AMR					     %
% * Regrids the subdomain arrays to the ROMS lat-lon grid			     %
% * Shuffles the order of the components acc. to ROMS				     %
% * Allows to save results in Tide.structure to .mat file (iSAVE=1)	     %
%   (to be retrieved using iLOAD=1)							     %
% * Alows nodal corrections for a given start day tstart (iNODAL=1)	     %
%   (can be reapplied for same grid using iLOAD)				     %
%   (iCHECKDAT=1 checks calendar date of tstart)				     %
% * Writes the result to forcing nc file (iWRITE=1)				     %
% * Plots the Tide.structure components (iPLOT=1)  				     %
%                                                                            %
%                                                                            %
%   The only thing you have to change is the paths to the files, 		     %
%   the startdate and tidalrank (if applicable).				     %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

clear all;  close all;
global IPRINT; IPRINT=0;

%if nargin<1,
  Fname ='usw15_coamps_testides.nc';      % ROMS forcing and grid files
  Gname ='usw15_grid.nc';
  Ntides=10;                            % Number of tidal constituents 
                                        % to write into forcing file
%end;

%---------------------------------------------------------------------
%  Globals.
%---------------------------------------------------------------------

iWRITE   =0;
iSAVE    =0;
iLOAD    =0;
iPLOT    =0;
iCHECKDAT=1;
iNODAL   =0;      % Correct phase and amplitude using astron. 
                  % longitudes for real time runs
		
%
% TPXO files
%
Hname ='/disk27/patrickm/TIDES/TPXO.6/H_tpxo/h_TPXO.6.1.ot';
UVname='/disk27/patrickm/TIDES/TPXO.6/UV_tpxo/u_TPXO.6.1';
Bname ='/disk27/patrickm/TIDES/TPXO.6/UV_tpxo/grid';
		
%
% Set start time of simulation in fractional mjd for nodal correction
%
if (iNODAL),
  mjd=52275;
  hr=0.;
  minute=0.;
  tstart=mjd+hr/24+minute/(60*24);
  if (iCHECKDAT), 
    disp(['Start date for nodal correction :',mjd2greg(mjd)]); 
  end;
end,

rad=pi/180.0;
deg=180.0/pi;

%---------------------------------------------------------------------
%  Read in ROMS grid.
%---------------------------------------------------------------------
disp('Reading ROMS grid parameters ...');

rlon=nc_read(Gname,'lon_rho');
rlon(rlon<0)=rlon(rlon<0)+360;

rlat=nc_read(Gname,'lat_rho');
rangle=nc_read(Gname,'angle');

[Lp,Mp]=size(rlon);

rmask =nc_read(Gname,'mask_rho');
%rmask(rmask==0)=NaN;


if (~iLOAD),
%---------------------------------------------------------------------
% Read TPXO grid
%---------------------------------------------------------------------

disp('Reading TPXO grid parameters ...');

tpid=fopen(Hname,'r');

stbt    = fread(tpid,[1 1],'int32'); % dummy: record delimiter?
nmnc    = fread(tpid,[1 3],'int32'); % nmax, mmax, num constituents
thetalim= fread(tpid,[1 2],'float'); % lat limits
philim  = fread(tpid,[1 2],'float'); % lon limits

dlon=(philim(2)-philim(1))/nmnc(1); %
dlat=(thetalim(2)-thetalim(1))/nmnc(2); %

%%% create grid h nodes

hlatmin=thetalim(1)+.5*dlat; % -90
hlatmax=thetalim(2)-.5*dlat; %  90 ??
hlonmin=philim(1)+.5*dlon;   %   0.25
hlonmax=philim(2)-.5*dlon;   % 360 ??

[hlon,hlat]=ndgrid(hlonmin:dlon:hlonmax, hlatmin:dlat:hlatmax);

[nmax mmax]=size(hlon);

%%% select matching subdomain from ROMS grid

latmin=floor(min(min(rlat)));
latmax=ceil(max(max(rlat)));
lonmin=floor(min(min(rlon)));
lonmax=ceil(max(max(rlon)));


llmima=find((hlon<=lonmax)&(hlon>=lonmin)&(hlat<=latmax)&(hlat>=latmin));
[n_sub dum]=size(find((hlon<=lonmax)&(hlon>=lonmin))); n_sub=n_sub/mmax;
[m_sub dum]=size(find((hlat<=latmax)&(hlat>=latmin))); m_sub=m_sub/nmax;
%check: size(llmima)(1)*size(llmima)(2)==m_sub*n_sub

hlon_sub=reshape(hlon(llmima),n_sub,m_sub);
hlat_sub=reshape(hlat(llmima),n_sub,m_sub);


%---------------------------------------------------------------------
%  Read data.
%---------------------------------------------------------------------
disp('Reading TPXO data ...')

%%% Components %%%

for itide=1:nmnc(3);
  compstring(1:4)=fread(tpid,[1 4],'char');
  components(itide,1:4)=char(compstring);
end;

stbt = fread(tpid,[1 1],'int32');
stbt = fread(tpid,[1 1],'int32');

return
%%% Complex elevations %%%

disp('   elevations ...')
for itide=1:nmnc(3);

  for m=1:nmnc(2);
    for n=1:nmnc(1);
	elev(n,m,:)=fread(tpid,[1 2],'float32');
    end;
  end;

  ssh=complex(elev(:,:,1),elev(:,:,2));	
  ssh_sub=reshape(ssh(llmima),n_sub,m_sub);
  ssh_sub=nozero(hlon_sub,hlat_sub,ssh_sub);
  ei(:,:,itide)=griddata(hlon_sub,hlat_sub,ssh_sub,rlon,rlat); 	
	
end; % itide

% clear stbt ssh ssh_sub elev

fclose(tpid);  

%%% Bathymetry for UV %%%

disp('   bathymetry ...')
tpid=fopen(Bname,'r');
	
stbt       = fread(tpid,[1 1],'int32');
nm         = fread(tpid,[1 2],'int32');
thetalimUV = fread(tpid,[1 2],'float');
philimUV   = fread(tpid,[1 2],'float');

if (philim ~=philimUV), 
  error('longitude limits (philim) ssh & UV do not match')
end;	

if (thetalim ~=thetalimUV), 
  error('latitude limits (philim) ssh & UV do not match')
end;	

headr  = fread(tpid,[1 2],'float');
headr2 = fread(tpid,[1 5],'int32');

for m=1:nm(2);
  for n=1:nm(1);
    hz(n,m)=fread(tpid,[1 1],'float32');
  end;
end;

fclose(tpid);  

clear stbt nm thetalimUV philimUV headr headr2

%%% Complex transports UV  %%%

disp('   transports UV ...')
tpid=fopen(UVname,'r');
	
stbt       = fread(tpid,[1 1],'int32');
nmnc       = fread(tpid,[1 3],'int32');
thetalimUV = fread(tpid,[1 2],'float');
philimUV   = fread(tpid,[1 2],'float');

if(philim ~=philimUV), 
  error('longitude limits (philim) ssh & UV do not match')
end;	

if(thetalim ~=thetalimUV), 
  error('latitude limits (philim) ssh & UV do not match')
end;	

for itide=1:nmnc(3);
  compstring(1:4)=fread(tpid,[1 4],'char');
  components(itide,1:4)=char(compstring);
end;

stbt = fread(tpid,[1 1],'int32');
stbt = fread(tpid,[1 1],'int32');

for itide=1:nmnc(3);

  for m=1:nmnc(2);
    for n=1:nmnc(1);
	for uvi=1:2;
	  UV(n,m,uvi,:)=fread(tpid,[1 2],'float32');
	end;
    end;
  end;

  uv=squeeze(complex(UV(:,:,1,1),UV(:,:,1,2)));
  uv1=uv(1,:);
  uv(1:nmnc(1)-1,:)=0.5*squeeze(uv(1:nmnc(1)-1,:) + uv(2:nmnc(1),:));
  uv(nmnc(1)    ,:)=0.5*squeeze(uv(  nmnc(1)  ,:) + uv1);
  warning off; uv=uv./hz; warning on;
	
  uv_sub=reshape(uv(llmima),n_sub,m_sub);
  uv_sub=nozero(hlon_sub,hlat_sub,uv_sub);
  ui(:,:,itide)=griddata(hlon_sub,hlat_sub,uv_sub,rlon,rlat); 	
	
  uv=squeeze(complex(UV(:,:,2,1),UV(:,:,2,2)));
  uv(:,1:nmnc(2)-1)=0.5*squeeze(uv(:,1:nmnc(2)-1) + uv(:,2:nmnc(2)));
  uv(:,nmnc(2))  =      squeeze(uv(:,  nmnc(2)));
  warning off; uv=uv./hz; warning on; 

  uv_sub=reshape(uv(llmima),n_sub,m_sub);
  uv_sub=nozero(hlon_sub,hlat_sub,uv_sub);
  vi(:,:,itide)=griddata(hlon_sub,hlat_sub,uv_sub,rlon,rlat); 

end; % itide

clear UV uv uv_sub UVstb thetalimUV philimUV compstring

fclose(tpid);  

%%% Check order components & periods %%% 

check_components= ...
[ 'm2';  's2';  'n2';  'k2';  'k1';  'o1';  'p1';  'q1';  'mf';  'mm' ];

%check=prod(prod(components(:,1:2)==check_components(:,:)));
%if(~check),
%  error('components do not match periods, change periods manually')
%end;

periods = [12.4206  12.0000  12.6583  11.9672 ...
	     23.9345  25.8193  24.0659  26.8684 ... 
			          327.8599 661.3100]; % [hr]

%---------------------------------------------------------------------
% check rank in ROMS
% Change order according to rank
%---------------------------------------------------------------------
disp('Change tidal rank ...')

tidalrank = ...
[  1      4      5      7      2      3      6      8      9     10];

tmp=ei;
for k=1:nmnc(3),
  tmp(:,:,tidalrank(k))=ei(:,:,k);
end;
ei=tmp;
Tide.Ephase=-angle(tmp(:,:,1:Ntides)).*deg;
Tide.Eamp  =abs(tmp(:,:,1:Ntides));

for k=1:nmnc(3),
  tmp(:,:,tidalrank(k))=ui(:,:,k);
end;
ui_pha=-angle(tmp(:,:,1:Ntides)).*deg;
ui_amp=abs(tmp(:,:,1:Ntides));

for k=1:nmnc(3),
  tmp(:,:,tidalrank(k))=vi(:,:,k);
end;
vi_pha=-angle(tmp(:,:,1:Ntides)).*deg;
vi_amp=abs(tmp(:,:,1:Ntides));

clear tmp; 

tmp=periods;
for k=1:nmnc(3),
  tmp(tidalrank(k))=periods(k);
end;
Tide.period=tmp(1:Ntides);
clear tmp; 

tmp=components;
for k=1:nmnc(3),
  tmp(tidalrank(k),:)=components(k,:);
end;
Tide.component=tmp(1:Ntides,:);
clear tmp;
  
if (iSAVE), 
  save Tide_ap_ROMS Tide ui_amp ui_pha vi_amp vi_pha
end;

else, %~iLOAD

load('Tide_ap_ROMS.mat');

end;


if(iNODAL),
%---------------------------------------------------------------------
%  Correct phases and amplitudes for real time runs
%  Use parts of pos-processing code from Egbert's & Erofeeva's (OSU) 
%  TPXO model. Their routines have been adapted from code by Richard Ray 
%  (@?) and David Cartwright.
%---------------------------------------------------------------------
	
disp('Correct astronomical phases & amplitudes for real time runs')

% Determine nodal corrections pu & pf :
% these expressions are valid for period 1990-2010 (Cartwright 1990).

% reset time origin for astronomical arguments to 4th of May 1860:
  timetemp=tstart-51544.4993;
	
% mean longitude of lunar perigee
% -------------------------------
  P =  83.3535 +  0.11140353 * timetemp;
  P = mod(P,360.0);
  P(P<0.0) = P(P<0.0) + 360.0;
  P=P*rad;
	
% mean longitude of ascending lunar node
% --------------------------------------
  N = 125.0445 -  0.05295377 * timetemp;
  N = mod(N,360.0) ;
  N(N<0.0) = N(N<0.0) + 360.0;
  N=N*rad;
	
% nodal corrections: pf = amplitude scaling factor [], 
%                    pu = phase correction [deg]
      
sinn = sin(N);
cosn = cos(N);

sin2n = sin(2*N);
cos2n = cos(2*N);

sin3n = sin(3*N);

tmp1  = 1.36*cos(P)+.267*cos((P-N)); 
tmp2  = 0.64*sin(P)+.135*sin((P-N));  

temp1 = 1.-0.25*cos(2*P)-0.11*cos((2*P-N))-0.04*cosn ;
temp2 =    0.25*sin(2*P)+0.11*sin((2*P-N))+0.04*sinn ;

pftmp  = sqrt((1.-.03731*cosn+.00052*cos2n)^2+ ...
                 (.03731*sinn-.00052*sin2n)^2)                          ;% 2N2

pf(10) = 1.0 - 0.130*cosn                        				;% Mm
pf( 9) = 1.043 + 0.414*cosn                      				;% Mf
pf( 8) = sqrt((1.+.188*cosn)^2+(.188*sinn)^2)  					;% Q1
pf( 7) = sqrt((1.+.2852*cosn+.0324*cos2n)^2+(.3108*sinn+.0324*sin2n)^2) ;% K2
pf( 6) = 1.0                                    				;% P1
pf( 5) = pftmp                                     				;% N2
pf( 4) = 1.0                                     				;% S2
pf( 3) = sqrt((1.+.189*cosn-0.0058*cos2n)^2+(.189*sinn -.0058*sin2n)^2) ;% O1
pf( 2) = sqrt((1.+.1158*cosn-.0029*cos2n)^2+(.1554*sinn-.0029*sin2n)^2) ;% K1
pf( 1) = pftmp    								      ;% M2

putmp  = atan((-.03731*sinn+.00052*sin2n)/ ...
            (1.-.03731*cosn+.00052*cos2n))*deg                          ;% 2N2

pu(10) = 0.0                                    				;% Mm
pu( 9) = -23.7*sinn + 2.7*sin2n - 0.4*sin3n      				;% Mf
pu( 8) = atan(.189*sinn/(1.+.189*cosn))*deg      				;% Q1
pu( 7) = atan(-(.3108*sinn+.0324*sin2n)/(1.+.2852*cosn+.0324*cos2n))*deg;% K2
pu( 6) = 0.0                                    				;% P1
pu( 5) = putmp                                 					;% N2
pu( 4) = 0.0                                    				;% S2
pu( 3) = 10.8*sinn - 1.3*sin2n + 0.2*sin3n      				;% O1
pu( 2) = atan((-.1554*sinn+.0029*sin2n)/(1.+.1158*cosn-.0029*cos2n))*deg;% K1
pu( 1) = putmp                                 					;% M2


% to determine phase shifts below time should be in hours
% relatively Jan 1 1992 (=48622mjd) 
      
t0=48622.0*24.0;
	
% Astronomical arguments, obtained with Richard Ray's
% "arguments" and "astrol", for Jan 1, 1992, 00:00 Greenwich time

phase_mkB=[1.731557546,0.173003674,1.558553872,0.000000000, ...
	     6.050721243,6.110181633,3.487600001,5.877717569, ...
	     1.756042456,1.964021610].*deg;

% New amplitudes and phases:

for k=1:Ntides,
  Tide.Eamp(:,:,k)=Tide.Eamp(:,:,k).*pf(k) ; 	
  Tide.Ephase(:,:,k)=Tide.Ephase(:,:,k) ...
           -phase_mkB(k)-pu(k)+360.*t0./Tide.period(k);	      

  ui_amp(:,:,k)=ui_amp(:,:,k).*pf(k)   ; 
  vi_amp(:,:,k)=vi_amp(:,:,k).*pf(k)   ;

  ui_pha(:,:,k)=ui_pha(:,:,k) ...
           -phase_mkB(k)-pu(k)+360.*t0./Tide.period(k);
  vi_pha(:,:,k)=vi_pha(:,:,k) ...
           -phase_mkB(k)-pu(k)+360.*t0./Tide.period(k);
end;
Tide.Ephase = mod(Tide.Ephase,360.0);
ui_pha      = mod(ui_pha,360.0);
vi_pha      = mod(vi_pha,360.0);

	
end, % NODAL


%---------------------------------------------------------------------
%  Convert tidal current amplitude and phase lag parameters to tidal
%  current ellipse parameters: Major axis, ellipticity, inclination,
%  and phase.  Use "tidal_ellipse" (Zhigang Xu) package.
%---------------------------------------------------------------------

disp('Convert to tidal ellipse parameters')
[major,eccentricity,inclination,phase]=ap2ep(ui_amp,ui_pha,vi_amp,vi_pha);

Tide.Cmax=major;
Tide.Cmin=major.*eccentricity;
Tide.Cangle=inclination;
Tide.Cphase=phase;

clear ui_amp ui_pha vi_amp vi_pha phase_mkB t0
clear major eccentricity inclination phase

%---------------------------------------------------------------------
%  Write out tide data into FORCING NetCDF file.
%---------------------------------------------------------------------

if (iWRITE),
   disp('write to forcing file')
  [Vname,status]=wrt_tides(Fname,Tide);
end;

%---------------------------------------------------------------------
%  Plot results.
%---------------------------------------------------------------------

if (iPLOT),

  for k=1:Ntides,  

    figure

    subplot(1,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Eamp(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Amplitude (m)');

    subplot(1,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Ephase(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    xlabel('Phase Angle (degree)');
  
  end,

  for k=1:Ntides,  

    figure

    subplot(2,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Cmax(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Major Axis amplitude (m/s)');

    subplot(2,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Cmin(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    xlabel('Minor Axis amplitude (m/s)');
  
    subplot(2,2,3)
    pcolor(rlon,rlat,squeeze(Tide.Cangle(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    xlabel('Inclination Angle (degrees)');

    subplot(2,2,4)
    pcolor(rlon,rlat,squeeze(Tide.Cphase(:,:,k)).*rmask);
    shading('flat'); colorbar; grid on;
    xlabel('Phase Angle (degrees)');

 end,

end,




