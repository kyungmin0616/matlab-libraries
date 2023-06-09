function values = nc_varget_tmw(ncfile,varname,start,count,stride)

ncid=netcdf.open(ncfile,'NOWRITE');
varid=netcdf.inqVarid(ncid,varname);
[dud,var_type,dimids]=netcdf.inqVar(ncid,varid);
nvdims = numel(dimids);

the_var_size = determine_varsize_tmw ( ncid, dimids, nvdims );

% R2008b expects to preserve the fastest varying dimension, so if the
% user didn't want that, we have to reverse the indices.
preserve_fvd = getpref('SNCTOOLS','PRESERVE_FVD',false);
if ~preserve_fvd
    start = fliplr(start);
    count = fliplr(count);
    stride = fliplr(stride);
    the_var_size = fliplr(the_var_size);
end

%
% Check that the start, count, stride parameters have appropriate lengths.
% Otherwise we get confusing error messages later on.
validate_index_vectors(start,count,stride,nvdims);


%
% If the user had set non-positive numbers in "count", then we replace them
% with what we need to get the rest of the variable.
negs = find(count<0);
count(negs) = the_var_size(negs) - start(negs);


% If there is a fill value, missing value, scale_factor, or add_offset, we
% will retrieve the data as double precision.
retrieve_as_double = false;
use_fill_value = false;
use_missing_value = false;
has_scaling = false;
try
    netcdf.inqAtt(ncid, varid, '_FillValue' );
	use_fill_value = true;
	retrieve_as_double = true;
end
try
    netcdf.inqAtt(ncid, varid, 'missing_value' );
	if ~use_fill_value
		% fill value trumps missing values
	    use_missing_value = true;
		retrieve_as_double = true;
	end
end
try
    netcdf.inqAtt(ncid, varid, 'scale_factor' );
	has_scaling = true;
	retrieve_as_double = true;
end
try
    netcdf.inqAtt(ncid, varid, 'add_offset' );
	has_scaling = true;
	retrieve_as_double = true;
end

% NC_CHAR can never be retrieved as numeric.
if ( var_type == nc_char)
    retrieve_as_double = false;
end

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
if retrieve_as_double
	ncargs{end+1} = 'double';
end


%
% At long last, retrieve the data.
values = netcdf.getVar(ncargs{:});


%
% If it's a 1D vector, make it a column vector.  Otherwise permute the data
% to make up for the row-major-order-vs-column-major-order issue.
if length(the_var_size) == 1
    values = values(:);
else
    if ~preserve_fvd
        pv = fliplr ( 1:length(the_var_size) );
        values = permute(values,pv);
    end
end                                                                                   


if use_fill_value
	values = handle_fill_value_tmw ( ncid, varid, var_type, values );
end
if use_missing_value
	values = handle_missing_value_tmw ( ncid, varid, var_type, values );
end
if has_scaling
	values = handle_scaling_tmw ( ncid, varid, values );
end


%
% remove any singleton dimensions.
values = squeeze ( values );


netcdf.close(ncid);


return

















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% HANDLE_TMW_FILL_VALUE
%     If there is a fill value, then replace such values with NaN.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function values = handle_fill_value_tmw ( ncid, varid, var_type, values )

try
    switch ( var_type )
        case nc_char
        %
            % For now, do nothing.  Does a fill value even make sense with char data?
            % If it does, please tell me so.
        case { nc_double, nc_float, nc_int, nc_short, nc_byte }
                fill_value = netcdf.getAtt(ncid, varid, '_FillValue', 'double' );
                values(values==fill_value) = NaN;

        otherwise
                netcdf.close(ncid);
                error ( 'SNCTOOLS:nc_varget:unhandledFillValueType', ...
                         'Unhandled fill value datatype %d', var_type );
                        
    end


catch myException
    netcdf.close(ncid);
    rethrow(myException);
end

return






%--------------------------------------------------------------------------
function values = handle_missing_value_tmw ( ncid, varid, var_type, values )
% HANDLE_TMW_MISSING_VALUE
%     If there is a missing value, then replace such values with NaN.
%

try
    switch ( var_type )
        case nc_char
            % For now, do nothing.  Does a fill value even make sense with char data?
            % If it does, please tell me so.
    
        case { nc_double, nc_float, nc_int, nc_short, nc_byte }
            fill_value  = netcdf.getAtt(ncid, varid, 'missing_value', 'double' );
            values(values==fill_value) = NaN;
    
        otherwise
            netcdf.close(ncid);
            error ( 'SNCTOOLS:nc_varget:tmw:unhandledMissingValueDatatype', ...
                    'Unhandled datatype %d.', var_type );
    end
    

catch myException
    netcdf.close(ncid);
    rethrow(myException);
end

return








%--------------------------------------------------------------------------
function values = handle_scaling_tmw ( ncid, varid, values )
% HANDLE_TMW_SCALING
%     If there is a scale factor and/or  add_offset attribute, convert the data
%     to double precision and apply the scaling.

have_scale = false;
have_addoffset = false;
try
    netcdf.inqAtt(ncid, varid, 'scale_factor' );
    have_scale = true;
end
try
    netcdf.inqAtt(ncid, varid, 'add_offset' ); 
    have_addoffset = true;
end

%
% Return early if we don't have either one.
if ~(have_scale || have_addoffset)
    return;
end

scale_factor = 1.0;
add_offset = 0.0;

if have_scale
    try 
        scale_factor = netcdf.getAtt(ncid,varid,'scale_factor','double');
    catch myException
        netcdf.close(ncid);
        rethrow(myException);
    end
end
if have_addoffset
    try 
        add_offset = netcdf.getAtt(ncid,varid,'add_offset','double');
    catch myException
        netcdf.close(ncid);
        rethrow(myException);
    end
end


values = values * scale_factor + add_offset;

return




%-----------------------------------------------------------------------
function the_var_size = determine_varsize_tmw ( ncid, dimids, nvdims )
% DETERMINE_VARSIZE_TMW: Need to figure out just how big the variable is.
%
% VAR_SIZE = DETERMINE_VARSIZE_TMW(NCID,DIMIDS,NVDIMS);

%
% If not a singleton, we need to figure out how big the variable is.
if nvdims == 0
    the_var_size = 1;
else
    the_var_size = zeros(1,nvdims);
    for j=1:nvdims,
        dimid = dimids(j);
        try
            [dim_name,dim_size]=netcdf.inqDim(ncid, dimid);
        catch myException
            netcdf.close(ncid);
            rethrow(myException);
        end
        the_var_size(j)=dim_size;
    end
end

if ~getpref('SNCTOOLS','PRESERVE_FVD',false)
    the_var_size = fliplr(the_var_size);
end

return





