% FUNCTION   [comp_var]=comp_vars(files,'varname');
%
% Make a compisite netcdf variable for the time
% index of the specified 'varname'.
% INPUT:
%
%    files : cell array with the name
%            of the files that containing the
%            'varname' variable to concatenate.
% example: files={ 'file1.nc' 'file2.nc' ...}
%
%   'varname' : string with the name of the variable
%
% SEE ALSO:  comp_ncsize

function [self]=comp_vars(files,fields);
  
  
  % convert fields into a cell array for now
  % maybe in the future it will be a cell array
  % with many variables name to comp.
  if isa(fields, 'cell') ~= 1
    fields={fields};
  end
  
  
  for ifield = 1:length(fields);
    i=0;
    self = ncvar;
    for ifile=1:length(files);
      i=i+1;
      file=files{ifile};
      nc=netcdf(file);
      theVars=nc{ fields{ifield} };
      
      varsize=ncsize(theVars);
      t=varsize(1);
      dt= 1+t*(i-1) : t*i;
      t=1:t;
      theSrcsubs(1)={ t };
      theDstsubs(1)={ dt};
      
      % other indicies stay the same
      for j=2:length(varsize)
        tmp = 1:varsize(j);
        theSrcsubs(j)= {tmp};
        theDstsubs(j)= {tmp};
      end
      
      
      self.itsVars{i} = theVars;
      self.itsSrcsubs{i} = theSrcsubs;
      self.itsDstsubs{i} = theDstsubs;
    end
    %assignin('base',fields{ifield},self);
  end
  
  
  

