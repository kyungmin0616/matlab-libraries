function test_nc_varget(mode)

if nargin < 1
    mode = 'netcdf-3';
end

fprintf('\t\tTesting NC_VARGET ...  ' );

testroot = fileparts(mfilename('fullpath'));
switch(mode)
    case 'hdf4';
        run_hdf_tests;

    case 'grib'
        run_grib2_tests;

    case 'netcdf-3'
        ncfile = fullfile(testroot,'testdata/varget.nc');
        run_local_tests(ncfile);

    case 'netcdf4-classic'
        ncfile = fullfile(testroot,'testdata/varget4.nc');
        run_local_tests(ncfile);

    case 'netcdf4-enhanced'
        run_nc4_enhanced;
        
    case 'opendap'
        run_opendap_tests;

end

fprintf('OK\n');


%--------------------------------------------------------------------------
function run_nc4_enhanced()
testroot = fileparts(mfilename('fullpath'));

ncfile = fullfile(testroot,'testdata/enhanced.nc');
test_enhanced_group_and_var_have_same_name(ncfile);

v = version('-release');
switch(v)
    case {'14','2006a','2006b','2007a','2007b','2008a','2008b','2009a',...
            '2009b','2010a','2010b','2011a'};
        fprintf('\tfiltering out enhanced-model datatype tests on %s.\n', v);
        return;

end

% Strings
ncfile = fullfile(testroot,'testdata/moons.nc');
test_enhanced_vara_strings(ncfile);

% Enums
ncfile = fullfile(testroot,'testdata/tst_enum_data.nc');
test_1D_enum_var(ncfile);
test_1D_enum_vara(ncfile);
test_1D_enum_vars(ncfile);

% VLens
ncfile = fullfile(testroot,'testdata/tst_vlen_data.nc');
test_1D_vlen_var(ncfile);
test_1D_vlen_vara(ncfile);
test_1D_vlen_vars(ncfile);

% Opaques
ncfile = fullfile(testroot,'testdata/tst_opaque_data.nc');
test_1D_opaque_var(ncfile);
test_1D_opaque_vara(ncfile);
test_1D_opaque_vars(ncfile);

% Compounds
ncfile = fullfile(testroot,'testdata/tst_comp.nc');
test_1D_cmpd_var(ncfile);
test_1D_cmpd_vara(ncfile);
test_1D_cmpd_vars(ncfile);


%--------------------------------------------------------------------------
function test_1D_cmpd_vara(ncfile)

act_data = nc_varget(ncfile,'obs',1,2);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = struct(...
    'day', int8([-99 20]'), ...
    'elev', int16([-99 6]'), ...
    'count', int32([  -99 3]'), ...
    'relhum', single([ -99 0.75]'), ...
    'time', [ -99 5000.01]', ...
    'category', uint8([ 255 200]'), ...
    'id', uint16([65535 64000]'), ...
    'particularity', uint32([ 4294967295 4220002000]'), ...
    'attention_span', int64([ (intmin('int64')) + 2 9000000000000000000]'));
  
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_cmpd_vars(ncfile)

act_data = nc_varget(ncfile,'obs',0,2,2);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = struct(...
    'day', int8([15  20]'), ...
    'elev', int16([2  6]'), ...
    'count', int32([ 1  3]'), ...
    'relhum', single([0.5  0.75]'), ...
    'time', [3600.01  5000.01]', ...
    'category', uint8([0 200]'), ...
    'id', uint16([0 64000]'), ...
    'particularity', uint32([0 4220002000]'), ...
    'attention_span', int64([0 9000000000000000000]'));
  
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end


%--------------------------------------------------------------------------
function test_1D_cmpd_var(ncfile)

act_data = nc_varget(ncfile,'obs');

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = struct(...
    'day', int8([15 -99 20]'), ...
    'elev', int16([2 -99 6]'), ...
    'count', int32([ 1 -99 3]'), ...
    'relhum', single([0.5 -99 0.75]'), ...
    'time', [3600.01 -99 5000.01]', ...
    'category', uint8([0 255 200]'), ...
    'id', uint16([0 65535 64000]'), ...
    'particularity', uint32([0 4294967295 4220002000]'), ...
    'attention_span', int64([0 (intmin('int64')) + 2 9000000000000000000]'));
  
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end


%--------------------------------------------------------------------------
function test_1D_opaque_var(ncfile)

act_data = nc_varget(ncfile,'raw_obs');

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

v = (1:11)';                                        exp_data{1} = uint8(v);
v = [170 187 204 221 238 255 238 221 204 187 170]'; exp_data{2} = uint8(v);
v = 255*ones(11,1);                                 exp_data{3} = uint8(v);
v = [202 254 186 190 202 254 186 190 202 254 186]'; exp_data{4} = uint8(v);
v = [207 13 239 172 237 12 175 224 250 202 222]';   exp_data{5} = uint8(v);

if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_opaque_vara(ncfile)

act_data = nc_varget(ncfile,'raw_obs',1,3);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

v = (1:11)';                                        exp_data{1} = uint8(v);
v = [170 187 204 221 238 255 238 221 204 187 170]'; exp_data{2} = uint8(v);
v = 255*ones(11,1);                                 exp_data{3} = uint8(v);
v = [202 254 186 190 202 254 186 190 202 254 186]'; exp_data{4} = uint8(v);
v = [207 13 239 172 237 12 175 224 250 202 222]';   exp_data{5} = uint8(v);

exp_data = exp_data(2:4);
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_opaque_vars(ncfile)

act_data = nc_varget(ncfile,'raw_obs',0,3,2);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

v = (1:11)';                                        exp_data{1} = uint8(v);
v = [170 187 204 221 238 255 238 221 204 187 170]'; exp_data{2} = uint8(v);
v = 255*ones(11,1);                                 exp_data{3} = uint8(v);
v = [202 254 186 190 202 254 186 190 202 254 186]'; exp_data{4} = uint8(v);
v = [207 13 239 172 237 12 175 224 250 202 222]';   exp_data{5} = uint8(v);

exp_data = exp_data(1:2:5);
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_vlen_vara(ncfile)

act_data = nc_varget(ncfile,'ragged_array',1,3);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = { single(20:23)' single(30:32)' single(40:41)' };
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end
%--------------------------------------------------------------------------
function test_1D_vlen_var(ncfile)

act_data = nc_varget(ncfile,'ragged_array');

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = { single(10:14)' single(20:23)' single(30:32)' single(40:41)' single(-999)};
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_vlen_vars(ncfile)

act_data = nc_varget(ncfile,'ragged_array',0,3,2);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');

exp_data = { single(10:14)' single(30:32)' single(-999)};
if pfd
    exp_data =exp_data';
end

if ~isequal(act_data,exp_data)
    error('failed');
end
%--------------------------------------------------------------------------
function test_1D_enum_vars(ncfile)

act_data = nc_varget(ncfile,'primary_cloud',0,3,2);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');
if pfd
    exp_data = { 'Clear', 'Clear', 'Missing' }';
else
    exp_data = { 'Clear', 'Clear', 'Missing' };
end

if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_enum_var(ncfile)

act_data = nc_varget(ncfile,'primary_cloud');
pfd = getpref('SNCTOOLS','PRESERVE_FVD');
if pfd
    exp_data = { 'Clear', 'Stratus', 'Clear', 'Cumulonimbus', 'Missing' }';
else
    exp_data = { 'Clear', 'Stratus', 'Clear', 'Cumulonimbus', 'Missing' };
end
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_1D_enum_vara(ncfile)

act_data = nc_varget(ncfile,'primary_cloud',1,3);

pfd = getpref('SNCTOOLS','PRESERVE_FVD');
if pfd
    exp_data = { 'Stratus', 'Clear', 'Cumulonimbus' }';
else
    exp_data = { 'Stratus', 'Clear', 'Cumulonimbus' };
end
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_enhanced_vara_strings(ncfile)

varname = 'ourano';
exp_data = {'Puck'};
act_data = nc_varget(ncfile,varname,[0 0],[1 1]);
if ~isequal(act_data,exp_data)
    error('failed');
end

act_data = nc_varget(ncfile,varname,[0 0],[1 2]);
pfd = getpref('SNCTOOLS','PRESERVE_FVD');
if pfd
    exp_data = {'Puck','Umbriel'};
else
    exp_data = {'Puck','Miranda'};
end
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_enhanced_group_and_var_have_same_name(ncfile)

expData = (1:10)';
actData = nc_varget(ncfile,'/grp1/grp1');
ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.' );
end

%--------------------------------------------------------------------------
function test_bad_missing_value()

warning('off','SNCTOOLS:nc_varget:tmw:missingValueMismatch');
warning('off','SNCTOOLS:nc_varget:mexnc:missingValueMismatch');
warning('off','SNCTOOLS:nc_varget:java:missingValueMismatch');
nc_varget(['testdata' filesep 'badfillvalue.nc'],'z');
warning('on','SNCTOOLS:nc_varget:tmw:missingValueMismatch');
warning('on','SNCTOOLS:nc_varget:mexnc:missingValueMismatch');
warning('on','SNCTOOLS:nc_varget:java:missingValueMismatch');

%--------------------------------------------------------------------------
function test_bad_fill_value()

warning('off','SNCTOOLS:nc_varget:tmw:fillValueMismatch');
warning('off','SNCTOOLS:nc_varget:mexnc:fillValueMismatch');
warning('off','SNCTOOLS:nc_varget:java:fillValueMismatch');
nc_varget(['testdata' filesep 'badfillvalue.nc'],'y');
warning('on','SNCTOOLS:nc_varget:tmw:fillValueMismatch');
warning('on','SNCTOOLS:nc_varget:mexnc:fillValueMismatch');
warning('on','SNCTOOLS:nc_varget:java:fillValueMismatch');













%--------------------------------------------------------------------------
function test_1D_variable ( ncfile )
% Verify that a 1D variable read returns a column.

actData = nc_varget ( ncfile, 'test_1D' );

sz = size(actData);
if sz(1) ~= 6 && sz(2) ~= 1
    error('failed');
end




%--------------------------------------------------------------------------
function test_readSingleValueFrom1dVariable ( ncfile )

expData = 1.2;
actData = nc_varget ( ncfile, 'test_1D', 1, 1 );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.' );
end

return








%--------------------------------------------------------------------------
function test_readSingleValueFrom2dVariable ( ncfile )

expData = 1.5;
actData = nc_varget ( ncfile, 'test_2D', [2 2], [1 1] );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error('input data ~= output data.');
end

return




%--------------------------------------------------------------------------
function test_read2x2hyperslabFrom2dVariable ( ncfile )

expData = [1.5 2.1; 1.6 2.2];
if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end
actData = nc_varget ( ncfile, 'test_2D', [2 2], [2 2] );

if ndims(actData) ~= 2
    error ( 'rank of output data was not correct' );
end
if numel(actData) ~= 4
    error ( 'rank of output data was not correct' );
end
ddiff = abs(expData(:) - actData(:));
if any( find(ddiff > eps) )
    error ( 'input data ~= output data ' );
end

return






%--------------------------------------------------------------------------
function test_stride_with_negative_count ( ncfile )

expData = [0.1 1.3; 0.3 1.5; 0.5 1.7];

if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end
actData = nc_varget(ncfile,'test_2D',[0 0],[-1 -1],[2 2] );

if ndims(actData) ~= 2
    error ( 'rank of output data was not correct' );
end
if numel(actData) ~= 6
    error ( 'count of output data was not correct' );
end
ddiff = abs(expData(:) - actData(:));
if any( find(ddiff > eps) )
    error ( 'input data ~= output data ' );
end

return







%--------------------------------------------------------------------------
function test_inf_count ( ncfile )
% If the count has Inf anywhere, treat that as meaning to "retrieve unto
% the end of the file.

expData = [0.1 1.3; 0.3 1.5; 0.5 1.7];

if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end
actData = nc_varget(ncfile,'test_2D',[0 0],[Inf Inf],[2 2] );

if ndims(actData) ~= 2
    error ( 'rank of output data was not correct' );
end
if numel(actData) ~= 6
    error ( 'count of output data was not correct' );
end
ddiff = abs(expData(:) - actData(:));
if any( find(ddiff > eps) )
    error ( 'input data ~= output data ' );
end

return







%--------------------------------------------------------------------
function test_readFullSingletonVariable ( ncfile )


expData = 3.14159;
actData = nc_varget ( ncfile, 'test_singleton' );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.\n'  );
end

return



%--------------------------------------------------------------------------
function test_readFullDoublePrecisionVariable ( ncfile )


expData = 1:24;
expData = reshape(expData,6,4) / 10;

if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end

actData = nc_varget ( ncfile, 'test_2D' );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.\n'  );
end

return




%--------------------------------------------------------------------------
function test_readStridedVariable ( ncfile )

expData = 1:24;
expData = reshape(expData,6,4) / 10;
expData = expData(1:2:3,1:2:3);
if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end

actData = nc_varget ( ncfile, 'test_2D', [0 0], [2 2], [2 2] );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.\n'  );
end

return





%--------------------------------------------------------------------------
function regression_NegSize ( ncfile )
% A negative size means to retrieve to the end along the given dimension.
expData = 1:24;
expData = reshape(expData,6,4) / 10;
sz = size(expData);
sz(2) = -1;
if getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
    sz = fliplr(sz);
end

actData = nc_varget ( ncfile, 'test_2D', [0 0], sz );

ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.\n'  );
end

return


%--------------------------------------------------------------------------
function test_missing_value(ncfile)
% The last value should be nan.

actData = nc_varget ( ncfile, 'sst_mv' );

if ~isa(actData,'double')
    error ( 'short data was not converted to double');
end

if ~isnan( actData(end) )
    error ( 'missing value not converted to nan.\n'  );
end

return

%--------------------------------------------------------------------------
function test_missing_value_nan(ncfile)
% Special case where the missing value is NaN itself.

actData = nc_varget ( ncfile, 'a' );

if ~isa(actData,'double')
    error ( 'float data was not converted to double');
end

if ~isnan( actData(end) )
    error ( 'missing value not returned as NaN' );
end

return

%--------------------------------------------------------------------------
function test_fill_value_nan_extend(ncfile)
% Special case where the fill value is NaN itself (on time series).

v = version('-release');
switch(v)
    case {'14','2006a','2006b','2007a','2007b','2008a','2008b','2009a','2009b','2010a'}
        % cannot run on these releases without further modification.
        return
    otherwise
        % go ahead
end

delete('foo.nc');
copyfile(ncfile,'foo.nc');
ncfile = 'foo.nc';

info = nc_info(ncfile);

nc_adddim(ncfile,'time',0);

clear v;
if ~strcmp(info.Format,'HDF4')
    v.Name = 'time';
    v.Datatype = 'double';
    v.Dimension = { 'time' };
    nc_addvar ( ncfile, v );
end

clear v;

v.Name = 'time2';
v.Datatype = 'double';
v.Dimension = { 'time' };
v.Attribute.Name = '_FillValue';
v.Attribute.Value = NaN;
nc_addvar ( ncfile, v );

% Now extend the time variable
nc_varput(ncfile,'time',0);

% Now retrieve 'time2'.  The only value should be NaN
data = nc_varget(ncfile,'time2');
if ~isnan(data)
    error ( 'extended data not set with proper fill value');
end


%--------------------------------------------------------------------------
function test_fill_value_nan(ncfile)
% Special case where the fill value is NaN itself.

actData = nc_varget ( ncfile, 'b' );

if ~isa(actData,'double')
    error ( 'float data was not converted to double');
end

if ~isnan( actData(end) )
    error ( 'fill value not returned as NaN' );
end

return

%--------------------------------------------------------------------------
function test_scaling ( ncfile )

expData = [32 32 32 32; 50 50 50 50; 68 68 68 68; ...
           86 86 86 86; 104 104 104 104; 122 122 122 122]';

if ~getpref('SNCTOOLS','PRESERVE_FVD',false)
    expData = expData';
end
    
actData = nc_varget ( ncfile, 'temp' );

if ~isa(actData,'double')
    error ( 'short data was not converted to double');
end
ddiff = abs(expData - actData);
if any( find(ddiff > eps) )
    error ( 'input data ~= output data.\n'  );
end

return




%--------------------------------------------------------------------------
function run_grib2_tests()


testroot = fileparts(mfilename('fullpath'));
gribfile = fullfile(testroot,'testdata',...
    'ecmf_20070122_pf_regular_ll_pt_320_pv_grid_simple.grib2');
test_readFullDouble(gribfile);

return

%--------------------------------------------------------------------------
function test_readFullDouble(gribfile)
actData = nc_varget(gribfile,'lon');
expData = 10*(0:35)';
if actData ~= expData
    error('failed');
end
return










%--------------------------------------------------------------------------
function run_hdf_tests()

test_hdf4_example;
test_hdf4_scaling;

%--------------------------------------------------------------------------
function test_hdf4_example()
% test the example file that ships with matlab
exp_data = hdfread('example.hdf','Example SDS');
act_data = nc_varget('example.hdf','Example SDS');

if getpref('SNCTOOLS','PRESERVE_FVD',false)
    act_data = act_data';
end

if exp_data ~= act_data
    error('failed');
end


%--------------------------------------------------------------------------
function test_hdf4_scaling()
testroot = fileparts(mfilename('fullpath'));

oldpref = getpref('SNCTOOLS','USE_STD_HDF4_SCALING',false);

hdffile = fullfile(testroot,'testdata','temppres.hdf');

setpref('SNCTOOLS','USE_STD_HDF4_SCALING',true);
act_data = nc_varget(hdffile,'temp',[0 0],[2 2]);
exp_data = 1.8*([32 32; 33 33] - 32);

if ~getpref('SNCTOOLS','PRESERVE_FVD',false)
    act_data = act_data';
end

if exp_data ~= act_data
    error('failed');
end


setpref('SNCTOOLS','USE_STD_HDF4_SCALING',false);
act_data = nc_varget(hdffile,'temp',[0 0],[2 2]);
exp_data = 1.8*[32 32; 33 33] + 32;

if ~getpref('SNCTOOLS','PRESERVE_FVD',false)
    act_data = act_data';
end

if exp_data ~= act_data
    error('failed');
end


setpref('SNCTOOLS','USE_STD_HDF4_SCALING',oldpref);




%--------------------------------------------------------------------------
function run_local_tests(ncfile)

test_1D_variable ( ncfile );
test_readSingleValueFrom1dVariable ( ncfile );
test_readSingleValueFrom2dVariable ( ncfile );
test_read2x2hyperslabFrom2dVariable ( ncfile );
test_stride_with_negative_count ( ncfile );
test_inf_count ( ncfile );

test_readFullSingletonVariable ( ncfile );
test_readFullDoublePrecisionVariable ( ncfile );

test_readStridedVariable ( ncfile );
test_scaling(ncfile);
test_missing_value(ncfile);
test_missing_value_nan(ncfile);
test_fill_value_nan(ncfile);
test_fill_value_nan_extend(ncfile);

regression_NegSize(ncfile);

test_bad_fill_value;
test_bad_missing_value;

v = version('-release');
switch(v)
    case {'14','2006a','2006b','2007a','2007b'}
        %
    otherwise
        test_nc_varget_neg(ncfile);
end
            

return








%--------------------------------------------------------------------------
function run_opendap_tests()

test_readOpendapVariable;

v = version('-release');
switch(v)
    case {'14','2006a','2006b','2007a'}
        fprintf('negative tests filtered out on release %s.', v);
    otherwise
        test_nc_varget_neg_opendap;
end
return















%--------------------------------------------------------------------------
function test_readOpendapVariable ()
    % use data of today as the server has a clean up policy
    today = datestr(floor(now),'yyyymmdd');
    url = ['http://motherlode.ucar.edu:8080/thredds/dodsC/satellite/CTP/SUPER-NATIONAL_1km/current/SUPER-NATIONAL_1km_CTP_',today,'_0000.gini'];
    
    % I have no control over what this value is, so we'll just assume it
    % is correct.
    nc_varget(url,'y',0,1);
return



