function fileinfo = nc_info_tmw ( ncfile )
% NC_INFO Backend for Mathworks package.

ncid=netcdf.open(ncfile, nc_nowrite_mode );

fileinfo = get_group_info_tmw(ncid);

v = netcdf.inqLibVers;
if v(1) == '4'
    switch(netcdf.inqFormat(ncid))
        case 'FORMAT_CLASSIC'
            fileinfo.Format = 'NetCDF-3 Classic';
        case 'FORMAT_64BIT'
            fileinfo.Format = 'NetCDF-3 64bit';
        case 'FORMAT_NETCDF4_CLASSIC'
            fileinfo.Format = 'NetCDF-4 Classic';
        case 'FORMAT_NETCDF4'
            fileinfo.Format = 'NetCDF-4';
    end
else
    % On earlier versions of the library, we just assume "NetCDF".
    fileinfo.Format = 'NetCDF';
end

netcdf.close(ncid);

fileinfo = pp_fileinfo(ncfile,fileinfo);

fileinfo.Filename = ncfile;

%--------------------------------------------------------------------------
function info = pp_fileinfo(ncfile,info)

if ~strcmp(info.Format,'NetCDF-4')
    % No point if not the enhanced format.
    return
end
v = version('-release');
switch(v)
    case {'2008b','2009a','2009b','2010a','2010b'}
        % No post-processing done on these releases.
        return
    otherwise
        hinfo = h5info(ncfile);
        info = pp_groupinfo(info,hinfo);
end

%--------------------------------------------------------------------------
function nc_ginfo = pp_groupinfo(nc_ginfo, h5_ginfo)

if ~isempty(h5_ginfo.Datatypes)
    nc_ginfo.Datatype = pp_datatype_info(h5_ginfo.Datatypes);
end

% Any datasets with an empty 'Datatype field?
for j = 1:numel(nc_ginfo.Dataset)
    if isempty(nc_ginfo.Dataset(j).Datatype)
        nc_ginfo.Dataset(j) = pp_varinfo(nc_ginfo.Dataset(j), h5_ginfo);
    end            
end

% Group attributes.
for j = 1:numel(nc_ginfo.Attribute)
    if isempty(nc_ginfo.Attribute(j).Datatype)
        nc_ginfo.Attribute(j) = pp_attrinfo(nc_ginfo.Attribute(j), h5_ginfo);
    end
end

% Groups.
for j = 1:numel(nc_ginfo.Group)
    for k = 1:numel(h5_ginfo.Groups)
        %[~,relname] = fileparts(h5_ginfo.Groups(k).Name);
        if strcmp(nc_ginfo.Group(j).Name,h5_ginfo.Groups(k).Name)
            nc_ginfo.Group(j) = pp_groupinfo(nc_ginfo.Group(j), h5_ginfo.Groups(k));
        end
    end
end

%--------------------------------------------------------------------------
function info = pp_datatype_info(h5dtinfo)


info = struct('Name','','Class','','Type',[],'Size',0);
info = repmat(info,numel(h5dtinfo),1);
for j = 1:numel(h5dtinfo)
    switch(h5dtinfo(j).Class)
        case 'H5T_ENUM'
            info(j) = pp_h5enum_datatype(h5dtinfo(j));
        case 'H5T_OPAQUE'
            info(j) = pp_h5opaque_datatype(h5dtinfo(j));
        case 'H5T_VLEN'
            info(j) = pp_h5vlen_datatype(h5dtinfo(j));
        case 'H5T_COMPOUND'
            info(j) = pp_h5compound_datatype(h5dtinfo(j));
        otherwise
            warning('snctools:unhandledHDF5class', ...
                    'HDF5 attribute class %s not handled, skipping...', ...
                    h5dtinfo(j).Class);
    end
            
end

%--------------------------------------------------------------------------
function ncinfo = pp_h5compound_datatype(h5info)
% Turn an HDF5 H5T_COMPOUND datatype into a netcdf-centric info struct.

ncinfo = struct('Name','','Class','compound','Type',[],'Size',h5info.Size);

[filepath,name] = fileparts(h5info.Name);
ncinfo.Name = name;

for j = 1:numel(h5info.Type.Member)
    ncinfo.Type.Member(j) = pp_h5_compound_member(h5info.Type.Member(j));
end

%--------------------------------------------------------------------------
function ncinfo = pp_h5opaque_datatype(h5info)
% Turn an HDF5 H5T_OPAQUE datatype into a netcdf-centric info struct.

ncinfo = struct('Name','','Class','opaque','Type',[],'Size',h5info.Size);

[filepath,name] = fileparts(h5info.Name);
ncinfo.Name = name;


%--------------------------------------------------------------------------
function ncinfo = pp_h5_compound_member(h5info)

ncinfo = struct('Name',h5info.Name, ...
    'Datatype',[]);

ncinfo.Datatype = struct('Name','', ...
    'Type','', ...
    'Size', h5info.Datatype.Size);

if ischar(h5info.Datatype.Type)
    switch(h5info.Datatype.Type)
        case {'H5T_STD_U8LE','H5T_STD_U8BE'}
            ncinfo.Datatype.Type = 'uint8';
        case {'H5T_STD_U16LE','H5T_STD_U16BE'}
            ncinfo.Datatype.Type = 'uint16';
        case {'H5T_STD_U32LE','H5T_STD_U32BE'}
            ncinfo.Datatype.Type = 'uint32';
        case {'H5T_STD_U64LE','H5T_STD_U64BE'}
            ncinfo.Datatype.Type = 'uint64';
        case {'H5T_STD_I8LE','H5T_STD_I8BE'}
            ncinfo.Datatype.Type = 'int8';
        case {'H5T_STD_I16LE','H5T_STD_I16BE'}
            ncinfo.Datatype.Type = 'int16';
        case {'H5T_STD_I32LE','H5T_STD_I32BE'}
            ncinfo.Datatype.Type = 'int32';
        case {'H5T_STD_I64LE','H5T_STD_I64BE'}
            ncinfo.Datatype.Type = 'int64';
        case {'H5T_IEEE_F32LE','H5T_IEEE_F32BE'}
            ncinfo.Datatype.Type = 'single';
        case {'H5T_IEEE_F64LE','H5T_IEEE_F64BE'}
            ncinfo.Datatype.Type = 'double';
        otherwise
            error('not handled');
    end
elseif isstruct(h5info.Datatype) && strcmp(h5info.Datatype.Class,'H5T_STRING')
    ncinfo.Datatype.Type = 'string';
else
    warning('not handled');
end


%--------------------------------------------------------------------------
function ncinfo = pp_h5vlen_datatype(h5info)
% Turn an HDF5 H5T_VLEN datatype into a netcdf-centric info struct.

ncinfo = struct('Name','','Class','vlen','Type',[],'Size',h5info.Size);

[filepath,name] = fileparts(h5info.Name);
ncinfo.Name = name;

switch(h5info.Type.Type)
    case {'H5T_STD_U8LE','H5T_STD_U8BE'}
        ncinfo.Type.Type = 'uint8';
    case {'H5T_STD_U16LE','H5T_STD_U16BE'}
        ncinfo.Type.Type = 'uint16';
    case {'H5T_STD_U32LE','H5T_STD_U32BE'}
        ncinfo.Type.Type = 'uint32';
    case {'H5T_STD_U64LE','H5T_STD_U64BE'}
        ncinfo.Type.Type = 'uint64';
    case {'H5T_STD_I8LE','H5T_STD_I8BE'}
        ncinfo.Type.Type = 'int8';
    case {'H5T_STD_I16LE','H5T_STD_I16BE'}
        ncinfo.Type.Type = 'int16';
    case {'H5T_STD_I32LE','H5T_STD_I32BE'}
        ncinfo.Type.Type = 'int32';
    case {'H5T_STD_I64LE','H5T_STD_I64BE'}
        ncinfo.Type.Type = 'int64';    
    case {'H5T_IEEE_F32LE','H5T_IEEE_F32BE'}
        ncinfo.Type.Type = 'single'; 
    case {'H5T_IEEE_F64LE','H5T_IEEE_F64BE'}
        ncinfo.Type.Type = 'double'; 
    otherwise
        error('not handled');
end
ncinfo.Type.Size = h5info.Type.Size;
%--------------------------------------------------------------------------
function ncinfo = pp_h5enum_datatype(h5info)
% Turn an HDF5 H5T_ENUM datatype into a netcdf-centric info struct.

ncinfo = struct('Name','','Class','enum','Type',[],'Size',h5info.Size);

[filepath,name] = fileparts(h5info.Name);
ncinfo.Name = name;

switch(h5info.Type.Type)
    case {'H5T_STD_U8LE','H5T_STD_U8BE'}
        ncinfo.Type.Type = 'uint8';
    case {'H5T_STD_U16LE','H5T_STD_U16BE'}
        ncinfo.Type.Type = 'uint16';
    case {'H5T_STD_U32LE','H5T_STD_U32BE'}
        ncinfo.Type.Type = 'uint32';
    case {'H5T_STD_U64LE','H5T_STD_U64BE'}
        ncinfo.Type.Type = 'uint64';
    case {'H5T_STD_I8LE','H5T_STD_I8BE'}
        ncinfo.Type.Type = 'int8';
    case {'H5T_STD_I16LE','H5T_STD_I16BE'}
        ncinfo.Type.Type = 'int16';
    case {'H5T_STD_I32LE','H5T_STD_I32BE'}
        ncinfo.Type.Type = 'int32';
    case {'H5T_STD_I64LE','H5T_STD_I64BE'}
        ncinfo.Type.Type = 'int64';        
    otherwise
        error('not handled');
end
ncinfo.Type.Member = h5info.Type.Member;


%--------------------------------------------------------------------------
function ainfo = pp_attrinfo(ainfo, h5ginfo)

idx = strcmp(ainfo.Name,{h5ginfo.Attributes.Name});
switch(h5ginfo.Attributes(idx).Datatype.Class)
    case 'H5T_STRING'
        ainfo.Datatype = 'string';
        ainfo.Value = h5ginfo.Attributes(idx).Value;
    case 'H5T_ENUM'
        [dud,name] = fileparts(h5ginfo.Attributes(idx).Datatype.Name);
        ainfo.Datatype = ['enum ' name];
        ainfo.Value = h5ginfo.Attributes(idx).Value;
    case 'H5T_OPAQUE'
        [dud,name] = fileparts(h5ginfo.Attributes(idx).Datatype.Name);
        ainfo.Datatype = ['opaque ' name];
        ainfo.Value = h5ginfo.Attributes(idx).Value;
    case 'H5T_VLEN'
        [dud,name] = fileparts(h5ginfo.Attributes(idx).Datatype.Name);
        ainfo.Datatype = ['vlen ' name];
        ainfo.Value = h5ginfo.Attributes(idx).Value;
    case 'H5T_COMPOUND'
        [dud,name] = fileparts(h5ginfo.Attributes(idx).Datatype.Name);
        ainfo.Datatype = ['compound ' name];
        ainfo.Value = h5ginfo.Attributes(idx).Value;
    otherwise
        error('snctools:unhandledHDF5datatype', ...
            'Unhandled HDF5 datatype ''%s''.', ...
            h5ginfo.Attributes(idx).Datatype.Class);
end

%--------------------------------------------------------------------------
function nc_varinfo = pp_varinfo(nc_varinfo,h5_ginfo)

idx = find(strcmp(nc_varinfo.Name,{h5_ginfo.Datasets.Name}));
nc_varinfo.Datatype = pp_datatype(h5_ginfo.Datasets(idx).Datatype);

% Variable attributes.
for j = 1:numel(nc_varinfo.Attribute)
    if isempty(nc_varinfo.Attribute(j).Datatype)
        nc_varinfo.Attribute(j) = pp_attrinfo(nc_varinfo.Attribute(j), ...
            h5_ginfo.Datasets(idx));
    end
end


%--------------------------------------------------------------------------
function datatype = pp_datatype(h5type)

switch(h5type.Class)
    case 'H5T_STRING'
        datatype = 'string';
    case 'H5T_ENUM'
        [dud,name] = fileparts(h5type.Name);
        datatype = ['enum ' name];
    case 'H5T_OPAQUE'
        [dud,name] = fileparts(h5type.Name);
        datatype = ['opaque ' name];
    case 'H5T_VLEN'
        [dud,name] = fileparts(h5type.Name);
        datatype = ['vlen ' name];
    case 'H5T_COMPOUND'
        [dud,name] = fileparts(h5type.Name);
        datatype = ['compound ' name];
    otherwise
        warning('snctools:unhandledHDF5datatype', ...
            'Unhandled HDF5 datatype ''%s''.', h5type.Class);
        datatype = '';
end

%--------------------------------------------------------------------------
function info = get_group_info_tmw(ncid)

info = struct('Name','','Datatype',[],'Attribute',[],'Dimension',[],'Dataset',[],'Group',[]);
[ndims, nvars, ngatts] = netcdf.inq(ncid);

v = netcdf.inqLibVers;
if v(1) == '3'
    dimids = 0:ndims-1;
    info.Name = '/';
else
    dimids = netcdf.inqDimIDs(ncid);
    info.Name = netcdf.inqGrpNameFull(ncid);
end

% Get the dimensions
if ndims == 0
	Dimension = struct ( [] );
else
    Dimension = struct('Name','','Length',[],'Unlimited',false);
    Dimension = repmat(Dimension,ndims,1);
	for j = 1:ndims
		Dimension(j)=nc_getdiminfo_tmw(ncid,dimids(j));
	end
end



% Get the global attributes.
if ngatts == 0
	info.Attribute = struct([]);
else
    Attribute = struct('Name','','Nctype','','Datatype','','Value',NaN);
	for attnum = 0:ngatts-1
		Attribute(attnum+1) = nc_getattsinfo_tmw(ncid,nc_global,attnum);
	end
	info.Attribute = Attribute;
end


% Get the variable information.
if nvars == 0
	Dataset = struct([]);
else
    Attribute = struct('Name','','Nctype','','Datatype','','Value',NaN);
    Dataset = struct('Name','','Nctype','','Datatype','','Unlimited',false,'Dimension',{''},'Size',[],'Attribute',Attribute,'Chunking',[],'Shuffle',[],'Deflate',[]);
	Dataset = repmat ( Dataset, nvars, 1 );
	for varid=0:nvars-1
		Dataset(varid+1) = nc_getvarinfo_tmw(ncid,varid);
	end
end

info.Dimension = Dimension;
info.Dataset = Dataset;

Group = [];
if v(1) == '4'
    % Any groups?
    fmt = netcdf.inqFormat(ncid);
    if strcmp(fmt,'FORMAT_NETCDF4')
        childGroups = netcdf.inqGrps(ncid);
        if numel(childGroups) > 0
            Group = get_group_info_tmw(childGroups(1));
            Group = repmat(Group, numel(childGroups),1);
            for j = 2:numel(childGroups)
                Group(j) = get_group_info_tmw(childGroups(j));
            end
        end
    end
else
end
info.Group = Group;


return
