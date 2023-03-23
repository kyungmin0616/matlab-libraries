
% Determine the directory
matlib=which('add_libs_rnt.m');
matlib=matlib(1:end-14);
vers_rel=version('-release');

% New toolboxes for group maintained by Gianni
path(path, [matlib,'gianni']);
path(path, [matlib,'gianni/ct_ana']);
path(path, [matlib,'gianni/ct_plt']);
path(path, [matlib,'gianni/ct_ext']);
path(path, [matlib,'gianni/ct_misc']);
path(path, [matlib,'gianni/MISC']);



% Roms Numerical Toolbox from E. Di Lorenzo (edl@gatech.edu)
path(path, [matlib,'rnt']);
path(path, [matlib,'rnt/mex']);
if strcmp(vers_rel, '2012a')
  path(path, [matlib,'rnt/mex/binaries-2012a']);
else
  path(path, [matlib,'rnt/mex/binaries-all']);
end
path(path, [matlib,'rnt/util']);
path(path, [matlib,'rnt/work']);
path(path, [matlib,'rnt/obsolete']);
% Hernan Tools
path(path, [matlib,'rnt/htools']);
% Nesting tools from UCLA group (P.Penven, P. Marchesiello, Xavier Capet)
path(path, [matlib,'rnt/ptools']);
% Other useful toolboxes
path(path, [matlib,'rout']);
path(path, [matlib,'rgrd']);
path(path, [matlib,'grids']);
path(path, [matlib,'rnc']);
path(path, [matlib,'rntp']);
path(path, [matlib,'printtools']);
path(path, [matlib,'rsm_wgrib']);
path(path, [matlib,'dan']);
% Editmask from ashcherbina@ucsd.edu, 11/15/01
path(path, [matlib,'rmask']);
% Seagrid toolbox from Chuck again.
path(path, [matlib,'seagrid']);
path(path, [matlib,'presto']);
% Seawater toolbox from CSIRO
path(path, [matlib,'seawater']);
% M_map toolbox from Rich Signell.
path(path, [matlib,'m_map']);
path(path, [matlib,'gridgen']);
path(path, [matlib,'pic']);
% read cdc data
path(path, [matlib,'cdc']);
% OFES model toolbox
path(path, [matlib,'ofes']);
path(path, [matlib,'ofes/ofes2roms']);
% AR1 NPO AR model 
path(path, [matlib,'climate/AR1_AL_NPO']);


% OpenDAP data services
%--------------------------------------------------------
matlibDAP=[matlib,'/datasets_dap/'];
% Aviso SSHa
path(path, [matlibDAP,'aviso']);
% NCEP/NOAA data
path(path, [matlibDAP,'slp_sst']);


% Start adding DATASET in to path
%--------------------------------------------------------
matlibdata=[matlib,'/datasets/'];
if exist(matlibdata)
if ~ismac
% RNT example datasets
path(path, [matlibdata,'rnt_examples']);
% SODA
path(path, [matlibdata,'soda']);
% QuickScatt
path(path, [matlibdata,'qsc']);
% CalCOFI data
path(path, [matlibdata,'ieh']);
% topex_topo from Sandwell and Smith, topography
path(path, [matlibdata,'topex_topo']);
% NCEP data on poldo
path(path, [matlibdata,'climas']);
end
end

% Netcdf Interface
%--------------------------------------------------------
matlibnc=[matlib,'/nclibs/'];

% add Netcdf toolboxes
vers=version;
vers_rel=version('-release');
if ~ismac
% UNIX/LINUX
if vers(1) == '6'
  path(path, [matlibnc,'netcdf6']);
  path(path, [matlibnc,'netcdf6/nctype']);
  path(path, [matlibnc,'netcdf6/ncutility']);
  path(path, [matlibnc,'netcdf6/ncfiles']);
elseif strcmp(vers(1:3), '7.9')
  path(path, [matlibnc,'mexcdf/mexnc']);
  path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf']);
  path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/nctype']);
  path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/ncutility']);
  path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/ncsource']);
  path(path, [matlibnc,'mexcdf/snctools']);
  javaaddpath ([matlibnc,'mexcdf/netcdfAll-4.0.jar'] ) ; 
  setpref ( 'SNCTOOLS', 'USE_JAVA', true ); 
  setpref ( 'NETCDF', 'USE_JAVA', true ); 
elseif strcmp(vers_rel, '2012a')
  javaaddpath([matlibnc,'mexcdf-R2012a/java/netcdfAll-4.2.jar']);
  path(path, [matlibnc,'mexcdf-R2012a/mexnc']);
  path(path, [matlibnc,'mexcdf-R2012a/snctools']);
  path(path, [matlibnc,'netcdf-osx']);
  path(path, [matlibnc,'netcdf-osx/nctype']);
  path(path, [matlibnc,'netcdf-osx/ncutility']);
else
  path(path, [matlibnc,'mexnc-all']);
  path(path, [matlibnc,'netcdf/netcdf']);
  path(path, [matlibnc,'netcdf/netcdf/nctype']);
  path(path, [matlibnc,'netcdf/netcdf/ncutility']);
  path(path, [matlibnc,'snctools']);
end

else
% MAC OSX
  path(path, [matlibnc,'mexnc-osx-R2012a/mexnc']);
  path(path, [matlibnc,'mexnc-osx-R2012a/snctools']);
  javaaddpath([matlibnc,'mexnc-osx-R2012a/java/netcdfAll-4.2.jar'],'-end');
  path(path, [matlibnc,'netcdf-osx']);
  path(path, [matlibnc,'netcdf-osx/nctype']);
  path(path, [matlibnc,'netcdf-osx/ncutility']);
  path(path, [matlibnc,'loaddap-osx']);
end

ncquiet
warning off


% Obsolete
if ~ismac
path(path, [matlib,'obsolete/spectra']);
path(path, [matlib,'obsolete/rnl']);
end

%path(path, '/d1/manu/matlib/calcofi');
% Older tools not frequently used
%path(path, '/sdb/edl/PREDICTABILITY/matlib');
%path(path, '/sdb/edl/ROMS-pak/tides-data/matlib/tides');
%path(path, '/sdb/edl/TIDES/Report_NOV_03');
%path(path, '/sdb/edl/ROMS-pak/matlib/roms_tides');
%path(path, '/sdb/edl/ROMS-pak/matlib/tidal_ellipse');
%path(path, '/sdb/edl/TIDES/matlib');
%path(path,'/sdb/edl/TIDES/matlib')
%path(path, '/sdb/edl/TIDES/TPXO.6/mat_tpxo6.0');
%path(path,[matlib,'acc-model']);





