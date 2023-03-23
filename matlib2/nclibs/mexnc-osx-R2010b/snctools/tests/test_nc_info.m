function test_nc_info(mode)

if nargin < 1
	mode = 'nc-3';
end

fprintf('\t\tTesting NC_INFO ...  ' );

run_negative_tests;

switch(mode)
	case 'nc-3'
		run_nc3_tests;
	case 'netcdf4-classic'
		run_nc4_tests;
	case 'netcdf4-enhanced'
		run_nc4_enhanced_tests;
	case 'http'
		run_http_tests;
	case 'opendap'
		run_opendap_tests;
end

fprintf('OK\n');

return


%--------------------------------------------------------------------------
function run_negative_tests()

test_no_inputs;
test_too_many_inputs;
test_file_not_netcdf;




%--------------------------------------------------------------------------
function run_nc4_enhanced_tests()

testroot = fileparts(mfilename('fullpath'));

v = version('-release');
switch(v)
    case {'14','2006a','2006b','2007a','2007b','2008a','2008b','2009a',...
            '2009b','2010a','2010b','2011a'};
        fprintf('\tfiltering out enhanced-model datatype tests on %s.\n', v);
        return;

end

% Strings
ncfile = [testroot '/testdata/moons.nc'];
test_string_variable(ncfile);
test_global_string_attribute(ncfile);
test_empty_string_attribute(ncfile);

% Enums
ncfile = [testroot '/testdata/tst_enum_data.nc'];
test_root_group_ubyte_enum(ncfile);

% Vlens
ncfile = [testroot '/testdata/tst_vlen_data.nc'];
test_root_group_float_vlen(ncfile);

% Opaques
ncfile = [testroot '/testdata/tst_opaque_data.nc'];
test_root_group_opaque(ncfile);

% Compounds
ncfile = [testroot '/testdata/tst_comp.nc'];
test_root_group_compound(ncfile);

ncfile = [testroot '/testdata/obs_cmpd_strings.nc'];
test_root_group_compound_with_strings(ncfile);

%--------------------------------------------------------------------------
function test_root_group_compound_with_strings(ncfile)

info = nc_info(ncfile);

act_data = info.Datatype(1);

exp_data = struct('Name','observation_att', ...
    'Class','compound', ...
    'Type',[], ...
    'Size',32);
dt(1) = struct('Name', 'time', 'Datatype', []);
dt(1).Datatype = struct('Name','','Type','string','Size',8);
dt(2) = struct('Name', 'tempMean', 'Datatype', []);
dt(2).Datatype = struct('Name','','Type','string','Size',8);
dt(3) = struct('Name', 'tempMin', 'Datatype', []);
dt(3).Datatype = struct('Name','','Type','string','Size',8);
dt(4) = struct('Name', 'tempMax', 'Datatype', []);
dt(4).Datatype = struct('Name','','Type','string','Size',8);
exp_data.Type.Member = dt;

if ~isequal(act_data,exp_data);
    error('failed');
end

%--------------------------------------------------------------------------
function test_root_group_compound(ncfile)

info = nc_info(ncfile);

act_data = info.Datatype;

exp_data = struct('Name','obs_t', ...
    'Class','compound', ...
    'Type',[], ...
    'Size',36);
dt(1) = struct('Name', 'day', 'Datatype', []);
dt(1).Datatype = struct('Name','','Type','int8','Size',1);
dt(2) = struct('Name', 'elev', 'Datatype', []);
dt(2).Datatype = struct('Name','','Type','int16','Size',2);
dt(3) = struct('Name', 'count', 'Datatype', []);
dt(3).Datatype = struct('Name','','Type','int32','Size',4);
dt(4) = struct('Name', 'relhum', 'Datatype', []);
dt(4).Datatype = struct('Name','','Type','single','Size',4);
dt(5) = struct('Name', 'time', 'Datatype', []);
dt(5).Datatype = struct('Name','','Type','double','Size',8);
dt(6) = struct('Name', 'category', 'Datatype', []);
dt(6).Datatype = struct('Name','','Type','uint8','Size',1);
dt(7) = struct('Name', 'id', 'Datatype', []);
dt(7).Datatype = struct('Name','','Type','uint16','Size',2);
dt(8) = struct('Name', 'particularity', 'Datatype', []);
dt(8).Datatype = struct('Name','','Type','uint32','Size',4);
dt(9) = struct('Name', 'attention_span', 'Datatype', []);
dt(9).Datatype = struct('Name','','Type','int64','Size',8);

exp_data.Type.Member = dt;

if ~isequal(act_data,exp_data);
    error('failed');
end

act_data = info.Dataset;
act_data.Nctype = [];
act_data.Attribute.Nctype = [];

exp_data = struct('Name','obs', ...
    'Nctype',[], ...
    'Datatype','compound obs_t', ...
    'Unlimited',0, ...
    'Dimension',[], ...
    'Size',3, ...
    'Attribute', [], ...
    'Chunking',[], ...
    'Shuffle',0, ...
    'Deflate',0);
exp_data.Dimension = {'n'};
exp_data.Attribute = struct('Name','_FillValue', ...
    'Nctype',[], ...
    'Datatype', 'compound obs_t', ...
    'Value',[]);
exp_data.Attribute.Value = struct(...
    'day', int8(-99), ...
    'elev', int16(-99), ...
    'count', int32(-99), ...
    'relhum', single(-99), ...
    'time', -99, ...
    'category', uint8(255), ...
    'id', uint16(2^16-1), ...
    'particularity', uint32(4294967295), ...
    'attention_span', int64(-9223372036854775806));

if ~isequal(act_data,exp_data);
    error('failed');
end


%--------------------------------------------------------------------------
function test_root_group_opaque(ncfile)

info = nc_info(ncfile);

act_data = info.Datatype;

exp_data = struct('Name','raw_obs_t', ...
    'Class','opaque', ...
    'Type',[], ...
    'Size',11);
if ~isequal(act_data,exp_data);
    error('failed');
end

act_data = info.Dataset;
act_data.Nctype = [];
act_data.Attribute.Nctype = [];

exp_data = struct('Name','raw_obs', ...
    'Nctype',[], ...
    'Datatype','opaque raw_obs_t', ...
    'Unlimited',0, ...
    'Dimension',[], ...
    'Size',5, ...
    'Attribute', [], ...
    'Chunking',[], ...
    'Shuffle',0, ...
    'Deflate',0);
exp_data.Dimension = {'time'};
exp_data.Attribute = struct('Name','_FillValue', ...
    'Nctype',[], ...
    'Datatype', 'opaque raw_obs_t', ...
    'Value',[]);
exp_data.Attribute.Value = {uint8([202 254 186 190 202 254 186 190 202 254 186]')};
if ~isequal(act_data,exp_data);
    error('failed');
end


%--------------------------------------------------------------------------
function test_root_group_float_vlen(ncfile)

info = nc_info(ncfile);

act_data = info.Datatype;

exp_data = struct('Name','row_of_floats', ...
    'Class','vlen', ...
    'Type',[], ...
    'Size',16);
exp_data.Type = struct('Type','single','Size',4);
if ~isequal(act_data,exp_data);
    error('failed');
end

act_data = info.Dataset;
act_data.Nctype = [];
act_data.Attribute.Nctype = [];

exp_data = struct('Name','ragged_array', ...
    'Nctype',[], ...
    'Datatype','vlen row_of_floats', ...
    'Unlimited',0, ...
    'Dimension',[], ...
    'Size',5, ...
    'Attribute', [], ...
    'Chunking',[], ...
    'Shuffle',0, ...
    'Deflate',0);
exp_data.Dimension = {'m'};
exp_data.Attribute = struct('Name','_FillValue', ...
    'Nctype',[], ...
    'Datatype', 'vlen row_of_floats', ...
    'Value',[]);
exp_data.Attribute.Value = {single(-999)};
if ~isequal(act_data,exp_data);
    error('failed');
end

%--------------------------------------------------------------------------
function test_root_group_ubyte_enum(ncfile)

info = nc_info(ncfile);

exp_data = struct('Name','cloud_class_t', ...
    'Class','enum', ...
    'Type',[], ...
    'Size',1);
exp_data.Type = struct('Type','uint8', 'Member',struct([]));
Member(1) = struct('Name','Clear','Value',uint8(0));
Member(2) = struct('Name','Cumulonimbus','Value',uint8(1));
Member(3) = struct('Name','Stratus','Value',uint8(2));
Member(4) = struct('Name','Stratocumulus','Value',uint8(3));
Member(5) = struct('Name','Cumulus','Value',uint8(4));
Member(6) = struct('Name','Altostratus','Value',uint8(5));
Member(7) = struct('Name','Nimbostratus','Value',uint8(6));
Member(8) = struct('Name','Altocumulus','Value',uint8(7));
Member(9) = struct('Name','Cirrostratus','Value',uint8(8));
Member(10) = struct('Name','Cirrocumulus','Value',uint8(9));
Member(11) = struct('Name','Cirrus','Value',uint8(10));
Member(12) = struct('Name','Missing','Value',uint8(255));
exp_data.Type.Member = Member';

act_data = info.Datatype;
if ~isequal(act_data,exp_data)
    error('failed');
end

act_data = info.Dataset;
act_data.Nctype = [];     % This field changes without notice.
act_data.Attribute.Nctype = [];

exp_data = struct('Name','primary_cloud', ...
    'Nctype',[], ...
    'Datatype','enum cloud_class_t', ...
    'Unlimited',0,...
    'Dimension',[], ...
    'Size',5, ...
    'Attribute',[], ...
    'Chunking',[], ...
    'Shuffle',0, ...
    'Deflate',0);
exp_data.Dimension = {'station'};
ainfo = struct('Name','_FillValue', ...
    'Nctype',[], ...
    'Datatype','enum cloud_class_t', ...
    'Value', {'Missing'});
ainfo.Value = {'Missing'};
exp_data.Attribute = ainfo;
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_string_variable(ncfile)

info = nc_info(ncfile);
exp_data = struct('Name','ourano', ...
    'Nctype', 12, ...
    'Datatype', 'string', ...
    'Unlimited', 0, ...
    'Dimension', [], ...
    'Size', [2 3], ...
    'Attribute', [], ...
    'Chunking', [], ...
    'Shuffle', 0, ...
    'Deflate', 0 );
exp_data.Dimension = {'x' 'y'};
exp_data.Attribute = struct('Name','Bianca','Nctype',12,'Datatype','string', ...
    'Value',[]);
exp_data.Attribute.Value = {'Puck'; 'Miranda'};

pfvd = getpref('SNCTOOLS','PRESERVE_FVD');
if pfvd
    exp_data.Dimension = {'y' 'x'};
    exp_data.Size = [3 2];
end
act_data = info.Dataset(1);
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_global_string_attribute(ncfile)

info = nc_info(ncfile);
act_data = info.Attribute;
exp_data = struct('Name','others', ...
    'Nctype', 12, ...
    'Datatype', 'string', ...
	'Value', []);
exp_data.Value = {'Francisco', 'Caliban', 'Stephano', 'Trinculo', ...
        'Sycorax', 'Margaret', 'Prospero', 'Setebos', 'Ferdinand'}';
if ~isequal(act_data,exp_data)
    error('failed');
end

%--------------------------------------------------------------------------
function test_empty_string_attribute(ncfile)

info = nc_info(ncfile);
if ~isempty(info.Group.Dataset.Attribute(2).Value)
    error('failed');
end

%--------------------------------------------------------------------------
function run_nc4_tests()


testroot = fileparts(mfilename('fullpath'));

ncfile = [testroot '/testdata/empty-4.nc'];
test_emptyNetcdfFile(ncfile);

ncfile = [testroot '/testdata/just_one_dimension-4.nc'];
test_dimsButNoVars(ncfile);

ncfile = [testroot '/testdata/full-4.nc'];
test_smorgasborg(ncfile);

return




%--------------------------------------------------------------------------
function run_nc3_tests()


testroot = fileparts(mfilename('fullpath'));

ncfile = [testroot '/testdata/empty.nc'];
test_emptyNetcdfFile(ncfile);

ncfile = [testroot '/testdata/just_one_dimension.nc'];
test_dimsButNoVars(ncfile);

ncfile = [testroot '/testdata/varget.nc'];
test_char_attr(ncfile);

ncfile = [testroot '/testdata/full.nc'];
test_smorgasborg(ncfile);

return




%--------------------------------------------------------------------------
function test_char_attr(ncfile)

% Make sure that NC_CHAR attributes are actually chars, even when read by
% java.  The attribute tested is a history attribute.

info = nc_info(ncfile);
 
if isa(info.Attribute.Value,'cell')
    % java
    if ~ischar(info.Attribute.Value{1})
        error('failed');
    end
else
    % mex
    if ~ischar(info.Attribute.Value)
        error('failed');
    end
end



%--------------------------------------------------------------------------
function test_no_inputs( )
try
	nc_info;
catch %#ok<CTCH>
    return
end
error ( 'succeeded when it should have failed.\n'  );





%--------------------------------------------------------------------------
function test_too_many_inputs()

testroot = fileparts(mfilename('fullpath'));
ncfile = fullfile(testroot, 'testdata/empty.nc');
try
	nc_info ( ncfile, 'blah' );
catch %#ok<CTCH>
    return
end
error('succeeded when it should have failed.');





%--------------------------------------------------------------------------
function test_file_not_netcdf()
ncfile = mfilename;
try
	nc_info ( ncfile );
catch %#ok<CTCH>
    return
end
error ( 'succeeded when it should have failed.' );







%--------------------------------------------------------------------------
function test_emptyNetcdfFile(ncfile)

nc = nc_info ( ncfile );
if ~strcmp ( nc.Filename, ncfile )
	error( 'Filename was wrong.');
end
if ( ~isempty ( nc.Dimension ) )
	error( 'Dimension was wrong.');
end
if ( ~isempty ( nc.Dataset ) )
	error( 'Dataset was wrong.');
end
if ( ~isempty ( nc.Attribute ) )
	error('Attribute was wrong.');
end
return









%--------------------------------------------------------------------------
function test_dimsButNoVars(ncfile)

nc = nc_info ( ncfile );
if ~strcmp ( nc.Filename, ncfile )
	error( 'Filename was wrong.');
end
if ( length ( nc.Dimension ) ~= 1 )
	error( 'Dimension was wrong.');
end
if ( ~isempty ( nc.Dataset ) )
	error( 'Dataset was wrong.');
end
if ( ~isempty ( nc.Attribute ) )
	error( 'Attribute was wrong.');
end
return










%--------------------------------------------------------------------------
function test_smorgasborg(ncfile)

nc = nc_info ( ncfile );
if ~strcmp ( nc.Filename, ncfile )
	error( 'Filename was wrong.');
end
if ( length ( nc.Dimension ) ~= 5 )
	error( 'Dimension was wrong.');
end
if ( length ( nc.Dataset ) ~= 6 )
	error( 'Dataset was wrong.');
end
if ( length ( nc.Attribute ) ~= 1 )
	error( 'Attribute was wrong.');
end
return






%--------------------------------------------------------------------------
function run_opendap_tests()

run_motherlode_test;
%--------------------------------------------------------------------------
function run_motherlode_test (  )

if getpref('SNCTOOLS','TEST_REMOTE',false) && ...
        getpref ( 'SNCTOOLS', 'TEST_OPENDAP', false ) 
    
    load('testdata/nc_info.mat');
    % use data of today as the server has a clean up policy
    today = datestr(floor(now),'yyyymmdd');
    url = ['http://motherlode.ucar.edu:8080/thredds/dodsC/satellite/CTP/SUPER-NATIONAL_1km/current/SUPER-NATIONAL_1km_CTP_',today,'_0000.gini'];
	fprintf('\t\tTesting remote DODS access %s...  ', url );
    
    info = nc_info(url);

    
    % Reverse the order of the Dimension and Size fields if using row major
    % order.
    if getpref('SNCTOOLS','PRESERVE_FVD',false) == false
        for j = 1:numel(info.Dataset)
            info.Dataset(j).Size = fliplr(info.Dataset(j).Size);
            info.Dataset(j).Dimension = fliplr(info.Dataset(j).Dimension);
        end
    end
    
    if ~isequal(info.Dataset,d.opendap.motherlode.Dataset)
        error('failed');
    end
    fprintf('OK\n');
else
	fprintf('Not testing NC_DUMP on OPeNDAP URLs.  Read the README for details.\n');	
end
return





%--------------------------------------------------------------------------
function run_http_tests()

test_javaNcid;
return


%--------------------------------------------------------------------------
function test_javaNcid ()
import ucar.nc2.dods.*     
import ucar.nc2.*          

url = 'http://rocky.umeoce.maine.edu/GoMPOM/cdfs/gomoos.20070723.cdf';
jncid = NetcdfFile.open(url);
nc_info ( jncid );
close(jncid);
return



