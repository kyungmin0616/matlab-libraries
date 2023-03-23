function nc_addhist ( ncfile, attval )
% NC_ADDHIST:  adds text to a global history attribute
%
% NC_ADDHIST(NCFILE,TEXT) adds the TEXT string to the standard convention
% "history" global attribute of the netCDF file NCFILE.  The string is 
% prepended, rather than appended.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Id: nc_addhist.m 2659 2009-04-01 17:38:36Z johnevans007 $
% $LastChangedDate: 2009-04-01 13:38:36 -0400 (Wed, 01 Apr 2009) $
% $LastChangedRevision: 2659 $
% $LastChangedBy: johnevans007 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(2,2,nargin,'struct'));

if ~exist(ncfile,'file')
	error ( 'SNCTOOLS:NC_ADDHIST:badFilename', '%s does not exist', ncfile );
end
if ~ischar(attval)
	error ( 'SNCTOOLS:NC_ADDHIST:badDatatype', ...
	        'history attribute addition must be character.' );
end


try
	old_hist = nc_attget ( ncfile, nc_global, 'history' );
catch %#ok<CTCH>
	%
	% The history attribute must not have existed.  That's ok.
	old_hist = '';
end


if isempty(old_hist)
	new_history = sprintf ( '%s:  %s', datestr(now), attval );
else
	new_history = sprintf ( '%s:  %s\n%s', datestr(now), attval, old_hist );
end
nc_attput ( ncfile, nc_global, 'history', new_history );



