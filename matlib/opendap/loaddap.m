function values = loaddap([switches,] URL [, URL])
%--------------------------------------------------------------------
%     Copyright 1997,1998,1999,2001 (C) URI/MIT, 2005 OPeNDAP
%     $Revision: 12315 $
%
%  function values = loaddap([switches,] URL [options] [, URL [options]])
%
% DESCRIPTION:
%  
%  loaddap is an interface to DAP2-compliant data servers such for Matlab 
%  5, 6 and 7. loaddap should be called with a
%  DAP URL which references data, in which case the command will access the
%  dataset and create scalars, vectors and/or matrices in Matlab to hold
%  those data. 
%  
%  loaddap used to be limited to scalar, vector and matrix (2D) data.
%  However, starting with version 3.1.3, loaddap can intern N-dimensional
%  objects. 
%
% SWITCHES:
%  -e: Use the new error reporting scheme (see the description under Notes).
%  -w: Print warning messages.
%  -v: Verbose output (on by default, use +v to disable).
%  -V: Print version information for loaddap and any programs it uses.
%  -F: Force all string variables to be translated to float.
%  -A: Access the dataset's DAS object.
%  -k: Concatenate like-named variables. Only tested for N=1,2.
%  -n: Use the full name of a variable. (An old option; this is the default.)
%  -s: Return a vector of variable names along with the variables themselves.
%
% PER URL OPTIONS:
%  -r: Rename a variable. Usage: `-r <var>:<new name>'.
%  -c: Supply a constraint without using the `?' notation. Usage `-c <expr>'.
%
%  The `-r' option provides a way to rename variables so that variables read
%  will not overwrite ones already present in a Matlab session.
%
%  Notes:
%  The options are all off by default except for `-v' which is on by default.
%          
%  The `-e' option turns on the new (4/20/99) error reporting scheme. Using
%  this scheme, errors are signaled to the caller by setting the Matlab
%  variable `dods_err' to one. If dods_err is set, then error message text
%  may be found in the Matlab string variable dods_err_msg. Error messages
%  take the form <function name>: <text> where there are no spaces in
%  <function name>: so that a simple scanner can remove that from the string.
%  There may be several error messages in dods_err_msg if the error was first
%  reported from a nested call. In that case the first error message will be
%  from the point in the program where the error was first detected (and is
%  likely the most accurate description of the problem). However, the chain
%  of calls may be useful in diagnosing the problem. Multiple error messages
%  in dods_err_msg are separated by newlines.
%
%  The `-k' command switch concatenates two or more variables with same name.
%  When reading from multi-file datasets, use this option to concatenate the
%  values read from several accesses into a single Matlab variable. This is
%  intended for interface programs which build up lists of URLs and pass
%  them to loaddap for evaluation. Note that this option works only for
%  variables of two or less dimension.
%
%  NB: You *must* supply the URLs whose variables are to be concatenated in a
%  single invocation of loaddap. -k will not work across two or more calls
%  to loaddap. E.G.: loaddap('-k', '<URL1> <URL2') will work, calling
%  loaddap twice with -k (once for URL1 and once for URL2) won't work.
%  
%  The `-n' command switch causes variable names to be built using the
%  complete name of the variable, including all the constructor types which
%  contain it. Without `-n' variables are named using the name of the leaf
%  variable. 
%  
%  The `-s' option can only be used when assigning the values accessed by
%  loaddap to a vector. If `-s' is used in this situation, then the first
%  variable in the vector will be set to a vector of strings which name
%  the successive variables.
%
%  The `-A' option provides a way to access the DAS object of a dataset.
%  This option reads the dataset's DAS object and reformats it to match the 
%  Hierarchy of the DDS. Each the attributes are recorded in a Matlab 1x1
%  Structure. The names of variables are translated so that all the WWW
%  escape sequences are mapped to underscore. Each variable also has a
%  `synthetic' attribute DODS_ML_Real_Name which contains the variable's
%  original name, including any characters (e.g., %) that would normally
%  make Matlab gag. Each Array variable has a synthetic attribute
%  DODS_ML_Size. This attribute is a vector of floats which contains the size
%  of each dimension of the array.
%
%  The `-F' option is needed when reading from datasets that return as string
%  values that should be interned as numbers. This is a change from previous
%  values of loaddap/writeval and introduces potential incompatibilities
%  with version 1.5 and prior. In other words you'll need to change your
%  software if it used version 1.5 or earlier!
%
%  NB: While DAS objects are separate from the DDS (data) objects in DODS,
%  once loaddap reads the information from the writeval client program they
%  are treated no differently than data objects. Each attribute container is
%  interned as if it was a Structure variable in the DDS object. 
%  
% INPUT:
%  A DAP2 URL optionally prefixed by command options.
%
% OUTPUT:
%  One or more Matlab variables.
%
% EXAMPLES:
%  x = loaddap('-A', 'http://dods.gso.uri.edu/cgi-bin/nph-nc/data/coads.nc')
%       -> Returns a Matlab Structure to x that contains the attributes
%          for the named dataset.
%
%  loaddap('http://dods.gso.uri.edu/cgi-bin/nph-nc/data/coads.nc?SST[0:0][0:89][0:179]')
%	-> Returns Sea Surface Temperature data from the COADS
%	   climatology data set at URI. Note that the values will be bound to
%          a variable named `SST' in the current Matlab workspace.
%
%  temps = loaddap('http://dods.gso.uri.edu/cgi-bin/nph-nc/data/coads.nc?SST[0:0][0:89][0:179]')
%	-> Returns Sea Surface Temperature data from the COADS
%	   climatology data set at URI *and stores it in the variable
%          `temps"*. Explicitly assigning the values accessed by loaddap to
%          a variable is one way to control which names are interned in the
%          Matlab workspace. See the following example for a second method.
%
%  loaddap('http://dods.gso.uri.edu/cgi-bin/nph-nc/data/fnoc1.nc?u[0:0][0:16][0:20] -r u:wind_speed_u_comp')
%       -> Returns the variable `u' from the fnoc1.nc dataset and interns it 
%          in Matlab as `wind_speed_u_comp'.
%  
%  loaddap('-A', 'http://dods.gso.uri.edu/cgi-bin/nph-nc/data/fnoc1.nc -c NC_GLOBAL')
%       -> Returns the attributes in the NC_GLOBAL container of the fnoc1
%          dataset. 
%
% CALLER: general purpose
% CALLEE: loaddap.mex
%
% AUTHORS: Glenn Flierl, MIT
%	   James Gallagher, OPeNDAP
%---------------------------------------------------------------------
