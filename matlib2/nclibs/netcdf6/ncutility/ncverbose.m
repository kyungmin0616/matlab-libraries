function ncverbose

% NCVerbose -- Set NetCDF options to "verbose".
%  NCVerbose (no argument) sets the NetCDF options
%   to "verbose".
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jun-1997 16:54:35.

mexcdf('setopts', mexcdf('parameter', 'verbose'))
