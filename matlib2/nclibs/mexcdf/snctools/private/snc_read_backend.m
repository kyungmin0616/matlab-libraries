function retrieval_method = snc_read_backend(ncfile)

tmw_gt_r2009a = false;
tmw_gt_r2008b = false;
tmw_gt_r2008a = false;

v = version('-release');
switch ( v )
    case { '11', '12' };
		error('Not supported on releases below R13.');

    case { '13', '14', '2006a', '2006b', '2007a', '2007b', '2008a' }
		;

    case { '2008b' }
        tmw_gt_r2008a = true;

    case { '2009a' }
        tmw_gt_r2008a = true;
        tmw_gt_r2008b = true;

    case { '2009b' }
        tmw_gt_r2008a = true;
        tmw_gt_r2008b = true;
        tmw_gt_r2009a = true;

    otherwise
		% Assume 10a or beyond.
        tmw_gt_r2009a = true;

end


% Check for this early.
use_hdf5 = getpref('SNCTOOLS','USE_HDF54NC4',false);
use_java = getpref('SNCTOOLS','USE_JAVA',false);
if use_java
    retrieval_method = 'java';
    return
end
if isa(ncfile,'ucar.nc2.NetcdfFile') && use_java
    retrieval_method = 'java';
	return
end

file_is_nc4 = exist(ncfile,'file') && isnc4(ncfile);
file_is_nc3 = exist(ncfile,'file') && isnc3(ncfile);

if tmw_gt_r2008b && file_is_nc4 && use_hdf5
    % Use native HDF5 for all local NC4 files when the version = R2009a
    retrieval_method = 'hdf5';
elseif tmw_gt_r2008a && file_is_nc3
    % Use TMW for all local NC3 files when the version >= R2008b
    retrieval_method = 'tmw';
elseif file_is_nc3
    % Local NC3 files should rely on mexnc when the version <= R2008a
    retrieval_method = 'mexnc';
elseif use_java 
    % Can be a URL or NC4 file
    retrieval_method = 'java';
elseif file_is_nc4
    % NC4 file where we have <=2008b and java is not an option.
    % Try to use the community mex-file.
    retrieval_method = 'mexnc';
elseif ~isempty(regexp(ncfile,'https*://', 'once'))
    % a URL when java is not enabled.  Use mexnc
    retrieval_method = 'mexnc';
else
    error('SNCTOOLS:unknownBackendSituation', ...
      'Could not determine which backend to use with %s.', ...
       ncfile );
end

return



