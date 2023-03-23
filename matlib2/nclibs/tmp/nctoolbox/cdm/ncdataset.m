% NCDATASET  Provide access to datasets accessable by the NetCDF 4 API
%
% Use as:
%   ds = ncdataset(dataref)
%
% Arguments:
%   dataref = A reference to a ncdataset that can be accessed by the NetCDF 4
%       API. This includes local netcdf files, netcdf files on web servers 
%       and OpenDAP URLs
%
% Return:
%   An instance of a ncdataset class
%
% Properties:
%   netcdf = For power users. This is an instance of 
%       a ucar.nc2.ncdataset.NetcdfDataset (NetCDF-Java 4.0) and
%       is used for the underlying data access. This object can
%       be tweaked as needed. (For example, to enable/disable
%       data caching.) See 
%       http://www.unidata.ucar.edu/software/netcdf-java/v4.0/javadoc/index.html
%   variables = A cell array of all variables in the ncdataset. These names
%        are used as arguments into other ncdataset methods
%
% Methods:
%   ncdataset.axes - access coordinate variable names for a given variable
%   ncdataset.attributes - access global or variable attributes
%   ncdataset.data - retrieve data (or a subset of data) for a variable
%   ncdataset.size - returns the size of a variable in the data store
%   ncdataset.time - Attempt to convert a variable to matlabs native time format (see datenum)
%
% For more information on the methods use help. For example:
%   >> help ncdataset.data
%
% Example:
%   ds = ncdataset('http://dods.mbari.org/cgi-bin/nph-nc/data/ssdsdata/deployments/m1/200810/m1_metsys_20081008_original.nc')
%   ga = ds.attributes;       % Global Attributes
%   sv = 'SonicVelocity';     % A variable that we're interested in.
%   d = ds.data(sv);          % Data for the SonicVelocity variable
%   svAx = ds.axes(sv);       % Coordinate Variable names for the SonicVelocity variable
%   svAt = ds.attributes(sv); % Attributes for SonicVelocity

% Brian Schlining (brian@mbari.org)
% 2009-05-12
classdef ncdataset < handle

    properties (SetAccess = private)
        netcdf          % ucar.nc2.ncdataset.NetcdfDataset java instance
        variables       % cell array containing the variable names as strings in netcdf
    end

    methods
        
        %%
        function obj = ncdataset(url)
            % NCDATASET  Constructor. Instantiates a NetcdfDataset pointing to the 
            % datasource specified by 'url' and uses that as the underlying
            % dataaccess API. When instantiated, the names of all variables
            % are fetched and stored in the 'variables' property. This can be
            % use to open local files, files stored on an HTTP server and 
            % OpenDAP URLs.
            
            try
                obj.netcdf = ucar.nc2.dataset.NetcdfDataset.openDataset(url);

                % Fetches the names of all variables from the netcdf ncdataset
                % and stores them in a cell array
                vars = obj.netcdf.getVariables();
                n = size(vars);
                obj.variables = cell(n, 1);
                for i = 1:(n)
                    obj.variables{i, 1} = char(vars.get(i - 1).getName());
                end

            catch me
                ex = MException('NCDATASET:ncdataset', ['Failed to open ' url]);
                ex = ex.addCause(me);
                ex.throw;
            end
        end
        
        %%
        function s = size(obj, variable)
            % NCDATASET.SIZE  Returns the size of the variable in the persistent store 
            % without fetching the data. Helps to know what you're getting yourself
            % into. ;-)
            %
            % Use as:
            %   ds = ncdataset('http://dods.mbari.org/cgi-bin/nph-nc/data/ssdsdata/deployments/m1/200810/m1_metsys_20081008_original.nc')
            %   s = ds.size(variableName)
            %
            % Arguments:
            %   variableName = The name of the variable who's size you wish to query
            %
            % Return:
            %   The size of the data for the variable. Includes all dimensions,
            %   even the singleton dimensions
            
            v = obj.netcdf.findVariable(variable);
            s = v.getShape()';
        end
        
        %%
        function d = data(obj, variable, first, last, stride)
            % NCDATASET.DATA  Fetch the data for a given variable. This methods 
            % also allows you to fetch subsets of the data by specifiying a
            % the index of the first and last points as well as a stride (or 
            % spacing)
            %
            % Use as:
            %   ds = ncdataset('http://dods.mbari.org/cgi-bin/nph-nc/data/ssdsdata/deployments/m1/200810/m1_metsys_20081008_original.nc')
            %   d = ds.data(variableName)
            %   d = ds.data(variableName, first)
            %   d = ds.data(variableName, first, last)
            %   d = ds.data(variableName, first, last, stride)
            %
            % Arguments:
            %   variableName = The name of the variable whos data you want to retrieve
            %   first = The first point you want to retrieve (first point idx = 1)
            %   last  = THe last point you want to retrive (default is the end of
            %       the data array)
            %   stride = The stride spacing (default is 1)
            %   NOTE! first, last, and stride must be matrices the same size as the 
            %       matrix returned by NCDATASET.SIZE
            %
            % Return:
            %   The data from the variable. The data will be returned in the
            %   matlab type that nearest corresponds to the variables data 
            %   type in the data store. For most Matlab operations you will
            %   need to convert the data to double precision. Here's an example:
            %     ds = ncdataset('/Volumes/oasis/m1/netcdf/m1_adcp_20051020_longranger.nc')
            %     u = ds.data('u_component_uncorrected'); % u is a matlab 'single' type
            %     u = double(u) % promote single to double precision
            
            v = obj.netcdf.findVariable(variable);
            
            if (nargin == 2)
                array = v.read();
                d = array.copyToNDJavaArray();
            else
                s = obj.size(variable);
                
                % Fill in missing arguments
                % default stride is 1
                if (nargin < 5)
                    stride = ones(1, length(s));
                end
                
                % Default last is the end 
                if (nargin < 4)
                    last = s;
                end
                
                % Construct the range objects needed to subset the data
                n = max(size(obj.size(variable)));
                ranges = java.util.ArrayList(n);
                for i = 1:n
                    ranges.add(ucar.ma2.Range(first(i) - 1, last(i) - 1, stride(i)));
                end
                
                array = v.read(ranges);
                d = array.copyToNDJavaArray();
            end
        end
        

        %%
        function cv = axes(obj, variable)
            % NCDATASET.AXES  Returns a cell array containing the variable names of
            % coordinate axes for the given variable
            %
            % Use as: 
            %   ds = ncdataset('http://dods.mbari.org/cgi-bin/nph-nc/data/ssdsdata/deployments/m1/200810/m1_metsys_20081008_original.nc')
            %   ax = ds.axes(variableName);
            %
            % Inputs:
            %   variableName = the name of the variable whos axes you want to retrieve
            %
            % Return:
            %   An (n, 1) cell array containing the names (in order) of the variable
            %   names representing the coordinate axes for the specified variableName.

            v = obj.netcdf.findVariable(variable);
            dims = v.getDimensions();
            cv = cell(dims.size(), 1);
            for i = 1:dims.size();
                ca = obj.netcdf.findCoordinateAxis(dims.get(i - 1).getName());
                if ~isempty(ca)
                    cv{i} = char(ca.getName());
                end
            end

        end

        %%
        function a = attributes(obj, variable)
            % NCDATASET.ATTRIBUTES returns the attributes of the variable as an
            % n x 2 cell array. 
            %
            % Use as:
            %   a = ncdataset.attributes
            %   a = ncdataset.attributes(variableName)
            %
            % Inputs:
            %   variableName = The name of the variable whos attributes you want
            %       to retrieve. If no argument is specified then the 
            %       global attributes are returned.
            %
            % Return:
            %   An (n, 2) cell array. The 1st column contains the attribute name
            %   The 2nd column contains the attribute value. Each row is essentially
            %   a key-value pair.
            %
            % Hints:
            %   Here's how to obtain cell arrays of the keys and corresponding values
            %   and search for a particular key (or attribute name)
            %     ds = ncdataset('http://somewhere/data.nc');
            %     attr = ds.attributes('time');
            %     keys = attr(:, 1);    % Cell array of keys
            %     values = attr(:, 2);  % Cell array of values
            %     i = find(ismember(keys, 'units')); % search for units attribute
            %     units = values{i};  % Retrieve the units value
            if (nargin < 2)
                % Get global attributes
                aa = obj.netcdf.getGlobalAttributes();
            else
                % Get attributes for the variable
                v = obj.netcdf.findVariable(variable);
                if isempty(v)
                    warning('MBARI:NCDATASET', ['Could not find the variable ' variable]);
                end
                aa = v.getAttributes();
            end
            
            if ~isempty(aa)
                n = aa.size();
                a = cell(n, 2);
                for i = 1:n
                    at = aa.get(i - 1);
                    a{i, 1} = char(at.getName());
                    if (at.isString())
                        a{i, 2} = char(at.getStringValue());
                    else 
                        a{i, 2} = at.getValues().copyToNDJavaArray(); 
                    end
                end
            else
                % Show warning, return empty cell array
                warning('NCDATASET:attributes', 'No attributes were found');
                a = cell(1, 2);
            end
        end

        %%
        function t = time(obj, variable, data)
            % NCDATASET.TIME  Attempts to convert data to Matlab's native time format
            %
            % Use as:
            %   t = obj.time(variableName)
            %   t = obj.time(variableName, data)
            %
            % Arguments:
            %   variableName = The name of the variable you're trying to convert.
            %       This is needed in order to fetch information about the variable.
            %       Currently, this method depends on the presence of a
            %       variable attribute named 'units'.
            %   data = the data you're trying to convert. If not provided then
            %       all the data for the given variableName is fetched and converted.
            %       It's useful to supply the data when you are working with 
            %       a subset of the data.
            [conversion offset] = timeunits(obj, variable);
            if nargin < 3
                data = obj.data(variable);
            end
            t = data * conversion + offset;
        end

    end

end

%%
function [conversion, offset] = timeunits(obj, variable)
    % TIMEUNITS  Determines the conversion and offset needed to transform
    %   data to time from the variables units
    %
    % Use as: 
    %   [conversion, offset] = timeunits(obj, variable)
    %
    % Arguments:
    %   obj = A ncdataset instance
    %   variable = The name of the time variable
    %
    % Return:
    %   conversion = The conversion factor (multiplier) from the variables
    %       units to matlabs units.
    %   offset = The time offset from Matlab's time base in days
    %
    % NOTE: THis is naive implementation that looks for  aunit attribute on the
    % variable with a value in the form of '[time unit] since [some date]'
    attr = obj.attributes(variable);
    keys = attr(:, 1);
    values = attr(:, 2);
    i = find(ismember(keys, 'units'));         % search for units attribute
    units = lower(values{i});                  % Retrieve the units value
    
    
    
    % Figure out the conversion from the time units to days (matlabs time units)
    conversion = 1;
    unitPatterns = {'milli', 'sec', 'minute', 'hour', 'day', 'year'};
    conversions = [1 / (1000 * 60 * 60 * 24), 1 / (60 * 60 * 24), 1 / (60 * 24), 1 /24, 1, 365.25];
    for i = 1:length(unitPatterns)
        timeUnit = unitPatterns{i};
        u = strfind(units, timeUnit);
        if ~isempty(u)
            conversion = conversions(i);
            break
        end
    end
    
    % Figure out the offset
    offset = 0;
    idx = regexp(units, '\d');
    if ~isempty(idx)
        startIdx = idx(1);
        endIdx = idx(end);
        dateString = units(startIdx:endIdx);
        % Try using matlabs date parsing which covers most common cases
        try 
            offset = datenum(dateString);
        catch e
            % If we're here then it's most likey an iso8601 format. We'll try one.
            try
                df = java.text.SimpleDateFormat('yyyy-MM-dd''t''HH:mm:ss');
                df.setTimeZone(java.util.TimeZone.getTimeZone('UTC'));
                jDate = df.parse(dateString);
                secs = jDate.getTime() / 1000;
                offset = utc2sdn(secs);
            catch me
                warning('NCDATASET:timeunits', ['Unable to parse date: ' dateString]);
            end
        end
    end
    
    if (conversion == 1) && (offset == 0)
        warning('NCDATASET:timeunits', ['No conversion occurred. Are you sure that ' variable ' is time data?']);
    end
    
    % fprintf(1, 'Conversion = %12.5f, Offset = %12.5f\n', conversion, offset);
    
end


