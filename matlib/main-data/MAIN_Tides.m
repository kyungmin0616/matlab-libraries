% MANU: this is the main routine. You need to put the TIDES
% data in the struct. array TIDES interpolated to the ROMS grid
% at the rho points. The you are all set. This routine can also
% include the nodal correction. If you want enable this by copying
% the NODAL code from the add_tides.m in the tidal toolbox.


%function add_tide(forcname,grd,TIDES)
grd=rnt_gridload('wash');
forcname='wash-forc.nc';
TidalExFile='wash-tides.mat';
MyComponents={'M2' 'K1'};
%MyComponents={'M2' 'K1' 'O1' 'S2'};
Fname =forcname;  % ROMS forcing and grid files
Gname =grd.grdfile;
% currently I have CCS calif. curr., OHS sea of ostok, global coasre res.
tidal_dataname ='CCS';
load( ['tpxo6_',tidal_dataname,'.mat'], 'tpxo');
pcolor(tpxo.lonr-360,tpxo.latr,tpxo.mask); shading interp; hold on
rnt_gridbox(grd,'k');


% Tidal extraction
if ~exist(TidalExFile)
[U,V,ZETA,TIDES]=tpxo_ExtractTide(grd.lonr,grd.latr,MyComponents,tidal_dataname);


% fill in the missing for TIDES amp and phase
myvar = {'ei_amp' 'ei_phase' 'ui_amp' 'ui_phase' 'vi_amp' 'vi_phase' }
for icomp = 1:length(TIDES.period);
   for ivar=1:6
   disp(['Component: ',TIDES.component{icomp}, '   variable: ',myvar{ivar}]);
   eval([   'tmpin= TIDES.'myvar{ivar},'(:,:,icomp);'   ]);
   tmpout = rnt_fill(grd.lonr,grd.latr,tmpin,2,2);
   eval([   'TIDES.'myvar{ivar},'(:,:,icomp)=tmpout;'   ]);   
   end   
end  
save (TidalExFile,'TIDES');
else
disp(['Loading ',TidalExFile]);
load(TidalExFile);
end


Ntides=length(TIDES.period);  
IPLOT   =0;
IWRITE  =1;
ROTATE  =0;  % Tides are rotated in ROMS routine clm_tides
NODAL   =1;  % Correct phase and amplitude using astron. longitudes 
             % for real time runs
		  
rad=pi/180.0;
deg=180.0/pi;

%---------------------------------------------------------------------
%  Read in application grid data.
%---------------------------------------------------------------------

rlon=grd.lonr;
rlat=grd.latr;
rangle=grd.angle;
[Lp,Mp]=size(rlon);

rmask =grd.maskr;
[iwater]=find(rmask > 0.5);

%---------------------------------------------------------------------
%  Load data.
%---------------------------------------------------------------------


% PERIODS, these are already defines in TIDES struct. array. There are kept here
% for your info only.

periods = [12.4206;  12.0000;  12.6583;  11.9672; ...
	     23.9345;  25.8193;  24.0659;  26.8684; ... 
			            327.8599; 661.3100];     % [hr]

%periods  =[12.42; 12.00; 12.66; 11.97; 23.93; 25.82; 24.07; 26.87; 327.86; 661.31];
components=[ 'M2';  'S2';  'N2';  'K2';  'K1';  'O1';  'P1';  'Q1';  'MF';  'MM' ];
rank      =[  1;     4;     5;     7;     2;     3;     6;      8;     9;    10; ];



%---------------------------------------------------------------------
%  Extract other tidal contituents (1:Ntides).
%  Note: sign convention difference between ROMS and OSU tidal model
%---------------------------------------------------------------------


Ntides = length(TIDES.period);

Tide.period=TIDES.period(1:Ntides);

for i=1:Ntides
Tide.component(i,:)=TIDES.component{i};
end


Tide.Ephase = -TIDES.ei_phase*deg;
Tide.Eamp   = TIDES.ei_amp;

ui_pha=-TIDES.ui_phase*deg;
ui_amp=TIDES.ui_amp;

vi_pha=-TIDES.vi_phase*deg;
vi_amp=TIDES.vi_amp;

%NODAL Stuff would be here. Grab it again.

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
%--------period-------------------------------------------------------------

% set 2nd component to zero
Tide.period(2)=0;
Tide.Eamp(:,:,2)=0;
Tide.Ephase(:,:,2)=0;
Tide.Cphase(:,:,2)=0;

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

