function [varargout] = mexnc_tmw(varargin)
% MEXNC_TMW:  use the mathworks netcdf package
varargout = cell(1,nargout);
op = lower(varargin{1});

% If the leading three chars are 'nc_', then strip it.
if (numel(op) > 3) && strcmp(op(1:3),'nc_')
    op = op(4:end);
end

% If the leading three chars are 'nc', and the 3rd char is NOT '_', then strip the first
% two chars.
if (numel(op) > 3) && strcmp(op(1:2),'nc') && (op(3) ~= '_')
    op = op(3:end);
end

switch op
    case { 'close', 'copy_att', 'create', '_create', 'def_dim', 'def_var', 'del_att'}
        handler = eval ( ['@handle_' op] );

    case {'enddef', 'end_def', '_enddef'}
        handler = @handle_enddef;

    case {'get_att_double', 'get_att_float', 'get_att_int', ...
          'get_att_short', 'get_att_schar', 'get_att_uchar', ...
          'get_att_text'}
        handler = @handle_get_att;

    case { 'get_var_double', 'get_var_float', 'get_var_int', ...
           'get_var_short', 'get_var_schar', 'get_var_uchar', ...
           'get_var_text' }
        handler = @handle_get_var;

    case { 'get_var1_double', 'get_var1_float', 'get_var1_int', ...
           'get_var1_short', 'get_var1_schar', 'get_var1_uchar', ...
           'get_var1_text' }
        handler = @handle_get_var1;

    case { 'get_vara_double', 'get_vara_float', 'get_vara_int', ...
           'get_vara_short', 'get_vara_schar', 'get_vara_uchar', ...
           'get_vara_text' }
        handler = @handle_get_vara;

    case { 'get_vars_double', 'get_vars_float', 'get_vars_int', ...
           'get_vars_short', 'get_vars_schar', 'get_vars_uchar', ...
           'get_vars_text' }
        handler = @handle_get_vars;

    case { 'get_varm_double', 'get_varm_float', 'get_varm_int', ...
           'get_varm_short', 'get_varm_schar', 'get_varm_uchar', ...
           'get_varm_text' }
        error ('MEXNC:getVarm:notSupported', ...
            '%s is not supported by the netCDF package.', op );

    case {'inq', 'inq_ndims' , ...
          'inq_nvars', 'inq_natts', 'inq_dim', 'inq_dimlen', ...
          'inq_dimname', 'inq_attid', 'inq_dimid', 'inq_libvers', 'inq_var', ...
          'inq_varname', 'inq_vartype', 'inq_varndims', 'inq_vardimid', ...
          'inq_varnatts', 'inq_varid', 'inq_att', 'inq_atttype', 'inq_attlen', ...
          'inq_attname', 'inq_unlimdim', 'open', '_open' }
        handler = eval ( ['@handle_' op] );

    case { 'put_att_double', 'put_att_float', 'put_att_int', 'put_att_short', ...
           'put_att_schar', 'put_att_uchar', 'put_att_text' }
        handler = @handle_put_att;

    case { 'put_var_double', 'put_var_float', 'put_var_int', ...
           'put_var_short', 'put_var_schar', 'put_var_uchar', ...
           'put_var_text' }
        handler = @handle_put_var;

    case { 'put_var1_double', 'put_var1_float', 'put_var1_int', ...
           'put_var1_short', 'put_var1_schar', 'put_var1_uchar', ...
           'put_var1_text' }
        handler = @handle_put_var1;

    case { 'put_vara_double', 'put_vara_float', 'put_vara_int', ...
           'put_vara_short', 'put_vara_schar', 'put_vara_uchar', ...
           'put_vara_text' }
        handler = @handle_put_vara;

    case { 'put_vars_double', 'put_vars_float', 'put_vars_int', ...
           'put_vars_short', 'put_vars_schar', 'put_vars_uchar', ...
           'put_vars_text' }
        handler = @handle_put_vars;

    case { 'put_varm_double', 'put_varm_float', 'put_varm_int', ...
           'put_varm_short', 'put_varm_schar', 'put_varm_uchar', ...
           'put_varm_text' }
        error ('MEXNC:putVarm:notSupported', ...
            '%s is not supported by the netCDF package.', op );

    case {'redef', 'rename_att', 'rename_dim', 'rename_var', 'set_fill', ...  
          'strerror', 'sync' }
        handler = eval ( ['@handle_' op] );

    % NETCDF-2 functions
    case { 'attcopy', 'attdel', 'attget', 'attinq', 'attname', 'attput', ...
           'attrename', 'dimdef', 'dimid', 'diminq', 'dimrename', 'endef',  ...
           'inquire', 'parameter', 'typelen', 'vardef', 'varid', 'varinq', ...
           'varget1',  'varput1', 'varget', 'varput', 'vargetg', 'varputg',  ...
           'varrename', 'setopts' }
        handler = eval ( ['@handle_' op] );

    otherwise
        error('MEXNC:TMW:unrecognizedFuncstr',...
              'Function string ''%s'' is not recognized.\n',op);
end

if nargout > 0
    [varargout{:}] = handler ( varargin{:} );
else
    handler ( varargin{:} );
end


%------------------------------------------------------------------------------------------
function varargout = handle_parameter ( varargin ) 
%      status = mexnc('PARAMETER', name);


error(nargchk(2,2,nargin,'struct'));

varargout = cell(1,nargout);
switch ( lower(varargin{2}) )
    case 'max_nc_name'
        output = netcdf.getConstant('nc_max_name');
    case 'max_nc_dims'
        output = netcdf.getConstant('nc_max_dims');
    case 'max_nc_vars'
        output = netcdf.getConstant('nc_max_vars');
    case 'max_nc_attrs'
        output = netcdf.getConstant('nc_max_attrs');
    otherwise
        output = netcdf.getConstant(varargin{2});
end
if nargout > 0
    varargout{1} = output;
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_libvers ( varargin ) 
%      status = mexnc('CLOSE',ncid);


varargout = cell(1,nargout);
output = netcdf.inqLibvers();
if nargout > 0
    varargout{1} = output;
end



%------------------------------------------------------------------------------------------
function varargout = handle_close ( varargin ) %#ok<*DEFNU>
%      status = mexnc('CLOSE',ncid);

varargout = cell(1,nargout);

try
    netcdf.close(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_copy_att ( varargin )
%     status = mexnc('COPY_ATT',ncid_in,varid_in,attname,ncid_out,varid_out);

varargout = cell(1,nargout);

try
    netcdf.copyAtt(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_create ( varargin )
%      [ncid,status] = mexnc ('CREATE',filename,access_mode );
%      [ncid,status] = mexnc ('CREATE',filename);

varargout = cell(1,nargout);

% Sometimes this is called with just two inputs arguments.
% In that case, the default for the 3rd parameter is 'NC_NOWRITE'
if nargin == 2
    varargin{3} = 'NC_NOWRITE';
end

try
    ncid = netcdf.create(varargin{2:end});
    status = 0;
catch myException
    ncid = -1;
    status = exception2status(myException);
end


switch nargout
    case 1
        varargout{1} = ncid; 
        
    case 2
        varargout{1} = ncid;
        varargout{2} = status;

end





%------------------------------------------------------------------------------------------
function varargout = handle__create ( varargin )
% [chunksz_out,ncid,status] = mexnc ('_CREATE',filename,mode,initialsize,chunksz_in);

varargout = cell(1,nargout);
% 
% There is a bug in mexnc where chunksize is an optional argument.
filename = varargin{2};
mode = varargin{3};
initialsize = varargin{4};
if nargin == 5
    chunksize_in = varargin{5};
else
    chunksize_in = 0;
end

try
    [czout,ncid] = netcdf.create(filename,mode,initialsize,chunksize_in);
    status = 0;
catch myException
    czout = -1;
    ncid = -1;
    status = exception2status(myException);
end


switch nargout
    case 1
        varargout{1} = czout; 
        
    case 2
        varargout{1} = czout;
        varargout{2} = ncid;

    case 3
        varargout{1} = czout;
        varargout{2} = ncid; 
        varargout{3} = status;
end



%------------------------------------------------------------------------------------------
function varargout = handle_def_dim ( varargin )
%      [dimid,status] = mexnc('DEF_DIM',ncid,name,length);

varargout = cell(1,nargout);

try
    dimid = netcdf.defDim(varargin{2:end});
    status = 0;
catch myException
    dimid = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = dimid; 
        
    case 2
        varargout{1} = dimid;
        varargout{2} = status;
end





%------------------------------------------------------------------------------------------
function varargout = handle_def_var ( varargin )
%      [varid,status] = mexnc('DEF_VAR',ncid,name,xtype,dimids);
%      [varid,status] = mexnc('DEF_VAR',ncid,name,xtype,ndims,dimids);

error(nargchk(5,6,nargin,'struct'));
varargout = cell(1,nargout);

if (nargin == 6) && (varargin{5} ~= numel(varargin{6}))
    error('MEXNC:handle_def_var', ...
          'Mismatch between number of dimensions and length of dimension list.');
end
dimids = varargin{end};
varargin = varargin(1:4);

% Mexnc and the netcdf package differ wrt the ordering of the 
% dimensions.
if (ndims(dimids) == 2) && (size(dimids,2) == 1)
    dimids = flipud(dimids);
else
    dimids = fliplr(dimids);
end


try
    varid = netcdf.defVar(varargin{2:end},dimids);
    status = 0;
catch myException
    varid = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = varid; 
        
    case 2
        varargout{1} = varid;
        varargout{2} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_del_att ( varargin )
%     status = mexnc('DEL_ATT',ncid,varid,attname);

varargout = cell(1,nargout);

try
    netcdf.delAtt(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
end




%------------------------------------------------------------------------------------------
function varargout = handle_enddef ( varargin )
%      status = mexnc('ENDDEF',ncid);
%      status = mexnc('_ENDDEF',ncid,h_minfree,v_align,v_minfree,r_align);

varargout = cell(1,nargout);

try
    netcdf.endDef(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_get_att ( varargin )
%     [att_value,status] = mexnc('GET_ATT_DOUBLE',ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_FLOAT', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_INT',   ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_SHORT', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_SCHAR', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_UCHAR', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_TEXT',  ncid,varid,attname);

error(nargchk(4,4,nargin,'struct'));

varargout = cell(1,nargout);

switch ( upper(varargin{1}) ) 
    case 'GET_ATT_DOUBLE'
        outClass = 'double';
    case 'GET_ATT_FLOAT'
        outClass = 'single';
    case 'GET_ATT_INT'
        outClass = 'int';
    case 'GET_ATT_SHORT'
        outClass = 'short';
    case 'GET_ATT_SCHAR'
        outClass = 'schar';
    case 'GET_ATT_UCHAR'
        outClass = 'uchar';
    case 'GET_ATT_TEXT'
        outClass = 'text';

end

try
    attval = netcdf.getAtt(varargin{2:end}, outClass);
    status = 0;
catch myException
    attval = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = attval; 
    case 2
        varargout{1} = attval; 
        varargout{2} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq ( varargin )
% [ndims,nvars, ngatts, unlimdim, status] = mexnc('INQ',ncid);

varargout = cell(1,nargout);

try
    [ndims,nvars,ngatts,unlimdim] = netcdf.inq(varargin{2:end});
    status = 0;
catch myException
    ndims = -1;
    nvars = -1;
    ngatts = -1;
    unlimdim = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = ndims; 
    case 2
        varargout{1} = ndims; 
        varargout{2} = nvars; 
    case 3
        varargout{1} = ndims; 
        varargout{2} = nvars; 
        varargout{3} = ngatts; 
    case 4
        varargout{1} = ndims; 
        varargout{2} = nvars; 
        varargout{3} = ngatts; 
        varargout{4} = unlimdim; 
    case 5
        varargout{1} = ndims; 
        varargout{2} = nvars; 
        varargout{3} = ngatts; 
        varargout{4} = unlimdim; 
        varargout{5} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_dim ( varargin )
%      [name,length,status] = mexnc('INQ_DIM',ncid,dimid);

varargout = cell(1,nargout);

try
    [name,dimlen] = netcdf.inqDim(varargin{2:end});
    status = 0;
catch myException
    name = '';
    dimlen = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = name; 
    case 2
        varargout{1} = name; 
        varargout{2} = dimlen; 
    case 3
        varargout{1} = name; 
        varargout{2} = dimlen; 
        varargout{3} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_dimlen ( varargin )
%      [dimlength,status] = mexnc('INQ_DIMLEN',ncid,dimid);

varargout = cell(1,nargout);

try
    [dud,dimlen] = netcdf.inqDim(varargin{2:end});
    status = 0;
catch myException
    dimlen = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = dimlen; 
    case 2
        varargout{1} = dimlen; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_dimname ( varargin )
%      [dimname,status] = mexnc('INQ_DIMNAME',ncid,dimid);

varargout = cell(1,nargout);

try
    name = netcdf.inqDim(varargin{2:end});
    status = 0;
catch myException
    name = '';
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = name; 
    case 2
        varargout{1} = name; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_ndims ( varargin )
%      [ndims,status] = mexnc('INQ_NDIMS',ncid);

varargout = cell(1,nargout);

try
    ndims = netcdf.inq(varargin{2:end});
    status = 0;
catch myException
    ndims = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = ndims; 
    case 2
        varargout{1} = ndims; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_nvars ( varargin )
%      [nvars,status] = mexnc('INQ_NVARS',ncid);

varargout = cell(1,nargout);

try
    [dud,nvars] = netcdf.inq(varargin{2:end});
    status = 0;
catch myException
    nvars = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = nvars; 
    case 2
        varargout{1} = nvars; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_natts ( varargin )
%      [natts,status] = mexnc('INQ_NATTS',ncid);

varargout = cell(1,nargout);

try
    [dud,dud,natts] = netcdf.inq(varargin{2:end});
    status = 0;
catch myException
    natts = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = natts; 
    case 2
        varargout{1} = natts; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_dimid ( varargin )
% [dimid,status] = mexnc('INQ_DIMID',ncid,name);

varargout = cell(1,nargout);

try
    dimid = netcdf.inqDimID(varargin{2:end});
    status = 0;
catch myException
    dimid = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = dimid; 
    case 2
        varargout{1} = dimid; 
        varargout{2} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_attid ( varargin )
%     [attid,status] = mexnc('INQ_ATTID',ncid,varid,attname);

varargout = cell(1,nargout);

try
    attId = netcdf.inqAttID(varargin{2:end});
    status = 0;
catch myException
    attId = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = attId; 
    case 2
        varargout{1} = attId; 
        varargout{2} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_var ( varargin )
% [varname,xtype,ndims,dimids,natts,status] = mexnc('INQ_VAR',ncid,varid);

varargout = cell(1,nargout);

try
    [varname,xtype,dimids,natts] = netcdf.inqVar(varargin{2:end});
    ndims = numel(dimids);
    status = 0;
catch myException
    varname = '';
    xtype = -1;
    ndims = -1;
    dimids = -1;
    natts = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = varname; 
    case 2
        varargout{1} = varname; 
        varargout{2} = xtype; 
    case 3
        varargout{1} = varname; 
        varargout{2} = xtype; 
        varargout{3} = ndims; 
    case 4
        varargout{1} = varname; 
        varargout{2} = xtype; 
        varargout{3} = ndims; 
        varargout{4} = fliplr(dimids); 
    case 5
        varargout{1} = varname; 
        varargout{2} = xtype; 
        varargout{3} = ndims; 
        varargout{4} = fliplr(dimids); 
        varargout{5} = natts; 
    case 6
        varargout{1} = varname; 
        varargout{2} = xtype; 
        varargout{3} = ndims; 
        varargout{4} = fliplr(dimids); 
        varargout{5} = natts; 
        varargout{6} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_varname ( varargin )
%      [varname,status] = mexnc('INQ_VARNAME',ncid,varid);

varargout = cell(1,nargout);

try
    varname = netcdf.inqVar(varargin{2:end});
    status = 0;
catch myException
    varname = '';
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = varname; 
    case 2
        varargout{1} = varname; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_vartype ( varargin )
%      [vartype,status] = mexnc('INQ_VARTYPE',ncid,varid);

varargout = cell(1,nargout);

try
    [dud,xtype] = netcdf.inqVar(varargin{2:end});
    status = 0;
catch myException
    xtype = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = xtype; 
    case 2
        varargout{1} = xtype; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_varndims ( varargin )
%      [varndims,status] = mexnc('INQ_VARNDIMS',ncid,varid);

varargout = cell(1,nargout);

try
    [dud,dud,dimids] = netcdf.inqVar(varargin{2:end});
    ndims = numel(dimids);
    status = 0;
catch myException
    ndims = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = ndims; 
    case 2
        varargout{1} = ndims; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_vardimid ( varargin )
%      [dimids,status] = mexnc('INQ_VARDIMID',ncid,varid);

varargout = cell(1,nargout);

try

    [dud,dud,dimids] = netcdf.inqVar(varargin{2:end});

    % Flip the dimids for mexnc.   The netcdf package
    % uses fortran-style ordering of dimensions.
    dimids = fliplr(dimids);
    status = 0;

catch myException
    dimids = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = dimids; 
    case 2
        varargout{1} = dimids; 
        varargout{2} = status; 
end



%------------------------------------------------------------------------------------------
function varargout = handle_inq_varnatts ( varargin )
% [varnatts,status] = mexnc('INQ_VARNATTS',ncid,varid);
% [varname,xtype,ndims,dimids,natts,status] = mexnc('INQ_VAR',ncid,varid);

varargout = cell(1,nargout);

try
    [dud,dud,dud,natts] = netcdf.inqVar(varargin{2:end});
    status = 0;
catch myException
    natts = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = natts; 
    case 2
        varargout{1} = natts; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_varid ( varargin )
% [varid,status] = mexnc('INQ_VARID',ncid,varname);

varargout = cell(1,nargout);

try
    varid = netcdf.inqVarID(varargin{2:end});
    status = 0;
catch myException
    varid = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = varid; 
    case 2
        varargout{1} = varid; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_att ( varargin )
%     [datatype,attlen,status] = mexnc('INQ_ATT',ncid,varid,attname);

varargout = cell(1,nargout);

try
    [xtype,len] = netcdf.inqAtt(varargin{2:end});
    status = 0;
catch myException
    xtype = -1;
    len = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = xtype; 
    case 2
        varargout{1} = xtype; 
        varargout{2} = len; 
    case 3
        varargout{1} = xtype; 
        varargout{2} = len; 
        varargout{3} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_atttype ( varargin )
%     [datatype,attlen,status] = mexnc('INQ_ATT',ncid,varid,attname);
%     [att_type,status] = mexnc('INQ_ATTTYPE',ncid,varid,attname);

varargout = cell(1,nargout);

try
    xtype = netcdf.inqAtt(varargin{2:end});
    status = 0;
catch myException
    xtype = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = xtype; 
    case 2
        varargout{1} = xtype; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_attlen ( varargin )
%     [datatype,attlen,status] = mexnc('INQ_ATT',ncid,varid,attname);
%     [att_len,status] = mexnc('INQ_ATTLEN',ncid,varid,attname);

varargout = cell(1,nargout);

try
    [dud,len] = netcdf.inqAtt(varargin{2:end});
    status = 0;
catch myException
    len = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = len; 
    case 2
        varargout{1} = len; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_attname ( varargin )
%     [attname,status] = mexnc('INQ_ATTNAME',ncid,varid,attid);

varargout = cell(1,nargout);

try
    attname = netcdf.inqAttName(varargin{2:end});
    status = 0;
catch myException
    attname = '';
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = attname; 
    case 2
        varargout{1} = attname; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_inq_unlimdim ( varargin )
%      [ndims,nvars, ngatts, unlimdim, status] = mexnc('INQ',ncid);
%      [unlimdim,status] = mexnc ('INQ_UNLIMDIM',ncid);

varargout = cell(1,nargout);

try
    [dud,dud,dud,unlimdim] = netcdf.inq(varargin{2:end});
    status = 0;
catch myException
    unlimdim = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = unlimdim; 
    case 2
        varargout{1} = unlimdim; 
        varargout{2} = status; 
end


%------------------------------------------------------------------------------------------
function varargout = handle_open ( varargin )
%  [ncid,status] = mexnc('OPEN',filename,access_mode);

varargout = cell(1,nargout);

% Mexnc allowed for a default NOWRITE mode.
if nargin == 2
    filename = varargin{2};
    mode = netcdf.getConstant('NC_NOWRITE');
else
    filename = varargin{2};
    mode = varargin{end};
end
try
    ncid = netcdf.open(filename,mode);
    status = 0;
catch myException
    ncid = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = ncid; 
    case 2
        varargout{1} = ncid; 
        varargout{2} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle__open ( varargin )
%  [ncid,chunksizehint,status] 
%      = mexnc('_OPEN',filename,access_mode,chunksizehint);

varargout = cell(1,nargout);

try
    [ncid,czout] = netcdf.open(varargin{2:end});
    status = 0;
catch myException
    ncid = -1;
    czout = -1;
    status = exception2status(myException);
end


switch nargout
    case 1
        varargout{1} = ncid; 
    case 2
        varargout{1} = ncid; 
        varargout{2} = czout; 
    case 3
        varargout{1} = ncid; 
        varargout{2} = czout; 
        varargout{3} = status; 
end




%------------------------------------------------------------------------------------------
function varargout = handle_put_att ( varargin )
%     status = mexnc('PUT_ATT_DOUBLE',ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_FLOAT', ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_INT',   ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_SHORT', ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_SCHAR', ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_UCHAR', ncid,varid,attname,datatype,attvalue);
%     status = mexnc('PUT_ATT_TEXT',  ncid,varid,attname,datatype,attvalue);
%
% or
%
%     status = mexnc('PUT_ATT_DOUBLE',ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_FLOAT', ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_INT',   ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_SHORT', ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_SCHAR', ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_UCHAR', ncid,varid,attname,datatype,nelt,attvalue);
%     status = mexnc('PUT_ATT_TEXT',  ncid,varid,attname,datatype,nelt,attvalue);

varargout = cell(1,nargout);

% Don't bother with the number of elements or datatype.
if nargin == 7
    neededInputs = [2:4 7];
else
    neededInputs = [2:4 6];
end

try
    netcdf.putAtt(varargin{neededInputs});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end






%------------------------------------------------------------------------------------------
function varargout = handle_get_var ( varargin )
%     [data,status] = mexnc('GET_VAR_DOUBLE',ncid,varid);
%     [data,status] = mexnc('GET_VAR_FLOAT', ncid,varid);
%     [data,status] = mexnc('GET_VAR_INT',   ncid,varid);
%     [data,status] = mexnc('GET_VAR_SHORT', ncid,varid);
%     [data,status] = mexnc('GET_VAR_SCHAR', ncid,varid);
%     [data,status] = mexnc('GET_VAR_UCHAR', ncid,varid);
%     [data,status] = mexnc('GET_VAR_TEXT',  ncid,varid);

varargout = cell(1,nargout);

try
    if strcmpi(varargin{1},'get_var_uchar')
           data = netcdf.getVar(varargin{2:end},'uint8');
    else
           data = netcdf.getVar(varargin{2:end});
    end
    status = 0;
catch myException
    data = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = data; 
    case 2
        varargout{1} = data; 
        varargout{2} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_get_var1 ( varargin )
%     [data,status] = mexnc('GET_VAR1_DOUBLE',ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_FLOAT', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_INT',   ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_SHORT', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_SCHAR', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_UCHAR', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_TEXT',  ncid,varid,start);

varargout = cell(1,nargout);

% If the op is get_var1_x, and if the variable is a singleton, then we have to remap
% the operation as 'get_var_x'.
[varname,xtype,dimids] = netcdf.inqVar(varargin{2:3});
if ( numel(dimids) == 0 ) 
    op = varargin{1};
    varargin{1} = ['get_var_' op(10:end)];
    [varargout{:}] = handle_get_var(varargin{1:end-1});
    return
end

% Must flip the indices.
varargin{4} = fliplr(varargin{4});

try
    if strcmpi(varargin{1},'get_var1_uchar')
           data = netcdf.getVar(varargin{2:end},'uint8');
    else
           data = netcdf.getVar(varargin{2:end});
    end
    status = 0;
catch myException
    data = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = data; 
    case 2
        varargout{1} = data; 
        varargout{2} = status; 
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_get_vara ( varargin )
%     [data,status] = mexnc('GET_VARA_DOUBLE',ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_FLOAT', ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_INT',   ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_SHORT', ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_SCHAR', ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_UCHAR', ncid,varid,start,count);
%     [data,status] = mexnc('GET_VARA_TEXT',  ncid,varid,start,count);

varargout = cell(1,nargout);

% Must flip the indices.
varargin{4} = fliplr(varargin{4});
varargin{5} = fliplr(varargin{5});

% If the variable is a singleton, just use get_var instead.

try
    if strcmpi(varargin{1},'get_vara_uchar')
           data = netcdf.getVar(varargin{2:end},'uint8');
    else
           data = netcdf.getVar(varargin{2:end});
    end
    status = 0;
catch myException
    data = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = data; 
    case 2
        varargout{1} = data; 
        varargout{2} = status; 
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_get_vars ( varargin )
%     [data,status] = mexnc('GET_VARS_DOUBLE',ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_FLOAT', ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_INT',   ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_SHORT', ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_SCHAR', ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_UCHAR', ncid,varid,start,count,stride);
%     [data,status] = mexnc('GET_VARS_TEXT',  ncid,varid,start,count,stride);

varargout = cell(1,nargout);

% Must flip the indices.
varargin{4} = fliplr(varargin{4});
varargin{5} = fliplr(varargin{5});
varargin{6} = fliplr(varargin{6});

try
    if strcmpi(varargin{1},'get_vars_uchar')
           data = netcdf.getVar(varargin{2:end},'uint8');
    else
           data = netcdf.getVar(varargin{2:end});
    end
    status = 0;
catch myException
    data = -1;
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = data; 
    case 2
        varargout{1} = data; 
        varargout{2} = status; 
        
end





%------------------------------------------------------------------------------------------
function varargout = handle_put_var ( varargin )
%     status = mexnc('PUT_VAR_DOUBLE',ncid,varid,data);
%     status = mexnc('PUT_VAR_FLOAT', ncid,varid,data);
%     status = mexnc('PUT_VAR_INT',   ncid,varid,data);
%     status = mexnc('PUT_VAR_SHORT', ncid,varid,data);
%     status = mexnc('PUT_VAR_SCHAR', ncid,varid,data);
%     status = mexnc('PUT_VAR_UCHAR', ncid,varid,data);
%     status = mexnc('PUT_VAR_TEXT',  ncid,varid,data);
%     status = mexnc('PUT_VAR1_DOUBLE',ncid,varid,start,data);

varargout = cell(1,nargout);

try
    netcdf.putVar(varargin{2:end})
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_put_var1 ( varargin )
%     status = mexnc('PUT_VAR1_DOUBLE',ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_FLOAT', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_INT',   ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_SHORT', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_SCHAR', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_UCHAR', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_TEXT',  ncid,varid,start,data);
%         These routines write a single value to the location at the given
%         starting index.
%

varargout = cell(1,nargout);

% Must switch the order of the start index.
varargin{4} = fliplr(varargin{4});

try
    netcdf.putVar(varargin{2:end})
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_put_vara ( varargin )
%     status = mexnc('PUT_VARA_DOUBLE',ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_FLOAT', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_INT',   ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_SHORT', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_SCHAR', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_UCHAR', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_TEXT',  ncid,varid,start,count,data);
%

varargout = cell(1,nargout);

% Must switch the order of the start index.
varargin{4} = fliplr(varargin{4});
varargin{5} = fliplr(varargin{5});

try
    netcdf.putVar(varargin{2:end})
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end


%------------------------------------------------------------------------------------------
function varargout = handle_put_vars ( varargin )
%     status = mexnc('PUT_VARS_DOUBLE',ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_FLOAT', ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_INT',   ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_SHORT', ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_SCHAR', ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_UCHAR', ncid,varid,start,count,stride,data);
%     status = mexnc('PUT_VARS_TEXT',  ncid,varid,start,count,stride,data);
%

varargout = cell(1,nargout);

% Must switch the order of the start, count, and stride indices.
varargin{4} = fliplr(varargin{4});
varargin{5} = fliplr(varargin{5});
varargin{6} = fliplr(varargin{6});

try
    netcdf.putVar(varargin{2:end})
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_redef ( varargin )
%      status = mexnc('REDEF',ncid);

varargout = cell(1,nargout);

try
    netcdf.redef(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end






%------------------------------------------------------------------------------------------
function varargout = handle_rename_att ( varargin )
%      status = mexnc('RENAME_ATT',ncid,dimid,name);

varargout = cell(1,nargout);

try
    netcdf.renameAtt(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end






%------------------------------------------------------------------------------------------
function varargout = handle_rename_dim ( varargin )
%      status = mexnc('RENAME_DIM',ncid,dimid,name);

varargout = cell(1,nargout);

try
    netcdf.renameDim(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end






%------------------------------------------------------------------------------------------
function varargout = handle_rename_var ( varargin )
%      status = mexnc('RENAME_VAR',ncid,varid,new_varname);

varargout = cell(1,nargout);

try
    netcdf.renameVar(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end






%------------------------------------------------------------------------------------------
function varargout = handle_set_fill ( varargin )
%      [old_fill_mode,status] = mexnc('SET_FILL',ncid,new_fill_mode)

varargout = cell(1,nargout);

try
    old_fill_mode = netcdf.setFill(varargin{2:end});
    status = 0;
catch myException
    old_fill_mode = [];
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = old_fill_mode; 
    case 2
        varargout{1} = old_fill_mode; 
        varargout{2} = status; 
        
end





%------------------------------------------------------------------------------------------
function varargout = handle_setopts ( varargin )
%      old_ncopts = mexnc('SETOPTS', ncopts)
%
% This is now a no-op.

varargout = cell(1,nargout);
if ( nargout > 0 )
    varargout{1} = 0;
end






%------------------------------------------------------------------------------------------
function varargout = handle_strerror ( varargin )
%      error_message = mexnc('STRERROR',error_code);

varargout = cell(1,nargout);

if ~isnumeric(varargin{2})
    error ( 'MEXNC:strerror:inputMustBeNumeric', 'Input to strerror must be numeric.');
end
switch ( varargin{2} )
    case 0 
        msg = 'No Error';
    case -1 
        msg = 'NC2 Error'; 

    case -33
        % #define    NC_EBADID    (-33)    
        msg = 'Not a netcdf id';

    case -34
        % #define    NC_ENFILE    (-34)    /* Too many netcdfs open */
        msg = 'NetCDF: Too many files open';

    case -35
        msg = 'NetCDF: File exists && NC_NOCLOBBER';
    case -36
        msg = 'NetCDF: Invalid argument';
    case -37
        msg = 'NetCDF: Write to read only';
    case -38
        msg = 'NetCDF: Operation not allowed in data mode';
    case -39
        msg = 'NetCDF: Operation not allowed in define mode';
    case -40
        msg = 'NetCDF: Index exceeds dimension bound';
    case -41
        msg = 'NetCDF: NC_MAX_DIMS exceeded';
    case -42
        msg = 'NetCDF: String match to name in use';
    case -43
        msg = 'NetCDF: Attribute not found';
    case -44
        msg = 'NetCDF: NC_MAX_ATTRS exceeded';
    case -45
        msg = 'NetCDF: Not a valid data type or _FillValue type mismatch';
    case -46
        msg = 'NetCDF: Invalid dimension ID or name';
    case -47
        msg = 'NetCDF: NC_UNLIMITED in the wrong index';
    case -48
        msg = 'NetCDF: NC_MAX_VARS exceeded';
    case -49
        msg = 'NetCDF: Variable not found';
    case -50
        msg = 'NetCDF: Action prohibited on NC_GLOBAL varid';
    case -51
        msg = 'NetCDF: Unknown file format';
    case -52
        msg = 'NetCDF: In Fortran, string too short';
    case -53
        msg = 'NetCDF: NC_MAX_NAME exceeded';
    case -54
        msg = 'NetCDF: NC_UNLIMITED size already in use';
    case -55
        msg = 'NetCDF: nc_rec op when there are no record vars';
    case -56
        msg = 'NetCDF: Attempt to convert between text & numbers';
    case -57
        msg = 'NetCDF: Start+count exceeds dimension bound';
    case -58
        msg = 'NetCDF: Illegal stride';
    case -59
        msg = 'NetCDF: Name contains illegal characters';
    case -60
        msg = 'NetCDF: Numeric conversion not representable';
    case -61
        msg = 'NetCDF: Memory allocation (malloc) failure';
    case -62
        msg = 'NetCDF: One or more variable sizes violate format constraints';
    case -63
        msg = 'NetCDF: Invalid dimension size';
    case -64
        msg = 'NetCDF: File likely truncated or possibly corrupted';

    otherwise
        msg = 'Unknown Error';
end
varargout{1} = msg; 



%------------------------------------------------------------------------------------------
function varargout = handle_sync ( varargin )
%      status = mexnc('SYNC',ncid );

varargout = cell(1,nargout);

try
    netcdf.sync(varargin{2:end});
    status = 0;
catch myException
    status = exception2status(myException);
end

switch nargout
    case 1
        varargout{1} = status; 
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_varget ( varargin )
%      [value, status] = mexnc('VARGET', cdfid, varid, start, count, autoscale)

error(nargchk(5,6,nargin,'struct'));

% Unless it's a char variable, we wish to return the data in double precision.
if ischar(varargin{3})
	try
    	varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
	catch me %#ok<NASGU>
    	varargout{1} = NaN;
	    varargout{2} = -1;
		return;
	end
end
tmw_args = varargin;
try
	[varname,xtype] = netcdf.inqVar(tmw_args{2:3});
catch me %#ok<NASGU>
   	varargout{1} = NaN;
    varargout{2} = -1;
	return;
end

if ( xtype ~= netcdf.getConstant('NC_CHAR'))
    tmw_args{6} = 'double';
end

% Must flip the start and count arguments.
if (nargin >= 4)
    tmw_args{4} = fliplr(tmw_args{4});
    tmw_args{5} = fliplr(tmw_args{5});
end


try
    data = netcdf.getVar(tmw_args{2:end});
    status = 0;
catch me %#ok<NASGU>
    varargout{1} = NaN;
    varargout{2} = -1;
	return;
end

if (nargin == 6) && (varargin{6} == 1)
    data = handle_nc2_output_scaling ( varargin{2}, varargin{3}, data );
end

% Permute col vectors into rows.  Why?  Well, that's just the way that it was done.
if (ndims(data) == 2) && (size(data,2) == 1)
    data = data';   
end

switch nargout
    case 1
        varargout{1} = data;
    case 2
        varargout{1} = data;
        varargout{2} = status;
end


%------------------------------------------------------------------------------------------
function varargout = handle_varputg ( varargin )
%      status = mexnc('VARPUTG', cdfid, varid, start, count, stride, [], value, autoscale)

error(nargchk(8,9,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end


switch(class(varargin{8}))
    case { 'double', 'char' }
        
    otherwise
        error('MEXCDF:mexnc:badDatatype', ...
              'VARPUTG required either double or char data.' );
end



% Scale the input if necessary.
if (nargin == 9) && (varargin{9} == 1)
    varargin{8} = handle_nc2_input_scaling ( varargin{2}, varargin{3}, varargin{8} );
end

% Must flip the start and count arguments.
if (nargin >= 4)
    varargin{4} = fliplr(varargin{4});
    varargin{5} = fliplr(varargin{5});
    varargin{6} = fliplr(varargin{6});
end

% Skip over that empty argument.  Would have been the imap thingie.
varargin = varargin([2:6 8]);

try
    netcdf.putVar(varargin{:});
    status = 0;
catch %#ok<CTCH>
    status = 1;
end

switch nargout
    case 1
        varargout{1} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_vargetg ( varargin )
%      [value, status] = mexnc('VARGETG', cdfid, varid, start, count, stride, [], autoscale)

error(nargchk(6,8,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

% Unless it's a char variable, we wish to return the data in double precision.
tmw_args = varargin(2:6);
[varname,xtype] = netcdf.inqVar(varargin{2:3});
if ( xtype ~= netcdf.getConstant('NC_CHAR'))
    tmw_args{6} = 'double';
end

% Must flip the start and count arguments.
if (nargin >= 4)
    tmw_args{3} = fliplr(tmw_args{3});
    tmw_args{4} = fliplr(tmw_args{4});
    tmw_args{5} = fliplr(tmw_args{5});
end

try
    data = netcdf.getVar(tmw_args{:});
    status = 0;
catch %#ok<CTCH>
    data = NaN;
    status = -1;
end

if (nargin == 8) && (varargin{8} == 1)
    data = handle_nc2_output_scaling ( varargin{2}, varargin{3}, data );
end

% Permute col vectors into rows.  Why?  Well, that's just the way that it was done.
if (ndims(data) == 2) && (size(data,2) == 1)
    data = data';   
end

switch nargout
    case 1
        varargout{1} = data;
    case 2
        varargout{1} = data;
        varargout{2} = status;
end

%------------------------------------------------------------------------------------------
function status = exception2status ( myException )
% Translate an exception to an error status.
% The netcdf package issues exceptions when there is an error condition, but mexnc expects
% status numbers.

switch ( myException.identifier )
    case {'MATLAB:badfilename_mx', ...
          'MATLAB:nargchk:notEnoughInputs', ...
          'MATLAB:netcdf:argumentWasNotChar', ...
          'MATLAB:netcdf:badArgumentDatatype', ...
          'MATLAB:netcdf:badIDDatatype', ...
          'MATLAB:netcdf:badModeDatatype', ...
          'MATLAB:netcdf:badSizeArgumentDatatype', ...
          'MATLAB:netcdf:countArgumentHasBadDatatype', ...
          'MATLAB:netcdf:emptySetID', ...
          'MATLAB:netcdf:pCreate:invalidArgument', ...
          'MATLAB:netcdf:startArgumentHasBadDatatype', ...
          'MATLAB:netcdf:strideArgumentHasBadDatatype', ...
          'MATLAB:netcdf:getVar:badDatatypeSpecification', ...
          'MATLAB:netcdf:getVara:indexExceedsDimensionBound', ...
          'MATLAB:netcdf:open:notANetcdfFile', ...
          'MATLAB:netcdf:putVar:dataSizeMismatch', ...
          'MATLAB:netcdf:putVar1:dataSizeMismatch', ...
          'MATLAB:netcdf:putVara:dataSizeMismatch', ...
          'MATLAB:netcdf:putVars:dataSizeMismatch', ...
          'MATLAB:netcdf:putVar:indexExceedsDimensionBound', ...
          'MATLAB:netcdf:putVar1:indexExceedsDimensionBound', ...
          'MATLAB:netcdf:putVara:indexExceedsDimensionBound', ...
          'MATLAB:netcdf:putVars:indexExceedsDimensionBound', ...
          'MATLAB:netcdf:putVar1:startPlusCountExceedsDimensionBound', ...
          'MATLAB:netcdf:putVara:startPlusCountExceedsDimensionBound', ...
          'MATLAB:netcdf:putVars:startPlusCountExceedsDimensionBound', ...
          'MATLAB:netcdf_common:unpackDimids:badDimidsType', ...
          'MATLAB:netcdf_common:ndimsLargerThanNetcdfLimits', ...
          'MATLAB:netcdf_common:unpack_ndims_and_dimids:badDimidsType', ...
          'MATLAB:netcdf_common:unpackIntSingleton:argumentIsEmptySet', ...
          'MATLAB:netcdf_common:unpack_xtype:emptySetDatatype', ...
          'MATLAB:netcdf:emptySetSizeParameter', ...
          'MATLAB:netcdf:emptySetParameter', ...
          'MATLAB:netcdf:unrecognizedCharParameter', ...
          'MATLAB:unassignedOutputs'}
        rethrow ( myException );

    case 'MATLAB:netcdf:open:noSuchFile'
        status = 2;
        return


    % NC2 error
    case {'MATLAB:netcdf:negativeSize'}
        status = -1;
        return

    
    % This was a bad error ID in R2008b and R2009a.  Nothing we can do but 
    % to return -1.
    case {'MATLAB:netcdf:putAttText'}
        status = -1;
        return

end

% All cases where the input argument count was bad should be real errors.
if ~isempty(regexp(myException.identifier,':badInputArgumentCount', 'once'))
    rethrow ( myException );
end

% Special case.
% Now look at particular releases where we know there is an issue.
switch version('-release')
    case '2008b'
        if ( strcmp(myException.identifier,'MATLAB:netcdf:create:unknownErrorStatus') && ...
            strcmp(myException.message,'Invalid argument') )
            status = netcdf.getConstant('NC_EINVAL');
            return
        end
        if ( strcmp(myException.identifier,'MATLAB:netcdf:pCreate:unknownErrorStatus') && ...
            strcmp(myException.message,'Invalid argument') )
            status = netcdf.getConstant('NC_EINVAL');
            return
        end
end


if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:notNetcdfID', 'once'))
    status = netcdf.getConstant('NC_EBADID');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:operationNotAllowedInDefineMode', 'once'))
    status = netcdf.getConstant('NC_ENOTINDEFINE');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:invalidDimensionIdOrName', 'once'))
    status = netcdf.getConstant('NC_EBADDIM');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:nameContainsIllegalCharacters', 'once'))
    status = netcdf.getConstant('NC_EBADNAME');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:attemptToConvertBetweenTextAndNumbers', 'once'))
    status = netcdf.getConstant('NC_ECHAR');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:netcdfFileExistsAndNoClobber', 'once'))
    status = netcdf.getConstant('NC_EEXIST');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:invalidArgument', 'once'))
    status = netcdf.getConstant('NC_EINVAL');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:nameIsAlreadyInUse', 'once'))
    status = netcdf.getConstant('NC_ENAMEINUSE');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:operationNotAllowedInDataMode', 'once'))
    status = netcdf.getConstant('NC_ENOTINDEFINE');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:attributeNotFound', 'once'))
    status = netcdf.getConstant('NC_ENOTATT');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:variableNotFound', 'once'))
    status = netcdf.getConstant('NC_ENOTVAR');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:onlyOneUnlimitedDimensionAllowed', 'once'))
    status = netcdf.getConstant('NC_EUNLIM');
    return
end
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:.*:unlimitedDimensionInTheWrongIndex', 'once'))
    status = netcdf.getConstant('NC_UNLIMPOS');
    return
end

%
% These exceptions 
if ~isempty(regexp(myException.identifier,'MATLAB:netcdf:abort:', 'once'))
    status = -1;
    return
end

% 
% If we get this far, then we know that something has not been properly handled.
myException %#ok<NOPRT>
myException.stack(1)
myException.stack(end)
error('Encountered an unhandled exception.');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = handle_nc2_input_scaling(ncid,varid,data)
% HANDLE_NC2_INPUT_SCALING
%     If there is a scale factor and/or  add_offset attribute, convert the data
%     to double precision and apply the scaling.
%

try
    scale_factor = netcdf.getAtt(ncid,varid,'scale_factor');
catch me %#ok<NASGU>
    scale_factor = 1.0;
end

try
    add_offset = netcdf.getAtt(ncid,varid,'add_offset');
catch me %#ok<NASGU>
    add_offset = 0.0;
end

data = (double(data) - add_offset) / scale_factor + 0.5;


return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% HANDLE_NC2_OUTPUT_SCALING
%     If there is a scale factor and/or  add_offset attribute, convert the data
%     to double precision and apply the scaling.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function values = handle_nc2_output_scaling ( ncid, varid, values )

try
    scale_factor = netcdf.getAtt(ncid,varid,'scale_factor');
catch me %#ok<NASGU>
    scale_factor = 1.0;
end
try
    add_offset = netcdf.getAtt(ncid,varid,'add_offset');
catch me %#ok<NASGU>
    add_offset = 0.0;
end

values = double(values) * scale_factor + add_offset;



%------------------------------------------------------------------------------------------
% NetCDF-2 functions.
%------------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------------
function varargout = handle_attcopy ( varargin )
%     status = mexnc('COPY_ATT',ncid_in,varid_in,attname,ncid_out,varid_out);
%      status = mexnc('ATTCOPY', incdf, invar, 'name', outcdf, outvar)

varargout = cell(1,nargout);

status = handle_copy_att(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_attdel ( varargin )
%      status = mexnc('ATTDEL', cdfid, varid, 'name')
%     status = mexnc('DEL_ATT',ncid,varid,attname);

varargout = cell(1,nargout);

status = handle_del_att(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_attget ( varargin )
%     [att_value,status] = mexnc('GET_ATT_DOUBLE',ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_FLOAT', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_INT',   ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_SHORT', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_SCHAR', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_UCHAR', ncid,varid,attname);
%     [att_value,status] = mexnc('GET_ATT_TEXT',  ncid,varid,attname);
%      [value, status] = mexnc('ATTGET', cdfid, varid, 'name')

error(nargchk(4,4,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

varargout = cell(1,nargout);

% NETCDF-2 only returned double precision or char attributes.
xtype = netcdf.inqAtt(varargin{2:end});
if ( xtype == netcdf.getConstant('NC_CHAR') )
    op = 'GET_ATT_TEXT';
else
    op = 'GET_ATT_DOUBLE';
end
varargin{1} = op;

[varargout{:}] = handle_get_att(varargin{:});
if (nargout == 2) && (varargout{2} ~= 0)
    varargout{2} = -1;
end




%------------------------------------------------------------------------------------------
function varargout = handle_attinq ( varargin )
%      [datatype, len, status] = mexnc('ATTINQ', cdfid, varid, 'name')
%     [datatype,attlen,status] = mexnc('INQ_ATT',ncid,varid,attname);

varargout = cell(1,nargout);

[xtype,attlen,status] = handle_inq_att(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = xtype;
    case 2
        varargout{1} = xtype;
        varargout{2} = attlen;
    case 3
        varargout{1} = xtype;
        varargout{2} = attlen;
        varargout{3} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_attname ( varargin )
%     [attname,status] = mexnc('INQ_ATTNAME',ncid,varid,attid);
%      [name, status] = mexnc('ATTNAME', cdfid, varid, attnum)

varargout = cell(1,nargout);

[attname,status] = handle_inq_attname(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = attname;
    case 2
        varargout{1} = attname;
        varargout{2} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_attput ( varargin )
%      status = mexnc('ATTPUT', cdfid, varid, 'name', datatype, value) 
%      status = mexnc('ATTPUT', cdfid, varid, 'name', datatype, len, value) 

error(nargchk(6,7,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

% Don't need the length.
varargout = cell(1,nargout);
if ( nargin == 7 )
    varargin = varargin([1:5 7]);
end

if ischar(varargin{5})
    xtype = lower(varargin{5});
    switch xtype
        case 'byte'
            varargin{5} = nc_byte;
        case 'char'
            varargin{5} = nc_char;
        case 'short'
            varargin{5} = nc_short;
        case {'int', 'long'}
            varargin{5} = nc_int;
        case 'float'
            varargin{5} = nc_float;
        case 'double'
            varargin{5} = nc_double;
        otherwise
            error('MEXNC:handle_attput:unhandledDatatype', ...
                  '%s is not a recognized datatype.', xtype );
    end
end
% Must cast the data to the intended datatype.
if (( varargin{5} == 1 ) && ~(isa(varargin{6},'uint8') || isa(varargin{6},'int8')))
    varargin{6} = int8(varargin{6});
elseif ( varargin{5} == 3 ) && ~isa(varargin{6},'int16')
    varargin{6} = int16(varargin{6});
elseif ( varargin{5} == 4 ) && ~isa(varargin{6},'int32')
    varargin{6} = int32(varargin{6});
elseif ( varargin{5} == 5 ) && ~isa(varargin{6},'single')
    varargin{6} = single(varargin{6});
elseif ( varargin{5} == 6 ) && ~isa(varargin{6},'double')
    varargin{6} = double(varargin{6});
end

status = handle_put_att(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_attrename ( varargin )
%      status = mexnc('ATTRENAME', cdfid, varid, 'name', 'newname')
%     status = mexnc('RENAME_ATT',ncid,varid,old_attname,new_attname);

status = handle_rename_att(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_dimdef ( varargin )
%      status = mexnc('DIMDEF', cdfid, 'name', length)
%      [dimid,status] = mexnc('DEF_DIM',ncid,name,length);

[dimid,status] = handle_def_dim(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = dimid;
    case 2
        varargout{1} = dimid;
        varargout{2} = status;
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_dimid ( varargin )
%      [dimid,status] = mexnc('INQ_DIMID',ncid,name);
%      [dimid, rcode] = mexnc('DIMID', cdfid, 'name')

[dimid,status] = handle_inq_dimid(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = dimid;
    case 2
        varargout{1} = dimid;
        varargout{2} = status;
        
end



%------------------------------------------------------------------------------------------
function varargout = handle_diminq ( varargin )
%      [name, length, status] = mexnc('DIMINQ', cdfid, dimid)
%      [name, length,status] = mexnc('INQ_DIM',ncid,dimid);

[name,dimlen,status] = handle_inq_dim(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = name;
    case 2
        varargout{1} = name;
        varargout{2} = dimlen;
    case 3
        varargout{1} = name;
        varargout{2} = dimlen;
        varargout{3} = status;
        
end




%------------------------------------------------------------------------------------------
function varargout = handle_dimrename ( varargin )
%      status = mexnc('DIMRENAME', cdfid, 'name')
%      status = mexnc('RENAME_DIM',ncid,dimid,name);

status = handle_rename_dim(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
end



%------------------------------------------------------------------------------------------
function varargout = handle_endef ( varargin )
%      status = mexnc('ENDEF', cdfid)
%      status = mexnc('ENDDEF',ncid);

status = handle_enddef(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
end




%----------------------------------------------------------------
function varargout = handle_typelen(varargin)
%      len = mexnc('TYPELEN', datatype)

switch ( varargin{2} )
    case 0
        len = -1;
        status = 1;
    case 1
        len = 1;
        status = 0;
    case 2
        len = 1;
        status = 0;
    case 3
        len = 2;
        status = 0;
    case 4
        len = 4;
        status = 0;
    case 5
        len = 4;
        status = 0;
    case 6
        len = 8;
        status = 0;
    otherwise
        len = -1;
        status = 1;
end


switch nargout
    case 1
        varargout{1} = len;
    case 2
        varargout{1} = len;
        varargout{2} = status;
end





%----------------------------------------------------------------
function varargout = handle_inquire(varargin)
%      [ndims, nvars, natts, recdim, status] = mexnc('INQUIRE', cdfid)
%      [ndims,nvars, ngatts, unlimdim, status] = mexnc('INQ',ncid);

global use_tmw;

% Get all five outputs.
if use_tmw
    [ndims,nvars,ngatts,unlimdim,status] = handle_inq(varargin{:});
else
    [ndims,nvars,ngatts,unlimdim,status] = mexnc('INQ',varargin{2:end});
end

switch nargout
    case 1
        % In this case, return all the outputs as a single vector.
        % This is special to this function only.
        varargout{1}(1) = ndims;
        varargout{1}(2) = nvars;
        varargout{1}(3) = ngatts;
        varargout{1}(4) = unlimdim;
        varargout{1}(5) = status;

    case 2
        varargout{1} = ndims;
        varargout{2} = nvars;
    case 3
        varargout{1} = ndims;
        varargout{2} = nvars;
        varargout{3} = ngatts;
    case 4
        varargout{1} = ndims;
        varargout{2} = nvars;
        varargout{3} = ngatts;
        varargout{4} = unlimdim;
    case 5
        varargout{1} = ndims;
        varargout{2} = nvars;
        varargout{3} = ngatts;
        varargout{4} = unlimdim;
        varargout{5} = status;
end









%------------------------------------------------------------------------------------------
function varargout = handle_vardef ( varargin )
%      [varid,status] = mexnc('DEF_VAR',ncid,name,xtype,dimids);
%      [varid,status] = mexnc('DEF_VAR',ncid,name,xtype,ndims,dimids);
%      status = mexnc('VARDEF', cdfid, 'name', datatype, ndims, [dim])

% Don't pass ndims, but tell the user if they are wrong!
% Stupid netcdf toolbox let users pass -1 as the length.
% if ndims is 0, don't bother checking it against the number of elements.
nc2args = varargin(1:4);
if (varargin{5} == 0)
    % Stupid user.  They are saying that the number of dimensions is zero, yet they
    % give a list of dimension IDS.  We assume they really meant zero dimensions.
    nc2args{5} = [];
elseif (varargin{5} == -1)
    % Stupid user.  -1 is their way of saying to compute the number of dimensions
    % for me.  TMW already does this automatically
    nc2args{5} = varargin{6};
elseif (varargin{5} ~= numel(varargin{6})) 
    error('MEXNC:handle_def_var:numDimsMismatch', ...
          'The given number of dimensions was not the same as the length of the dimids.');
else
    nc2args{5} = varargin{6};
end

[varid,status] = handle_def_var(nc2args{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = varid;
    case 2
        varargout{1} = varid;
        varargout{2} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_varid ( varargin )
%      [varid,status] = mexnc('INQ_VARID',ncid,varname);
%      [varid, rcode] = mexnc('VARID', cdfid, 'name')

[varid,status] = handle_inq_varid(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = varid;
    case 2
        varargout{1} = varid;
        varargout{2} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_varinq ( varargin )
% [name, datatype, ndims, dimids, natts, status] = mexnc('VARINQ', cdfid, varid)
% [varname,xtype,  ndims, dimids, natts, status] = mexnc('INQ_VAR',ncid,varid);

[varname,xtype,ndims,dimids,natts,status] = handle_inq_var(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = varname;
    case 2
        varargout{1} = varname;
        varargout{2} = xtype;
    case 3
        varargout{1} = varname;
        varargout{2} = xtype;
        varargout{3} = ndims;
    case 4
        varargout{1} = varname;
        varargout{2} = xtype;
        varargout{3} = ndims;
        varargout{4} = dimids;
    case 5
        varargout{1} = varname;
        varargout{2} = xtype;
        varargout{3} = ndims;
        varargout{4} = dimids;
        varargout{5} = natts;
    case 6
        varargout{1} = varname;
        varargout{2} = xtype;
        varargout{3} = ndims;
        varargout{4} = dimids;
        varargout{5} = natts;
        varargout{6} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_varrename ( varargin )
%      status = mexnc('VARRENAME', cdfid, varid, 'name')
%      status = mexnc('RENAME_VAR',ncid,varid,new_varname);

status = handle_rename_var(varargin{:});
if status ~= 0
    status = -1;
end
switch nargout
    case 1
        varargout{1} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_varput1 ( varargin )
%     status = mexnc('VARPUT1',        ncid,varid,start,value, autoscale)
%
%     status = mexnc('PUT_VAR1_DOUBLE',ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_FLOAT', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_INT',   ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_SHORT', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_SCHAR', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_UCHAR', ncid,varid,start,data);
%     status = mexnc('PUT_VAR1_TEXT',  ncid,varid,start,data);

error(nargchk(5,6,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

switch(class(varargin{5}))
    case { 'double', 'char' }
        
    otherwise
        error('MEXCDF:mexnc:badDatatype', ...
              'VARPUT1 required either double or char data.' );
end

% Scale the input if necessary.
if (nargin == 6) && (varargin{6} == 1)
    varargin{5} = handle_nc2_input_scaling ( varargin{2}, varargin{3}, varargin{5} );
    varargin = varargin(1:5);
end

% Must flip the start and count arguments.
if (nargin >= 4)
    varargin{4} = fliplr(varargin{4});
end

try
    netcdf.putVar(varargin{2:5});
    status = 0;
catch %#ok<CTCH>
    status = 1;
end

switch nargout
    case 1
        varargout{1} = status;
end




%------------------------------------------------------------------------------------------
function varargout = handle_varget1 ( varargin )
%      [value, status] = mexnc('VARGET1', cdfid, varid, coords, autoscale)
%     [data,status] = mexnc('GET_VAR1_DOUBLE',ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_FLOAT', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_INT',   ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_SHORT', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_SCHAR', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_UCHAR', ncid,varid,start);
%     [data,status] = mexnc('GET_VAR1_TEXT',  ncid,varid,start);

error(nargchk(4,5,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

% Make sure we only return double or char data.
try
    [varname,xtype] = netcdf.inqVar(varargin{2}, varargin{3});
    if ( xtype == netcdf.getConstant('NC_CHAR') )
        output_type = 'char';
    else
        output_type = 'double';
    end
catch %#ok<CTCH>
    varargout{1} = NaN;
    varargout{2} = -1;
    return;
end

try
    data = netcdf.getVar(varargin{2:4},output_type);
    status = 0;
catch %#ok<CTCH>
    data = NaN;
    status = -1;
end

% Must flip the start and count arguments.
if (nargin >= 4)
    varargin{4} = fliplr(varargin{4});
end


if (nargin == 5) && (varargin{5} == 1)
    data = handle_nc2_output_scaling ( varargin{2}, varargin{3}, data );
end

switch nargout
   case 1
        varargout{1} = data;
    case 2
        varargout{1} = data;
        varargout{2} = status;
end

%------------------------------------------------------------------------------------------
function varargout = handle_varput ( varargin )
%      status = mexnc('VARPUT', cdfid, varid, start, count, value, autoscale)
%     status = mexnc('PUT_VARA_DOUBLE',ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_FLOAT', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_INT',   ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_SHORT', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_SCHAR', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_UCHAR', ncid,varid,start,count,data);
%     status = mexnc('PUT_VARA_TEXT',  ncid,varid,start,count,data);

error(nargchk(6,7,nargin,'struct'));

if ischar(varargin{3})
    varargin{3} = netcdf.inqVarId(varargin{2},varargin{3});
end

switch(class(varargin{6}))
    case { 'double', 'char' }
        
    otherwise
        error('MEXCDF:mexnc:badDatatype', ...
              'VARPUT required either double or char data.' );
end

% Scale the input if necessary.
if (nargin == 7) && (varargin{7} == 1)
    varargin{6} = handle_nc2_input_scaling ( varargin{2}, varargin{3}, varargin{6} );
end


% Must flip the start and count arguments.
if (nargin >= 4)
    varargin{4} = fliplr(varargin{4});
    varargin{5} = fliplr(varargin{5});
end

try
    netcdf.putVar(varargin{2:6});
    status = 0;
catch %#ok<CTCH>
    status = 1;
end

switch nargout
    case 1
        varargout{1} = status;
end



