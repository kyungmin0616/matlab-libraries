
% Build Analytical grid
% E. Di Lorenzo
  %==========================================================
  % Preparing the grid param
  %==========================================================
  
  % EDIT: set a name to recognize the grid
  nameit='tides';  % 8 km grid
  
  % EDIT: set path where you want to store the grid.
  outdir=['../',nameit,'-data/'];
  if ~exist(outdir), unix(['mkdir ',outdir]);end
  grdfile=[outdir,nameit,'-grid.nc'];
  
  dx=500;  % m in X direction
  dy=500;  % m in Y direction
  Lp=100;   % number of points in X direction
  Mp=50;   % number of points in Y direction
  
  
  AnaGrid(dx,dy,Lp,Mp,grdfile);
  
  % EDIT add new grid in the rnt_gridinfo.m
%  configfile=which('rnt_gridinfo');
%  unix(['vi ',configfile]);
  
  % Set bathymetry from analytical function
  %----------------------------------------
  val1=(Mp/2)*dx;
  val2=dx*(Mp);
  
  % load grid
  grd=rnt_gridload(nameit);
      h= grd.xr*0 + 4000;
  
  hmin=min(h(:));
  hmax=max(h(:));
  nc=netcdf(  grdfile,'w');
  nc{'depthmin'}(:)=hmin;
  nc{'depthmax'}(:)=hmax;
  nc{'hraw'}(:,:)=h';
  nc{'h'}(:,:)=h';
  close(nc)
  
  %rnt_plc(rvalue(h),grd,2,5,0,0);

  %If you want to edit mask

  %editmask(grdfile,'CoastlineNONE.mat')
