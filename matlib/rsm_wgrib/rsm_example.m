% Example 
% Manu - (edl@gatech.edu)

disp('% ---------------  EXTRACT INVENTORY -------------------- %');

gribfile=which('lsmsk00.grib');
help rsm_get_inv
disp('gribfile=which(''lsmsk00.grib'')');
disp(['inv = rsm_get_inv(gribfile)']);
inv = rsm_get_inv(gribfile)

disp('% ---------------  EXTRACT RECORD # 1 ------------------- %')
help rsm_extract_record
disp(['LAND=rsm_extract_record(gribfile, 1)']);
LAND=rsm_extract_record(gribfile, 1);


% Jason ERA 40
addpath /sdb/edl/ROMS-pak/matlib/rsm_wgrib
gribfile='/sdd/furtadoj/precip/ERA40/e4oper.sfc.pcp.197603';
inv = rsm_get_inv(gribfile);
TP=rsm_extract_record(gribfile, 1);