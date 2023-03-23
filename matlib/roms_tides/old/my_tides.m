%  This script extract tidal information from simulation data.

clear all; 
close all;
global IPRINT; IPRINT=0;

IPLOT=1;
IWRITE=1;
ROTATE=0;     %  tides are rotated in ROMS routine clm_tides

Gname='usw15_grid.nc';
Fname='usw15_coamps.nc';
Ntides=10;  % Nb of tidal components

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

Maxtides=10; % Max nb of components is 10
IL=81; IM=62;

% SSH

fid1=fopen('/disk27/patrickm/TIDES/H_tpxo/ssh_real.bin','r');
fid2=fopen('/disk27/patrickm/TIDES/H_tpxo/ssh_imag.bin','r');
for itide=1:Maxtides;
  elev_real(:,:,itide)=fread(fid1,[IL IM],'float');
  elev_imag(:,:,itide)=fread(fid2,[IL IM],'float');
end;
fclose(fid1); fclose(fid2); 
elev=complex(elev_real,elev_imag);

% U

fid1=fopen('/disk27/patrickm/TIDES/UV_tpxo/u_real.bin','r');
fid2=fopen('/disk27/patrickm/TIDES/UV_tpxo/u_imag.bin','r');
for itide=1:Maxtides;
  u_real(:,:,itide)=fread(fid1,[IL IM],'float');
  u_imag(:,:,itide)=fread(fid2,[IL IM],'float');
end;
fclose(fid1); fclose(fid2); 
u=complex(u_real,u_imag);

% V

fid1=fopen('/disk27/patrickm/TIDES/UV_tpxo/v_real.bin','r');
fid2=fopen('/disk27/patrickm/TIDES/UV_tpxo/v_imag.bin','r');
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

%vphase=angle(vi(:,:,1))*180/pi;
%uphase=angle(ui(:,:,1))*180/pi;
%figure(1);pcolor(rlon,rlat,uphase);shading flat;colorbar;
%figure(2);pcolor(rlon,rlat,vphase);shading flat;colorbar;
%uphase(uphase<0)=uphase(uphase<0)+360;
%vphase(vphase<0)=vphase(vphase<0)+360;
%return

%---------------------------------------------------------------------
%  Extract other tidal contituents (1:Ntides).
%  Note: sign convention difference between ROMS and OSU tidal model
%---------------------------------------------------------------------

Tide.period=periods(1:Ntides);
Tide.component=components(1:Ntides,:);

Tide.Ephase =-angle(ei(:,:,1:Ntides)).*180/pi;
Tide.Eamp   = abs(ei(:,:,1:Ntides));

ui_pha      =-angle(ui(:,:,1:Ntides)).*180/pi;
ui_amp      = abs(ui(:,:,1:Ntides));

vi_pha      =-angle(vi(:,:,1:Ntides)).*180/pi;
vi_amp      = abs(vi(:,:,1:Ntides));

clear ei ui vi
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

clear ui_amp ui_pha vi_amp vi_pha
clear major eccentricity inclination phase

%---------------------------------------------------------------------
%  Plot results.
%---------------------------------------------------------------------

if (IPLOT),

  for k=1:Ntides,  

    figure

    subplot(1,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Eamp(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Amplitude (m)');

    subplot(1,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Ephase(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    xlabel('Phase Angle (degree)');
  
  end,

  for k=1:Ntides,  

    figure

    subplot(2,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Cmax(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Major Axis amplitude (m/s)');

    subplot(2,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Cmin(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    xlabel('Minor Axis amplitude (m/s)');
  
    subplot(2,2,3)
    pcolor(rlon,rlat,squeeze(Tide.Cangle(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    xlabel('Inclination Angle (degrees)');

    subplot(2,2,4)
    pcolor(rlon,rlat,squeeze(Tide.Cphase(:,:,k)).*rmask);
    shading('flat'); colorbar; dasp(35); grid on;
    xlabel('Phase Angle(degrees)');

 end,

end,

%---------------------------------------------------------------------
%  Write out tide data into FORCING NetCDF file.
%---------------------------------------------------------------------

if (IWRITE),
  [Vname,status]=wrt_tides(Fname,Tide);
end,
