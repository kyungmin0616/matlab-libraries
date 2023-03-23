function test_nc_getdiminfo ( )
% TEST_NC_GETDIMINFO:
%
% Relies upon nc_add_dimension, nc_addvar, nc_addnewrecs
%
% This first set of tests should fail
%
% These tests should be successful.
% Test 0120:  test an unlimited dimension, numeric input
%
% Test 020:   1st input numeric, 2nd is character
% Test 021:   1st input numeric, 2nd is character
%
% Test 0100:  test a limited dimension, numeric input (tmw)
% Test 0101:  test a limited dimension, numeric input (java)
% Test 0102:  test a limited dimension, numeric input (mexnc)


fprintf ( 1, 'NC_GETDIMINFO:  starting test suite...\n' );

test_nc3_backend;
test_hdf5_backend;

function test_nc3_backend()
fprintf('\tRunning local netcdf-3 tests.\n');
empty_ncfile = 'testdata/empty.nc';
full_ncfile = 'testdata/full.nc';
test_local(empty_ncfile, full_ncfile);
return






function test_hdf5_backend()
	if release_lt_r2009a
		fprintf('\thdf5 backend testing filtered out on matlab versions less than R2009a.\n');
		return
	end
	if ~getpref('SNCTOOLS','USE_HDF54NC4',false)
		fprintf('\tnc4hdf5 backend testing filtered out on configurations where SNCTOOLS ''USE_HDF54NC4'' prefererence is false.\n');
		return
	end

	empty_ncfile = 'testdata/empty-4.nc';
	full_ncfile = 'testdata/full-4.nc';
	test_local(empty_ncfile, full_ncfile);
return






function test_local (empty_ncfile, full_ncfile )
test_neg_noArgs                  ( empty_ncfile );
test_neg_onlyOneArg              ( empty_ncfile );
test_neg_tooManyInputs           ( empty_ncfile );
test_neg_1stArgNotNetcdfFile;
test_neg_2ndArgNotVarName        ( full_ncfile );
test_neg_numericArgs1stNotNcid   ( full_ncfile );
test_neg_numericArgs2ndNotDimid  ( full_ncfile );
test_neg_argOneCharArgTwoNumeric ( full_ncfile );
test_neg_ncidViaPackageDimDoesNotExist ( full_ncfile );
test_neg_ncidViaMexncDimDoesNotExist ( full_ncfile );
test_unlimited ( full_ncfile );
test_limited ( full_ncfile );
return






function test_neg_noArgs ( ncfile )
try
    nb = nc_getdiminfo;
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return



function test_neg_onlyOneArg ( ncfile )
try
    nb = nc_getdiminfo ( ncfile );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return



function test_neg_tooManyInputs ( ncfile )
try
    diminfo = nc_getdiminfo ( ncfile, 'x', 'y' );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return





function create_test_file ( ncfile )

%
% Ok, create a valid netcdf file now.
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'ocean_time', 0 );
nc_add_dimension ( ncfile, 'x', 2 );

clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'ocean_time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't1';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

%
% write ten records
x = [0:9]';
b.ocean_time = x;
b.t1 = x;
b.t2 = 1./(1+x);
b.t3 = x.^2;
nb = nc_addnewrecs ( ncfile, b, 'ocean_time' );




return

function test_neg_1stArgNotNetcdfFile ( )

try
    diminfo = nc_getdiminfo ( 'does_not_exist.nc', 'x' );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return





function test_neg_2ndArgNotVarName ( ncfile )

try
    diminfo = nc_getdiminfo ( ncfile, 'var_does_not_exist' );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return




function test_neg_numericArgs1stNotNcid ( ncfile )
try
    diminfo = nc_getdiminfo ( 1, 1 );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return



function test_neg_numericArgs2ndNotDimid ( ncfile )

if snctools_use_tmw
	test_nc_getdiminfo_007_tmw(ncfile);

elseif snctools_use_mexnc
    [ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
    if ( status ~= 0 )
        error ( 'mexnc:open failed' );
    end
	try
    	diminfo = nc_getdiminfo ( ncid, 25000 );
	catch
    	mexnc ( 'close', ncid );
		return
	end
	error('succeeded when it should have failed');
end

return



function test_neg_argOneCharArgTwoNumeric ( ncfile )
try
    diminfo = nc_getdiminfo ( ncfile, 25 );
    msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
    error ( msg );
end
return







function test_neg_ncidViaPackageDimDoesNotExist ( ncfile )

if snctools_use_tmw
    ncid = netcdf.open(ncfile,nc_nowrite_mode);

    try
        diminfo = nc_getdiminfo ( ncid, 'ocean_time' );
        msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
        error ( msg );
    end
    netcdf.close(ncid);
end
return




function test_neg_ncidViaMexncDimDoesNotExist ( ncfile )

if snctools_use_mexnc
    [ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
    if ( status ~= 0 )
        msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
        error ( msg );
    end

    try
        diminfo = nc_getdiminfo ( ncid, 'ocean_time' );
        msg = sprintf ( '%s:   succeeded when it should have failed.\n', mfilename  );
        error ( msg );
    end
    mexnc ( 'close', ncid );
end
return





function test_unlimited ( ncfile )
diminfo = nc_getdiminfo ( ncfile, 't' );
if ~strcmp ( diminfo.Name, 't' )
    msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Length ~= 0 )
    msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Unlimited ~= 1 )
    msg = sprintf ( '%s:  diminfo.Unlimited was incorrect.\n', mfilename  );
    error ( msg );
end
return





function test_limited ( ncfile )

diminfo = nc_getdiminfo ( ncfile, 's' );
if ~strcmp ( diminfo.Name, 's' )
    msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Length ~= 1 )
    msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Unlimited ~= 0 )
    msg = sprintf ( '%s:  diminfo.Unlimited was incorrect.\n', mfilename  );
    error ( msg );
end
return





%---------------------------------------------------------------------------
function test_0120_neutral ( diminfo )

if ~strcmp ( diminfo.Name, 't' )
    msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Length ~= 0 )
    msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Unlimited ~= 1 )
    msg = sprintf ( '%s:  diminfo.Unlimited was incorrect.\n', mfilename  );
    error ( msg );
end
return


function test_0120 ( ncfile )

if snctools_use_java

    import ucar.nc2.dods.*  ;
    import ucar.nc2.*       ;

    if exist(ncfile,'file')
        jncid = NetcdfFile.open(ncfile);
    else
        jncid = DODSNetcdfFile(ncfile);
    end
    dim = jncid.findDimension('t');
    diminfo = nc_getdiminfo ( jncid, dim );

	test_0120_neutral(diminfo);

end


function test_0121 ( ncfile )
if snctools_use_tmw

    ncid = netcdf.open(ncfile,nc_nowrite_mode);
    diminfo = nc_getdiminfo ( ncid, 1 );
    netcdf.close(ncid );
	test_0120_neutral(diminfo);

end

function test_0122 ( ncfile )
if snctools_use_mexnc
    [ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
    if ( status ~= 0 )
        msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
        error ( msg );
    end
    diminfo = nc_getdiminfo ( ncid, 1 );
    mexnc ( 'close', ncid );
end

return




%----------------------------------------------------------------------------------
function test_unlimited0 ( ncfile )

if snctools_use_tmw
	ncid = netcdf.open(ncfile,nc_nowrite_mode);
	diminfo = nc_getdiminfo ( ncid, 0 );
	netcdf.close(ncid);

	test_unlimited0_abstract(diminfo);
end
return


function test_unlimited0_abstract(diminfo)
if ~strcmp ( diminfo.Name, 's' )
    msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Length ~= 1 )
    msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename  );
    error ( msg );
end
if ( diminfo.Unlimited ~= 0 )
    msg = sprintf ( '%s:  diminfo.Unlimited was incorrect.\n', mfilename  );
    error ( msg );
end

return




function test_unlimited1 ( ncfile )

if snctools_use_java

    import ucar.nc2.dods.*  ;
    import ucar.nc2.*       ;

    if exist(ncfile,'file')
        jncid = NetcdfFile.open(ncfile);
    else
        jncid = DODSNetcdfFile(ncfile);
    end
    dim = jncid.findDimension('s');
    diminfo = nc_getdiminfo ( jncid, dim );

	test_unlimited0_abstract(diminfo);
end
return




function test_unlimited2 ( ncfile )
 
if snctools_use_mexnc
    [ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
    if ( status ~= 0 )
        msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
        error ( msg );
    end
    diminfo = nc_getdiminfo ( ncid, 0 );
    mexnc ( 'close', ncid );

	test_unlimited0_abstract(diminfo);
end
return
 
 
function tf = release_lt_r2009a
v = version('-release');
switch ( v ) 
	case { '11', '12', '13', '14', '2006a', '2006b', '2007a', ...
	       '2007b', '2008a', '2008b' }
		   tf = true;
	otherwise
		   tf= false;
end
return
