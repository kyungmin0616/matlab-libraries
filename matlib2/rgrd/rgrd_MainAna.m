
% Build Analytical grid
% E. Di Lorenzo
  %==========================================================
  % Preparing the grid param
  %==========================================================
  
  % EDIT: set a name to recognize the grid
  nameit='channel';  % 8 km grid
  
  % EDIT: set path where you want to store the grid.
  outdir=['../',nameit,'-data/'];
  if ~exist(outdir), unix(['mkdir ',outdir]);end
  grdfile=[outdir,nameit,'-grid.nc'];
  
  dx=500;  % m in X direction
  dy=500;  % m in Y direction
  Lp=96;   % number of points in X direction
  Mp=24;   % number of points in Y direction
  
  
  AnaGrid(dx,dy,Lp,Mp,grdfile);
  
  % EDIT add new grid in the rnt_gridinfo.m
  configfile=which('rnt_gridinfo');
  unix(['vi ',configfile]);
  
  % Set bathymetry from analytical function
  %----------------------------------------
  val1=(Mp/2)*dx;
  val2=dx*(Mp);
  
  % load grid
  grd=rnt_gridload(nameit);
  
  for j=1:Mp
    for i=1:Lp
      val3=2.0*(grd.yr(i,j)-val1)/val2;
      h(i,j)= 49 - 47* val3*val3;
    end
  end
  
  hmin=min(h(:));
  hmax=max(h(:));
  nc=netcdf(  grdfile,'w');
  nc{'depthmin'}(:)=hmin;
  nc{'depthmax'}(:)=hmax;
  nc{'hraw'}(:,:)=h';
  nc{'h'}(:,:)=h';
  close(nc)
  
  rnt_plc(rvalue(h),grd,2,5,0,0);

  %If you want to edit mask

  editmask(grdfile,'CoastlineNONE.mat')
