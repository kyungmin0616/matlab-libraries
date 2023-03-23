function add_tides_rt(Fname,Gname,Ntides)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This script extracts tidal information from data of 
%  OSU's TPXO.5 tidal model (Egbert & Erofeeva 1994, 2000; 
%  http://www.oce.orst.edu/po/research/tide/global.html)
%  and writes it into input file for ROMS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global IPRINT; IPRINT=0;

IPLOT   =1;
INTERP  =1;
CHECKDAT=1;
IWRITE  =1;
ROTATE  =0;  % Tides are rotated in ROMS routine clm_tides
NODAL   =0;  % Correct phase and amplitude using astron. longitudes 
             % for real time runs
		  
UCLA_system=1;
if UCLA_system,
 SSHr_fname='/disk11/blaas/TIDES/H_tpxo/ssh_real.bin';
 SSHi_fname='/disk11/blaas/TIDES/H_tpxo/ssh_imag.bin';
 Ur_fname  ='/disk11/blaas/TIDES/UV_tpxo/u_real.bin';
 Ui_fname  ='/disk11/blaas/TIDES/UV_tpxo/u_imag.bin';
 Vr_fname  ='/disk11/blaas/TIDES/UV_tpxo/v_real.bin';
 Vi_fname  ='/disk11/blaas/TIDES/UV_tpxo/v_imag.bin';
else,
 SSHr_fname='/users/blaas/ncsa/rt_tides/TPXO/ssh_real.bin';
 SSHi_fname='/users/blaas/ncsa/rt_tides/TPXO/ssh_imag.bin';
 Ur_fname  ='/users/blaas/ncsa/rt_tides/TPXO/u_real.bin';
 Ui_fname  ='/users/blaas/ncsa/rt_tides/TPXO/u_imag.bin';
 Vr_fname  ='/users/blaas/ncsa/rt_tides/TPXO/v_real.bin';
 Vi_fname  ='/users/blaas/ncsa/rt_tides/TPXO/v_imag.bin';
end;

rad=pi/180.0;
deg=180.0/pi;

%---------------------------------------------------------------------
%  Read in application grid data.
%---------------------------------------------------------------------

rlon=nc_read(Gname,'lon_rho');
rlat=nc_read(Gname,'lat_rho');
rangle=nc_read(Gname,'angle');
[Lp,Mp]=size(rlon);

rmask =nc_read(Gname,'mask_rho');
rmask(rmask==0)=NaN;
[iwater]=find(rmask > 0.5);

%---------------------------------------------------------------------
%  Load data.
%---------------------------------------------------------------------

Maxtides=10;  % Max nb of components is 10
IL=81; IM=62; % subgrid size of TPXO.5 data file

% SSH

fid1=fopen(SSHr_fname,'r');
fid2=fopen(SSHi_fname,'r');
for itide=1:Maxtides;
  elev_real(:,:,itide)=fread(fid1,[IL IM],'float');
  elev_imag(:,:,itide)=fread(fid2,[IL IM],'float');
end;
fclose(fid1); fclose(fid2); 
elev=complex(elev_real,elev_imag);

% U

fid1=fopen(Ur_fname,'r');
fid2=fopen(Ui_fname,'r');
for itide=1:Maxtides;
  u_real(:,:,itide)=fread(fid1,[IL IM],'float');
  u_imag(:,:,itide)=fread(fid2,[IL IM],'float');
end;
fclose(fid1); fclose(fid2); 
u=complex(u_real,u_imag);

% V

fid1=fopen(Vr_fname,'r');
fid2=fopen(Vi_fname,'r');
for itide=1:Maxtides;
  v_real(:,:,itide)=fread(fid1,[IL IM],'float');
  v_imag(:,:,itide)=fread(fid2,[IL IM],'float');
end;
fclose(fid1); fclose(fid2); 
v=complex(v_real,v_imag);

% LON,LAT

dx=0.5; dy=0.5; lon1=0.25; lat1=-85.75;
i1=420; i2=500; j1=212; j2=273; % U.S. West Coast
lone=lon1+(i1-.5)*dx; lonw=lon1+(i2-.5)*dx;
lats=lat1+(j1-.5)*dy; latn=lat1+(j2-.5)*dy;
[lon,lat]=ndgrid(lone:dx:lonw, lats:dy:latn);
lon(lon>180)=lon(lon>180)-360;

% PERIODS

periods   =[12.42; 12.00; 12.66; 11.97; 23.93; 25.82; 24.07; 26.87; 327.86; 661.31];
components=[ 'M2';  'S2';  'N2';  'K2';  'K1';  'O1';  'P1';  'Q1';  'MF';  'MM' ];
rank      =[  1;     4;     5;     7;     2;     3;     6;      8;     9;    10; ];


%---------------------------------------------------------------------
%  Change order according to rank
%---------------------------------------------------------------------
tmp=elev;
for k=1:Maxtides,
  tmp(:,:,rank(k))=elev(:,:,k);
end;
elev=tmp;
for k=1:Maxtides,
  tmp(:,:,rank(k))=u(:,:,k);
end;
u=tmp;
for k=1:Maxtides,
  tmp(:,:,rank(k))=v(:,:,k);
end;
v=tmp;
clear tmp; tmp=periods;
for k=1:Maxtides,
  tmp(rank(k))=periods(k);
end;
periods=tmp;
clear tmp; tmp=components;
for k=1:Maxtides,
  tmp(rank(k),:)=components(k,:);
end;
components=tmp;

if(INTERP),
%---------------------------------------------------------------------
%  Interpolate tide data to application grid.
%---------------------------------------------------------------------

for k=1:Ntides,
  elev(:,:,k)=nozero(lon,lat,elev(:,:,k));
  ei(:,:,k)=griddata(lon,lat,elev(:,:,k),rlon,rlat);

  u(:,:,k)=nozero(lon,lat,u(:,:,k));
  ui(:,:,k)=griddata(lon,lat,u(:,:,k),rlon,rlat);

  v(:,:,k)=nozero(lon,lat,v(:,:,k));
  vi(:,:,k)=griddata(lon,lat,v(:,:,k),rlon,rlat);
end,


%---------------------------------------------------------------------
%  Extract other tidal contituents (1:Ntides).
%  Note: sign convention difference between ROMS and OSU tidal model
%---------------------------------------------------------------------

Tide.period=periods(1:Ntides);
Tide.component=components(1:Ntides,:);

Tide.Ephase=-angle(ei(:,:,1:Ntides)).*deg;
Tide.Eamp  =abs(ei(:,:,1:Ntides));

ui_pha=-angle(ui(:,:,1:Ntides)).*deg;
ui_amp=abs(ui(:,:,1:Ntides));

vi_pha=-angle(vi(:,:,1:Ntides)).*deg;
vi_amp=abs(vi(:,:,1:Ntides));

end, % INTERP
%clear ei ui vi

%---------------------------------------------------------------------
%  Correct phases and amplitudes for real time runs
%  Use parts of post-processing code from Egbert's & Erofeeva's (OSU) TPXO model
%  Their routines have been adapted from code by Richard Ray (?) and 
%  David Cartwright.
%---------------------------------------------------------------------

if(NODAL),
disp('correct astronomical phases & amplitudes for real time runs')

%  Set start time of simulation in fractional mjd from:
%  later: set start calendar date & time and calculate fractional 
%  mjd internally...

 mjd=52275;   h=0.; min=0.;
 tstart=mjd+h/24+min/(60*24)
 if(CHECKDAT), disp(mjd2greg(mjd)); end;
    
% Determine nodal corrections pu & pf :
% these expressions are valid for period 1990-2010 (Cartwright 1990).

% reset time origin for astronomical arguments to 4th of May 1860:
 timetemp=tstart-51544.4993;
	
%     mean longitude of lunar perigee
%     -------------------------------
 	P =  83.3535 +  0.11140353 * timetemp;
 	P = mod(P,360.0);
    	if (P<0.0), 
	     P = P + 360.0;
     	end,
	P=P*rad;
	
%     mean longitude of ascending lunar node
%     --------------------------------------
    	N = 125.0445 -  0.05295377 * timetemp;
	N = mod(N,360.0) ;
    	if (N<0.0),
	    N = N + 360.0;
    	end,
	N=N*rad;
	
% nodal corrections: 
% pf = amplitude scaling factor [], pu = phase correction [deg]
      
 sinn = sin(N);
 cosn = cos(N);

 sin2n = sin(2.0*N);
 cos2n = cos(2.0*N);

 sin3n = sin(3.0*N);

 tmp1  = 1.36*cos(P)+.267*cos((P-N)); 
 tmp2  = 0.64*sin(P)+.135*sin((P-N));  

 temp1 = 1.-0.25*cos(2.0*P)-0.11*cos((2.0*P-N))-0.04*cosn ;
 temp2 =    0.25*sin(2.0*P)+0.11*sin((2.0*P-N))+0.04*sinn ;

 pftmp  = sqrt( (1.-.03731*cosn+.00052*cos2n)^2 + (.03731*sinn-.00052*sin2n)^2 ) ;% 2N2

 pf(10) = 1.0 - 0.130*cosn                        				;% Mm
 pf( 9) = 1.043 + 0.414*cosn                      				;% Mf
 pf( 8) = sqrt((1.+.188*cosn)^2+(.188*sinn)^2)  				;% Q1
 pf( 7) = sqrt((1.+.2852*cosn+.0324*cos2n)^2+(.3108*sinn+.0324*sin2n)^2);% K2
 pf( 6) = 1.0                                    				;% P1
 pf( 5) = pftmp                                     				;% N2
 pf( 4) = 1.0                                     				;% S2
 pf( 3) = sqrt((1.+.189*cosn-0.0058*cos2n)^2+(.189*sinn-.0058*sin2n)^2) ;% O1
 pf( 2) = sqrt((1.+.1158*cosn-.0029*cos2n)^2+(.1554*sinn-.0029*sin2n)^2);% K1
 pf( 1) = pftmp    								      ;% M2

 putmp  = atan((-.03731*sinn+.00052*sin2n)/(1.-.03731*cosn+.00052*cos2n))*deg;% 2N2

 pu(10) = 0.0                                    				;% Mm
 pu( 9) = -23.7*sinn + 2.7*sin2n - 0.4*sin3n      				;% Mf
 pu( 8) = atan(.189*sinn/(1.+.189*cosn))*deg      				;% Q1
 pu( 7) = atan(-(.3108*sinn+.0324*sin2n)/(1.+.2852*cosn+.0324*cos2n))*deg;% K2
 pu( 6) = 0.0                                    				;% P1
 pu( 5) = putmp                                 				;% N2
 pu( 4) = 0.0                                    				;% S2
 pu( 3) = 10.8*sinn - 1.3*sin2n + 0.2*sin3n      				;% O1
 pu( 2) = atan((-.1554*sinn+.0029*sin2n)/(1.+.1158*cosn-.0029*cos2n))*deg;% K1
 pu( 1) = putmp                                 				;% M2

% to determine phase shifts below time should be in hours
% relatively Jan 1 1992 (=48622mjd) 
      
 t0=(tstart-48622.0)*24.0
	
% Astronomical arguments, obtained with Richard Ray's
% "arguments" and "astrol", for Jan 1, 1992, 00:00 Greenwich time

 phase_mkB=[1.731557546, 0.173003674, 1.558553872, 0.000000000, ...
		6.050721243, 6.110181633, 3.487600001, 5.877717569, ...
		1.756042456, 1.964021610].*deg;

% New amplitudes and phases:

 for k=1:Ntides,
  Tide.Eamp(:,:,k)=Tide.Eamp(:,:,k).*pf(k) ; 	
  Tide.Ephase(:,:,k)=Tide.Ephase(:,:,k)-phase_mkB(k)-pu(k)- ...
                                       360.*t0./Tide.period(k);	      

  ui_amp(:,:,k)=ui_amp(:,:,k).*pf(k)   ; 
  vi_amp(:,:,k)=vi_amp(:,:,k).*pf(k)   ;

  ui_pha(:,:,k)=ui_pha(:,:,k)-phase_mkB(k)-pu(k)-360.*t0./Tide.period(k);
  vi_pha(:,:,k)=vi_pha(:,:,k)-phase_mkB(k)-pu(k)-360.*t0./Tide.period(k);

 end,
 Tide.Ephase = mod(Tide.Ephase,360.0);
 ui_pha      = mod(ui_pha,360.0);
 vi_pha      = mod(vi_pha,360.0);
end, % NODAL

%---------------------------------------------------------------------
%  Convert tidal current amplitude and phase lag parameters to tidal
%  current ellipse parameters: Major axis, ellipticity, inclination,
%  and phase.  Use "tidal_ellipse" (Zhigang Xu) package.
%---------------------------------------------------------------------

[major,eccentricity,inclination,phase]=ap2ep(ui_amp,ui_pha,vi_amp,vi_pha);

Tide.Cmax=major;
Tide.Cmin=major.*eccentricity;
Tide.Cangle=inclination;
Tide.Cphase=phase;

% clear ui_amp ui_pha vi_amp vi_pha
clear major eccentricity inclination phase

%---------------------------------------------------------------------
%  Write out tide data into FORCING NetCDF file.
%---------------------------------------------------------------------

if (IWRITE),
  [Vname,status]=wrt_tides(Fname,Tide);
end,

%---------------------------------------------------------------------
%  Plot results.
%---------------------------------------------------------------------

if (IPLOT),

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
    xlabel('Phase Angle(degrees)');

 end,

end,

