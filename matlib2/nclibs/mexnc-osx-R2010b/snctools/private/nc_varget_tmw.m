function values = nc_varget_tmw(ncfile,varname,varargin)

ncid=netcdf.open(ncfile,'NOWRITE');

try
    values = varget(ncid,varname,varargin{:});
catch me
    netcdf.close(ncid);
    switch(me.identifier)
        case {'snctools:switchBackendsToHDF5'}
            values = nc_varget_h5(ncfile,varname,varargin{:});
            
        case 'snctools:switchBackendsToJava'
            values = nc_varget_java(ncfile,varname,varargin{:});
            
        otherwise
            handle_error(me);
    end
    return
end

netcdf.close(ncid);



%--------------------------------------------------------------------------
function values = varget(ncid,varname,varargin)

% Assume that we retrieve the variable in the root group until we know
% otherwise.  Assume that the variable name is given.
gid = ncid;
local_varname = varname;

% If the library is > 4 and the format is unrestricted netcdf-4, then we
% may need to drill down thru the groups.
lv = netcdf.inqLibVers;
if lv(1) == '4'
    fmt = netcdf.inqFormat(ncid);
    if strcmp(fmt,'FORMAT_NETCDF4') && (numel(strfind(varname,'/')) > 1)
        varpath = regexp(varname,'/','split');
        for k = 2:numel(varpath)-1
            gid = netcdf.inqNcid(gid,varpath{k});
        end
        local_varname = varpath{end};
    end
end

values = varget_group(gid,local_varname,varargin{:});



%--------------------------------------------------------------------------
function values = varget_group(ncid,varname,varargin)

% The assumption is that ncid is ID for the group (possibly the root group)
% containing the named variable, which had better not have a slash in the
% name.  

preserve_fvd = nc_getpref('PRESERVE_FVD');

varid=netcdf.inqVarID(ncid,varname);

% Check the datatype.  We can't handle enhanced datatypes here.
[dud,xtype]=netcdf.inqVar(ncid,varid); %#ok<ASGLU>
switch(xtype)
    case { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
        % Do nothing.
    otherwise
        % Have to let the HDF5 backend handle it.
        error('snctools:switchBackendsToHDF5', 'Unhandled by TMW backend');
end


[start,count,stride] = get_indices(ncid,varid,preserve_fvd,varargin{:});


% Pack up the input parameters to the netcdf package function.
ncargs{1} = ncid;
ncargs{2} = varid;
if ~isempty(start)
    ncargs{3} = start;
end
if ~isempty(count)
    ncargs{4} = count;
end
if ~isempty(stride)
    ncargs{5} = stride;
end


values = netcdf.getVar(ncargs{:});

values = post_process_values(ncid,varid,preserve_fvd,values);

return








%--------------------------------------------------------------------------
function values = post_process_values(ncid,varid,preserve_fvd,values)

[dud,xtype]=netcdf.inqVar(ncid,varid); %#ok<ASGLU>

% If it's a 1D vector, make it a column vector.  Otherwise permute the
% data to make up for the row-major-order-vs-column-major-order issue.
if isvector(values)
    if (size(values,2) > 1)
        % same as 'ISROW' (2010b).  If it's already a column, then we don't
        % need to do anything.
        values = values(:);
    end
elseif ~preserve_fvd
    % In other words, if we generally need to permute AND if we have a
    % real 2D or higher matrix, then go ahead and permute.
    pv = fliplr ( 1:ndims(values) );
    values = permute(values,pv);
end


% If there is a fill value, then apply it.
has_fill_value = true;
try
    att_type = netcdf.inqAtt(ncid, varid, '_FillValue' );
    if ( att_type == xtype )
        values = handle_fill_value_tmw(ncid,varid,xtype,values);
    else
        warning('SNCTOOLS:nc_varget:tmw:fillValueMismatch', ...
            'The _FillValue datatype for %s is wrong.  The _FillValue will not be honored.', ...
            varname);
    end
catch %#ok<CTCH>
    has_fill_value = false;
end




% Is there instead a missing value attribute?  
try
    att_type = netcdf.inqAtt(ncid, varid, 'missing_value' );
    if ~has_fill_value
        if (att_type == xtype)
            % fill value trumps missing values
            values = handle_missing_value_tmw(ncid,varid,xtype,values);
        else
            warning('SNCTOOLS:nc_varget:tmw:missingValueMismatch', ...
                'The missing_value datatype for %s is wrong.  The missing_value will not be honored.', ...
                varname);
        end
    end
catch %#ok<CTCH>
    % No missing value attribute, so there's nothing do to.
end



% Check for the existance of a scale_factor and/or add_offset attriute.
% If they exist, then a linear scaling is required.
has_scaling = false;
try
    netcdf.inqAtt(ncid, varid, 'scale_factor' );
    has_scaling = true;
catch %#ok<CTCH>
    %
end

try
    netcdf.inqAtt(ncid, varid, 'add_offset' );
    has_scaling = true;
catch %#ok<CTCH>
    %
end
if has_scaling
    values = handle_scaling_tmw(ncid,varid,values);
end


% remove any singleton dimensions.
values = squeeze ( values );

%--------------------------------------------------------------------------
function values = handle_fill_value_tmw ( ncid, varid, var_type, values )
% HANDLE_TMW_FILL_VALUE
%     If there is a fill value, then replace such values with NaN.


switch ( var_type )
    case nc_char
        % For now, do nothing.  Does a fill value even make sense with 
        % char data?  If it does, please tell me so.

    case { nc_double, nc_float, nc_int, nc_short, nc_byte }
        fill_value = netcdf.getAtt(ncid,varid,'_FillValue','double');
        values = double(values);
        values(values==fill_value) = NaN;

    otherwise
        error ( 'SNCTOOLS:nc_varget:unhandledFillValueType', ...
            'Unhandled fill value datatype %d', var_type );

end

return






%--------------------------------------------------------------------------
function values = handle_missing_value_tmw(ncid,varid,var_type,values)
% HANDLE_TMW_MISSING_VALUE
%     If there is a missing value, then replace such values with NaN.

switch ( var_type )
    case nc_char
        % For now, do nothing.  Does a missing value even make 
        % sense with char data?  If it does, please tell me so.

    case { nc_double, nc_float, nc_int, nc_short, nc_byte }
        values = double(values);
        fill_value = netcdf.getAtt(ncid,varid,'missing_value','double');
        values(values==fill_value) = NaN;

    otherwise
        error('SNCTOOLS:nc_varget:tmw:unhandledMissingValueDatatype', ...
              'Unhandled datatype %d.', var_type );
end



return








%--------------------------------------------------------------------------
function values = handle_scaling_tmw ( ncid, varid, values )
% HANDLE_TMW_SCALING
%
% If there is a scale factor and/or  add_offset attribute, convert the data
% to double precision and apply the scaling.

values = double(values);

try
    netcdf.inqAtt(ncid, varid, 'scale_factor' );
    have_scale = true;
catch me %#ok<NASGU>
    have_scale = false;
end
try
    netcdf.inqAtt(ncid, varid, 'add_offset' ); 
    have_addoffset = true;
catch me %#ok<NASGU>
    have_addoffset = false;
end

%
% Return early if we don't have either one.
if ~(have_scale || have_addoffset)
    return;
end

scale_factor = 1.0;
add_offset = 0.0;

if have_scale
    scale_factor = netcdf.getAtt(ncid,varid,'scale_factor','double');
end
if have_addoffset
    add_offset = netcdf.getAtt(ncid,varid,'add_offset','double');
end


values = values * scale_factor + add_offset;

return




%-----------------------------------------------------------------------
function var_size = get_varsize(ncid,varid,preserve_fvd)
% GET_VARSIZE: Need to figure out just how big the variable is.

[dud,xtype,dimids]=netcdf.inqVar(ncid,varid); %#ok<ASGLU>
nvdims = numel(dimids);
% If not a singleton, we need to figure out how big the variable is.
if nvdims == 0
    var_size = [];
else
    var_size = zeros(1,nvdims);
    for j=1:nvdims,
        dimid = dimids(j);
        [dim_name,dim_size]=netcdf.inqDim(ncid, dimid); %#ok<ASGLU>
        var_size(j)=dim_size;
    end
end

% Reverse the dimensionsions?
if ~preserve_fvd
    var_size = fliplr(var_size);
end

return

%--------------------------------------------------------------------------
function [start,count,stride] = get_indices(ncid,varid,preserve_fvd,varargin)
% Set the index arguments appropriately.

var_size = get_varsize(ncid,varid,preserve_fvd);
nvdims = numel(var_size);

if nvdims == 0
    start = [];
    count = [];
    stride = [];
    return
end

switch(numel(varargin))
    case 0
        start = zeros(1,nvdims);
        count = var_size;
        stride = ones(1,nvdims);
    case 2
        start = varargin{1};
        count = varargin{2};
        stride = ones(1,nvdims);
    case 3
        start = varargin{1};
        count = varargin{2};
        stride = varargin{3};        
    otherwise
        error('SNCTOOLS:wrongNumberOfInputs','Wrong number of inputs.');
end



% R2008b expects to preserve the fastest varying dimension, so if the
% user didn't want that, we have to reverse the indices.
if ~preserve_fvd
    start = fliplr(start);
    count = fliplr(count);
    stride = fliplr(stride);
    var_size = fliplr(var_size);
end

% Check that the start, count, stride parameters have appropriate
% lengths.  Otherwise we get confusing error messages later on.
%snc_validate_idx(start,count,stride,nvdims);


% If the user had set non-positive numbers in "count", then we replace
% them with what we need to get the rest of the variable.
negs = find((count<0) | isinf(count));
if isempty(stride)
    count(negs) = var_size(negs) - start(negs);
else
    count(negs) = floor((var_size(negs) - start(negs))./stride(negs));
end


%--------------------------------------------------------------------------
function values = nc_varget_h5(ncfile,varname,varargin)


preserve_fvd = nc_getpref('PRESERVE_FVD');
if numel(varargin) > 0
    % H5READ is one-based.
    varargin{1} = varargin{1} + 1;
end
for j = 1:numel(varargin)
    if ~preserve_fvd
        varargin{j} = fliplr(varargin{j});
    end
end
values = h5read(ncfile,['/' varname],varargin{:});
            
if ~preserve_fvd
    values = permute(values, ndims(values):-1:1 );
end
            

%--------------------------------------------------------------------------
function handle_error(e)

v = version('-release');

 
switch(e.identifier)

    case 'MATLAB:imagesci:netcdf:libraryFailure'
        
        switch(v)
            case'2011b'
                % 2011b error messages are unfortunate.
                if strfind(e.message,'einvalcoords:indexExceedsDimensionBound')
                    % Bad start.
                    error(e.identifier, ...
                        'Index exceeds dimension bound.');
                elseif strfind(e.message,'eedge:startPlusCountExceedsDimensionBound')
                    
                    % Bad count
                    error(e.identifier, ...
                        'Start+count exceeds dimension bound.');
                    
                elseif strfind(e.message,'enotvar:variableNotFound')
                    error(e.identifier, 'Variable not found.');
                    
                else
                    rethrow(e);
                end
            otherwise
                rethrow(e);
        end
        
        
    otherwise
        rethrow(e);
end
