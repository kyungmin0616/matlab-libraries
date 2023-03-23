%RNT_GRIDINFO
% function grdinfo = rnt_gridinfo(gridid)
% Loads the grid configuration for GRIDID. To add 
% a new grid please edit this file. You cab copy 
% an existing one and modify for your needs. 
%
% INPUT: 
% GRIDID string representing the grid configuration
%
% OUTPUT:
% GRDINFO structure array containing grid information
%

function gridindo=rnt_gridinfo(gridid)
  
% initialize to defaults
  gridindo.id      = gridid;
  gridindo.name    = '';
  gridindo.grdfile = '';
  gridindo.N       = 20;
  gridindo.thetas  = 5;
  gridindo.thetab  = 0.4;
  gridindo.tcline  = 200;
  gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');
  
  if exist(gridid)== 2
     file = textread(gridid,'%s','delimiter','\n','whitespace','');
     for i=1:length(file)
       eval(file{i});
     end
     return
  end  
 
  switch gridid

  case 'nena8km'
    gridindo.id      = gridid;
    gridindo.name    = 'Nena 8km  ';
    gridindo.grdfile = which('nena8km-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');

  case 'crd_10km'
    gridindo.id      = gridid;
    gridindo.name    = 'crd_10km';
    gridindo.grdfile = '/nv/pe1/hluo33/TTD_10km/crd_10km-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');


  case 'cadiz15'
    gridindo.id      = gridid;
    gridindo.name    = 'Cadiz 15 km  ';
    gridindo.grdfile = '/nas/mer/cadiz/input/cadiz-grid.nc';
    gridindo.N       = 32;
    gridindo.thetas  = 6;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.hc  = 200;
    gridindo.cstfile = '/nas/mer/cadiz/matlib/cadiz_coastline.mat';

  case 'med8km'
    gridindo.id      = gridid;
    gridindo.name    = 'Mediterranean 8km  ';
    gridindo.grdfile = '/dods/Mediterraneo/med-data/med8km-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');

  case 'shallow2d'
    gridindo.id      = gridid;
    gridindo.name    = 'Nena 8km  ';
    gridindo.grdfile = which('shallow2d-grid.nc');
    gridindo.N       = 1;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;

  case 'coriolis'
    gridindo.id      = gridid;
    gridindo.name    = 'Coriolis Inertial Oscillation';
    gridindo.grdfile = which('coriolis-grid.nc');
    gridindo.N       = 16;
    gridindo.thetas  = 0;
    gridindo.thetab  = 0;

  case 'ekman'
    gridindo.id      = gridid;
    gridindo.name    = 'Ekman Coastal Upwelling';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/ekman/input/ekman-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 7;
    gridindo.thetab  = 0.4;

  case 'mabgom4'
    gridindo.id      = gridid;
    gridindo.name    = 'mabgom4_hycom  ';
    gridindo.grdfile = 'mabgom4_hycom.nc';
    gridindo.N       = 36;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;

  case 'nepd'
    gridindo.id      = gridid;
    gridindo.name    = 'NEPD-GOA-CCS grid';
    gridindo.grdfile = '/drive/edl/NEPD/nepd-data/nepd-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'pac'
    gridindo.id      = gridid;
    gridindo.name    = 'Pacific';
    gridindo.grdfile = '/ocean/sdc/Paci025.1/pac25_grd.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'nepd10'
    gridindo.id      = gridid;
    gridindo.name    = 'NEPD-GOA-CCS grid';
    gridindo.grdfile = '/drive/edl/NEPD/nepd-data/nepd-grid10.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'scb20'
    gridindo.id      = gridid;
    gridindo.name    = 'SCB 20 km';
    gridindo.grdfile = '/nas/edl/Adjoint-Passive/scb-data/scb20-grid.nc';
    gridindo.thetas  = 6.5;
    gridindo.thetab  = 0;
    gridindo.hc  = 84.2521;

  case 'nepd-ccs'
    gridindo.id      = gridid;
    gridindo.name    = 'NEPD-CCS grid';
    gridindo.grdfile = '/drive/edl/NEPD/nepd-data/nepd-ccs-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'pcr'
    gridindo.id      = gridid;
    gridindo.name    = 'Peru Chile Region';
    gridindo.grdfile = '/dods/SCOAR/pcr-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 6.5;
    gridindo.thetab  = 0;
    gridindo.cstfile = which('rgrd_CoastlineWorldPacificPlus.mat');



  case 'upwmount'
    gridindo.id      = gridid;
    gridindo.name    = 'Upwelling Mount';
    gridindo.grdfile = '/Users/neo/Desktop/MATLAB/gfd_root/roms-adjoint-sens/input/upwmount-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

 case 'sdroms'
    gridindo.id      = gridid;
    gridindo.name    = 'SDROMS 600 m';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sdroms-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 3;
    gridindo.thetab  = 0.2;
    gridindo.tcline  = 100;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sdcoast.mat';

 case 'scroms'
    gridindo.id      = gridid;
    gridindo.name    = 'South California ROMS 1km res';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/scroms-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 3;
    gridindo.thetab  = 0.2;
    gridindo.tcline  = 100;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/socal_coast.mat';

  case 'sccoos'
    gridindo.id      = gridid;
    gridindo.name    = 'SCCOOS base grid';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-grids/sccoos-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.2;
    gridindo.tcline  = 200;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-coast.mat';

  case 'sccoos1'
    gridindo.id      = gridid;
    gridindo.name    = 'SCCOOS 2.5 km';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-grids/sccoos-grid.nc.1';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.2;
    gridindo.tcline  = 200;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-coast.mat';

  case 'sccoos2'
    gridindo.id      = gridid;
    gridindo.name    = 'SCCOOS 600 m';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-grids/sccoos-grid.nc.2';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.2;
    gridindo.tcline  = 200;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/sccoos-data/grids/sccoos-coast.mat';

  case 'npacific'
    gridindo.id      = gridid;
    gridindo.name    = 'North Pacific';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/npacific/input/npacific-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.hc  = 30;
    gridindo.thetab  = 0.4;

  case 'indian'
    gridindo.id      = gridid;
    gridindo.name    = 'Indian Ocean';
    gridindo.grdfile = '/neo/INDIAN/indian-grid_noSC.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 6;
    gridindo.thetab  = 0.0;

  case 'ias10'
    gridindo.id      = gridid;
    gridindo.name    = 'Caribbean HIRES Manu';
    gridindo.grdfile = '/drive/dana/IAS10/10km/ias10-manu-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/ias20-data/ias_coast.mat';

  case 'ias10-paleo'
    gridindo.id      = gridid;
    gridindo.name    = 'Caribbean HIRES Manu PALEO';
    gridindo.grdfile = '/drive/dana/IAS10/10km/ias10-manu-paleogrid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = '/sdb/edl/ROMS-pak/ias20-data/ias_coast.mat';

   case 'hcs'
    gridindo.id      = gridid;
    gridindo.name    = 'Humboldt Current System';
    gridindo.grdfile = '/nas/vc/PCCS/input/hcs_ofes-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 6.5;
    gridindo.thetab  = 0;
    gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');






  otherwise
    gridindo.id      = gridid;
    gridindo.name    = 'null';
    gridindo.grdfile = '/dev/null';
    gridindo.N       = 0;
    gridindo.thetas  = 0;
    gridindo.thetab  = 0;
    gridindo.tcline  = 0;
    disp([' RNT_GRIDINFO - ',gridid,' not configured']);
  end

