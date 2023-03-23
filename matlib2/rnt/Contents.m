%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  (R)oms (N)umerical (T)oolbox -  RNT Toolbox
%  Version 3.0  Aug 2008 by Manu
%  http://rnt.ocean3d.org  --> turorials and more
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% ROMS NUMERICS
%  rnt_gridinfo.m      Add/Update your grid configurations (do 1st)
%  rnt_gridload.m      Loads grid variables
%  rnt_setdepth.m      Returns depths of sigma coordinates at rho points
%- rnt_wvelocity.m     Compute vertical  velocity w(x,y,s)
%  rnt_2grid.m         Shift a variable from one grid to another
%  rnt_curl.m          Compute curl of vector (u,v) on model grid psi-points
%- rnt_rotate.m        Rotate u,v vectors at a given angle
%- rnt_barotropic.m    Compute barotropic u v
%- rnt_prsV2.m         Compute pressure gradient term and geostrophic vel.
%- rnt_rho_eos.m       Compute DENSITY using ROMS equation of state
%- rnt_spice.m         Compute SPICE field
%- rnt_earthdist.m     Compute earth distances 
%                          
% NETCDF INPUT/OUTPUT MANIPULATIONS
%  rnt_timectl.m       Make CTL array from multiple netcdf files
%  rnt_getfilenames.m  Make a list of netcdf file to concatenate in CTL
%  rnt_loadvar.m       Load variables using the CTL
%  rnt_loadvar_segp.m  Load variables subsets using the CTL
%  rnt_savevar.m       Save variables using the CTL
%  rnt_loadState.m     Load a structure array with the ROMS full state
%  rnt_saveState.m     Save a structure array with the ROMS full state
%  rnt_extr_timeseries.m Extract timeseries from model output
%
% PLOTTING FUNCTIONS
%  rnt_plot_sigma.m    Plot/show the sigma coordinates
%  rnt_contourfill.m   Modified version of contourfill.m
%- rnt_plc.m           Horizzontal 2D variable 
%  rnt_plcm.m          Horizzontal 2D variable using M_MAP Toolbox
%  rnt_sectx.m         Extract plot sections along an index in the X direction
%  rnt_secty.m         Extract plot sections along an index in the Y direction
%  rnt_section.m       Extract arbitrary section along given X,Y coordinates
%  rnt_pl_vec.m        Plot velocity vectors (uses rnt_quiver.m)
%  rnt_getframe.m      Getframe for making movies
%  rnt_makemovie.m     Make movie, used with rnt_getframe.m
%
% INTERPOLATION / EXTRAPOLATION / NESTING FUNCTIONS:
%  rnt_griddata.m      Faster version of griddata.m, uses rnt_hindicesTRI.m
%  rnt_2z.m            Interpolate from s-grid to z-grid
%  rnt_2s.m            Interpolate from z-grid to s-grid (cubic)
%  rnt_2sigma.m        Interpolate from s-grid to rho-grid
%  rnt_oapmap.m        Find closest points of one grid to another
%  rnt_oa2d.m          2D Objetive Mapping function
%  rnt_oa3d.m          3D Objective Mapping function
%- rnt_grid2grid.m     Interpolate/Extrapolate a 3D variable from one grid to another
%  rnt_fill.m          Fill NaN values of 2D array using Objective Mapping
%  rnt_hindicesTRI.m   Find I,J indices of grid for a given X,Y coordinate
%  rnt_ingrid.m        Subsample domain of data needed for destination grid 
%
% STATISTICS
%  rnt_doEof.m         Perform EOF analysis of a 2D field with mask
%  rnt_filter3d.m      Running mean of 2D time-dependent field
%
% MEX FILES (compile instructions):
%- rnt_compile_mex.m   Compile all RNT Mex files
%- rnt_compile_mex.txt Instructions using g95 fortran compiler
%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%                    -  RNT developer  -
%                       Emanuele Di Lorenzo (edl@gatech.edu)
%                       School of Earth and Atmospheric Sciences
%                       Georgia Institute of Technology
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%