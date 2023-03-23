
% Determine the directory
matlib=which('add_libs_txu.m');
matlib=matlib(1:end-14);
vers_rel=version('-release');

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

% Netcdf Interface
%--------------------------------------------------------
matlibnc=[matlib,'/nclibs/'];

% add Netcdf toolboxes
vers=version;
vers_rel=version('-release');
% if ~ismac
% UNIX/LINUX
% if vers(1) == '6'
%  path(path, [matlibnc,'netcdf6']);
%  path(path, [matlibnc,'netcdf6/nctype']);
%  path(path, [matlibnc,'netcdf6/ncutility']);
%  path(path, [matlibnc,'netcdf6/ncfiles']);
%elseif strcmp(vers(1:3), '7.9')
% path(path, [matlibnc,'mexcdf/mexnc']);
% path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf']);
% path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/nctype']);
% path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/ncutility']);
% path(path, [matlibnc,'mexcdf/netcdf_toolbox/netcdf/ncsource']);
% path(path, [matlibnc,'mexcdf/snctools']);
% javaaddpath ([matlibnc,'mexcdf/netcdfAll-4.0.jar'] ) ; 
% setpref ( 'SNCTOOLS', 'USE_JAVA', true ); 
%  setpref ( 'NETCDF', 'USE_JAVA', true ); 
%elseif strcmp(vers_rel, '2012a')
  javaaddpath([matlibnc,'mexcdf-R2012a/java/netcdfAll-4.2.jar']);
  path(path, [matlibnc,'mexcdf-R2012a/mexnc']);
  path(path, [matlibnc,'mexcdf-R2012a/snctools']);
  path(path, [matlibnc,'netcdf-osx']);
  path(path, [matlibnc,'netcdf-osx/nctype']);
  path(path, [matlibnc,'netcdf-osx/ncutility']);
 % else
  % path(path, [matlibnc,'mexnc-all']);
  % path(path, [matlibnc,'netcdf/netcdf']);
 %  path(path, [matlibnc,'netcdf/netcdf/nctype']);
  % path(path, [matlibnc,'netcdf/netcdf/ncutility']);
 %  path(path, [matlibnc,'snctools']);
% end

% else
% MAC OSX
% path(path, [matlibnc,'mexnc-osx-R2012a/mexnc']);
%  path(path, [matlibnc,'mexnc-osx-R2012a/snctools']);
% javaaddpath([matlibnc,'mexnc-osx-R2012a/java/netcdfAll-4.2.jar'],'-end');
% path(path, [matlibnc,'netcdf-osx']);
% path(path, [matlibnc,'netcdf-osx/nctype']);
% path(path, [matlibnc,'netcdf-osx/ncutility']);
% path(path, [matlibnc,'loaddap-osx']);
% end

%ncquiet
%warning off
