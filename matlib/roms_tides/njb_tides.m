%  This script extract tidal information from ADCIRC simulation data.

IPLOT=1;
IWRITE=1;
ROTATE=0;     %  tides are rotated in ROMS routine clm_tides

Gname='/n7/arango/NJB/Jul00/Data/njb1_grid_a.nc';
%Fname='/n7/arango/NJB/Jul01/Data/njb1_Fcoamps_jul01.nc';

Fname='/n7/arango/NJB/Jul01/Data/njb1_coamps_jul01.nc';

%---------------------------------------------------------------------
%  Read in application grid data.
%---------------------------------------------------------------------

rlon=nc_read(Gname,'lon_rho');
rlat=nc_read(Gname,'lat_rho');
rangle=nc_read(Gname,'angle');
[Lp,Mp]=size(rlon);

rmask =nc_read(Gname,'mask_rho');
[iwater]=find(rmask > 0.5);

%---------------------------------------------------------------------
%  Load ADCIRC data.
%---------------------------------------------------------------------

load adcirc_tide_fix.mat

Ntide=length(periods);

%---------------------------------------------------------------------
%  Interpolate tide data to application grid.
%---------------------------------------------------------------------
%
%  Initialize arrays for interpolated tidal data.

ei=ones(Lp,Mp,Ntide).*NaN;                       % elevation
ui=ones(Lp,Mp,Ntide).*NaN;                       % u 
vi=ones(Lp,Mp,Ntide).*NaN;                       % v


%  Interpolate elevation and velocity from ADCIRC model data using
%  "triterp", linear-interpolation from triangulated grid.

for k=1:Ntide,

  tmp=ones(Lp,Mp).*NaN;
  tmp(iwater)=triterp(tri,lon,lat,elev(:,k),rlon(iwater),rlat(iwater));
  ei(:,:,k)=tmp;

  Uwrk=ones(Lp,Mp).*NaN;
  Uwrk(iwater)=triterp(tri,lon,lat,u(:,k),rlon(iwater),rlat(iwater));
  Uwrk=reshape(Uwrk,Lp,Mp);

  Vwrk=ones(Lp,Mp).*NaN;
  Vwrk(iwater)=triterp(tri,lon,lat,v(:,k),rlon(iwater),rlat(iwater));
  Vwrk=reshape(Vwrk,Lp,Mp);

  if (ROTATE),
    ui(:,:,k)=Uwrk.*cos(rangle)+Vwrk.*sin(rangle);
    vi(:,:,k)=Vwrk.*cos(rangle)-Uwrk.*sin(rangle);
  else,
    ui(:,:,k)=Uwrk;
    vi(:,:,k)=Vwrk;
  end,

end,

clear tmp Uwrk Vwrk

%---------------------------------------------------------------------
%  Extract tide-induced mean elevation and velocity components.
%---------------------------------------------------------------------

Tide.Emean=squeeze(abs(ei(:,:,1)));
Tide.Amean=squeeze(angle(ei(:,:,1))).*180/pi;
Tide.Umean=squeeze(ui(:,:,1));
Tide.Vmean=squeeze(vi(:,:,1));

%---------------------------------------------------------------------
%  Extract other tidal contituents (2:Ntide).
%---------------------------------------------------------------------

Tide.period=periods(2:Ntide);
Tide.component=['O1'; 'K1'; 'N2'; 'M2'; 'S2'; 'M4'; 'M6'];

Tide.Ephase=angle(ei(:,:,2:Ntide)).*180./pi;
Tide.Eamp  =abs(ei(:,:,2:Ntide));

clear ei

%---------------------------------------------------------------------
%  Convert tidal current amplitude and phase lag parameters to tidal
%  current ellipse parameters: Major axis, ellipticity, inclination,
%  and phase.  Use "tidal_ellipse" (Zhigang Xu) package.
%---------------------------------------------------------------------

ui_pha=angle(ui(:,:,2:Ntide)).*180./pi;
ui_amp=abs(ui(:,:,2:Ntide));

vi_pha=angle(vi(:,:,2:Ntide)).*180./pi;
vi_amp=abs(vi(:,:,2:Ntide));

[major,eccentricity,inclination,phase]=ap2ep(ui_amp,ui_pha,vi_amp,vi_pha);

Tide.Cmax=major;
Tide.Cmin=major.*eccentricity;
Tide.Cangle=inclination;
Tide.Cphase=phase;

clear ui ui_amp ui_pha vi vi_amp vi_pha
clear major eccentricity inclination phase

%---------------------------------------------------------------------
%  Plot results.
%---------------------------------------------------------------------

if (IPLOT),

  figure

  subplot(2,2,1)
  pcolor(rlon,rlat,Tide.Emean);
  shading('interp'); colorbar; dasp(43); grid on;
  xlabel('Mean Tidal Elevation (m)');

  subplot(2,2,2)
  pcolor(rlon,rlat,Tide.Amean);
  shading('interp'); colorbar; dasp(43); grid on;
  xlabel('Mean Tidal Phase (degree)');

  subplot(2,2,3)
  pcolor(rlon,rlat,Tide.Umean);
  shading('interp'); colorbar; dasp(43); grid on;
  xlabel('Mean Tidal U-current (m/s)');

  subplot(2,2,4)
  pcolor(rlon,rlat,Tide.Vmean);
  shading('interp'); colorbar; dasp(43); grid on;
  xlabel('Mean Tidal U-current (m/s)');

  for k=1:Ntide-1,  

    figure

    subplot(1,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Eamp(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Amplitude (m)');

    subplot(1,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Ephase(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    xlabel('Phase Angle (degree)');
  
  end,

  for k=1:Ntide-1,  

    figure

    subplot(2,2,1)
    pcolor(rlon,rlat,squeeze(Tide.Cmax(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    title(strcat(Tide.component(k,:),' Tidal Component'));
    xlabel('Major Axis amplitude (m/s)');

    subplot(2,2,2)
    pcolor(rlon,rlat,squeeze(Tide.Cmin(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    xlabel('Minor Axis amplitude (m/s)');
  
    subplot(2,2,3)
    pcolor(rlon,rlat,squeeze(Tide.Cangle(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    xlabel('Inclination Angle (degrees)');

    subplot(2,2,4)
    pcolor(rlon,rlat,squeeze(Tide.Cphase(:,:,k)));
    shading('interp'); colorbar; dasp(43); grid on;
    xlabel('Phase Angle(degrees)');

 end,

end,

%---------------------------------------------------------------------
%  Write out tide data into FORCING NetCDF file.
%---------------------------------------------------------------------

if (IWRITE),
  [Vname,status]=wrt_tides(Fname,Tide);
end,
