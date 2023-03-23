% Main program to generate the grid file for ROMS.
% Please mannually step through this script and edit when
% it is requested. You will find a line marked EDIT.
% E. Di Lorenzo - May 2003

% This script will help you generate rectangular curvilinear grids only.

%==========================================================
%	Preparing the grid param
%==========================================================
  
 % EDIT: set a name to recognize the grid
 nameit='china';  % 8 km grid

 % EDIT: set path where you want to store the grid.
 outdir=['../',nameit,'-data/']; 
 if ~exist(outdir), unix(['mkdir ',outdir]);end
 grdfile=[outdir,nameit,'-grid.nc'];  

% EDIT: insert detailed coastline file if wanted. You can extract it
% form the web at: rimmer.ngdc.noaa.gov/coast
% After you donwload the file use ConvertCstdat2mat.m
% otherwise use default. The format is lon,lat in the mat file.
 seagridCoastline='CoastlineWorld.mat';  % default centered on Atlantic/Indian
 seagridCoastline='CoastlineWorldPacific.mat'; % default centered on Pacific

 
 DrawCstLine(seagridCoastline);
 
 
 
 % zoom in the picture to approximately select the location of
 % your final grid.
 [Lons]=get(gca,'xlim'); 
 [Lats]=get(gca,'ylim');
 
 % EDIT: or set mannually
 %Lats=[33 33.5];Lons=[-178 -177];
 %Lats=[33 33.1];Lons=[-154 -153.5];
 
 close
 
 % set ax= [LonMin, LonMax, LatMin, LatMax]
 % so that you include the location of the grid your
 % are building
 %ax=[-180 -75 0 67]; % you can also set them by hand
 LatMin=Lats(1); LatMax=Lats(2);
 LonMin=Lons(1); LonMax=Lons(2);
 ax= [LonMin, LonMax, LatMin, LatMax]
 

 % EDIT: put the name of the file in which the scirpt will
 % save the 4 corners of your grid in LON,LAT . 
 CornerFile= [outdir,'GridCorners-',nameit,'.dat'];

% yu have two options to generate the corners of the grid:
% OPT: 1
% If your corner are the one in ax then just write the 
% corner file. WriteCornerFileFromAX.m
  WriteCornerFileFromAX(ax,CornerFile);

% OPT: 2 
% IF you already have a corner file than skip the FindGridCorners
 % use this routine to design grid if needed. FindGridCorners.m 
 FindGridCorners (ax,seagridCoastline,CornerFile);
 close all
 
 
 % Plot grid
 PlotGridCorners(ax,CornerFile,seagridCoastline);

 % Find the distance and needed reolution for the grid.
 % TellMeCornerDist.m
 [x_spacing,y_spacing]=TellMeCornerDist(CornerFile);
  % remember these spacing, round them to be even.
  disp('You need to set these in Seagrid');
  Cells_Edge_1 = round(y_spacing/2)*2
  Cells_Edge_2 = round(x_spacing/2)*2

 
%==========================================================
%	Build grid  -  Running Seagrid 
%==========================================================
 % execute seagrid and prepare grid
 % in seagrid just 
 % 1) load the coastline file and the boundary file
 % 2) set the spacing in setup using Cells_Edge_1, Cells_Edge_2
 % 3) On the menu compute select "Set all water"
 % 4) then save the seagrid.mat file and exit.
 seagrid
 % if you like you can also load the topography and use the
 % mask computation options. I prefer taking care of this later
 % in this script. It is up to you.
 
 % convert seagrid file to ROMS grid
 seagrid2roms('seagrid.mat', grdfile);

 % EDIT add new grid in the rnt_gridinfo.m 
 configfile=which('rnt_gridinfo');
 unix(['vi ',configfile]);
 grd=rnt_gridload(nameit);
 % check spacing in PM and PN direction
 figure
 subplot(2,1,1)
 rnt_plcm(1./grd.pm,grd); title( 'M direction (km)');
 subplot(2,1,2)
 rnt_plcm(1./grd.pn,grd); title( 'N direction');
  
%==========================================================
%	topography
%==========================================================
  h=grd.h;
  h(:,:)=-800; % set to some analytical function or use
  % Sandwell and Smith below.

  % Extract Sandwell and Smith topo -----------------------
  %region to be extracted from the Sandwell and Smith topo
  %[south north west east];
  region =[min(grd.latr(:))-1 max(grd.latr(:))+1 ...
           min(grd.lonr(:))-1+360 max(grd.lonr(:))+1+360]
  
  [image_data,vlat,vlon] = mygrid_sand(region,1);
  hold on
  rnt_gridbox(grd,'k');
  
  dy=vlat(2)-vlat(1);
  dx=vlon(2)-vlon(1);  
  DX = abs(grd.lonr(1,1)-grd.lonr(2,1));
  DY = abs(grd.latr(2,2)-grd.latr(2,1));
  DX=floor(DX/dx);
  DY=floor(DY/dy);
  % DX=1; DY=1;
  
  [vlon,vlat]=meshgrid(vlon,vlat);
  vlon=vlon(1:DX:end,1:DY:end);
  vlat=vlat(1:DX:end,1:DY:end);
  image_data=image_data(1:DX:end,1:DY:end);
  
  % still need to do some work to make this better and more
  % efficient. May take long.
  h=griddata(vlon,vlat,image_data,grd.lonr,grd.latr,'cubic');
  % End Extract Sandwell and Smith topo --------------------
  
  % store raw topography
  h(h>0) = 0;
  h = abs(h); % need to be positive for ROMS convention.
  nc=netcdf(grdfile,'w');
  nc{'h'}(:,:)=h';
  nc{'hraw'}(1,:,:)=h';
  close(nc);
  % reload grid
  grd=rnt_gridload(nameit);
  
  %EDIT: set minimum depth for topography.
  hmin = 7;
  hraw = grd.h;
  hraw(hraw< hmin) = hmin;
  rnt_plcm(rvalue(hraw),grd); title 'rvalue h';
  % Keep Rvalue below .2 if possible.
  
  steep = find(rvalue(hraw)>0.2);
  
  
  % Now start smoothing ----------------------------------
  % start smoothing if you find rvalue > 0.2
  % this is an approximate method.

  % topography soothing
  % OPT 1 : shapiro
  tmp = shapiro2(hraw,2,2);   % once filtered
  for i=1:10
     tmp = shapiro2(tmp,2,2);   % once filtered
  end  
  rnt_plcm(rvalue(tmp),grd); title 'rvalue h';
  % OPT 2 : roi filter
  % ...
  % ...
  
  %save topo
  nc=netcdf(grdfile,'w');
  nc{'h'}(:,:)=tmp';
  close(nc)
% end smoothing ----------------------------------------
  
  
  
  figure;
  grd=rnt_gridload(nameit);
  subplot(2,2,1); rnt_plcm(sq(grd.hraw(1,:,:)),grd); title 'hraw'
  subplot(2,2,2); rnt_plcm(grd.h,grd); title (['h  (min depth ',num2str(hmin),' )'])
  subplot(2,2,3); rnt_plcm(rvalue(grd.h),grd); title 'rvalue h'
  subplot(2,2,4); rnt_plcm(grd.h-sq(grd.hraw(1,:,:)),grd); title 'h - hraw'
 
%==========================================================
%	Masking
%==========================================================
  grd=rnt_gridload(nameit);
  mask=grd.maskr;
  mask(grd.h <= hmin) =0;

  
  %save raw mask
  nc=netcdf(grdfile,'w');
  nc{'mask_rho'}(:)=mask';
  close(nc);
  
  % we are here MANU
  editmask(grdfile,seagridCoastline); %by Andrey Scherbina
  % if you do not want to change anything still
  % run editmask, press the SAVE button once and
  % then exit. Thanks.

  % Your grid is ready.
  grd=rnt_gridload(nameit);


