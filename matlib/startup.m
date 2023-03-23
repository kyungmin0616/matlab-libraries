
% Data files
path(path, '/neo/ROMS_Tutorial/data');

% ROMS MAIN scripts for input file creation
path(path, '/neo/ROMS_Tutorial/main-data');

% ROMS Grids already made
path(path, '/neo/ROMS_Tutorial/grids');

% other matlab paths
matlib='/neo/ROMS_Tutorial/matlib/';

path(path, [matlib,'cdc']);
path(path, [matlib,'dods-lib']);
path(path, [matlib,'gridgen']);
path(path, [matlib,'misc']);
path(path, [matlib,'m_map']);
path(path, [matlib,'nesting_tools']);
path(path, [matlib,'opendap']);
path(path, [matlib,'pic']);
path(path, [matlib,'presto']);
path(path, [matlib,'printtools']);
path(path, [matlib,'rgrd']);
path(path, [matlib,'rmask']);
path(path, [matlib,'rnc']);
path(path, [matlib,'rnt']);
path(path, [matlib,'roms_tides']);
path(path, [matlib,'seagrid']);
path(path, [matlib,'seawater']);
path(path, [matlib,'spectra']);
path(path, [matlib,'qsc']);
path(path, [matlib,'rntp']);
path(path, [matlib,'rsm_wgrib']);
path(path, [matlib,'tools']);
path(path, [matlib,'topex_topo']);


vers=version;
if vers(1) == '7'
path(path, [matlib,'netcdf7/netcdf']);
path(path, [matlib,'netcdf7/netcdf/nctype']);
path(path, [matlib,'netcdf7/netcdf/ncutility']);
path(path, [matlib,'mexnc']);
path(path, [matlib,'snctools']);
else
path(path, [matlib,'netcdf']);
path(path, [matlib,'netcdf/nctype']);
path(path, [matlib,'netcdf/ncutility']);
path(path, [matlib,'netcdf/ncfiles']);
%path(path, [matlib7,'snctools']);
end

ncquiet




