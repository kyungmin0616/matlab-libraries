function nccopy_vars(file1,file2,variables)
%function nccopy_vars(file1,file2,variables)
%
% Copy the content of file1 into file2  for
% the variables contained in VARIABLES
% EXAMPLE: 
% VARIABLES={'ocean_time' 'zeta' 'temp' 'salt'  'u'    'v' 'ubar'  'vbar'  };
% nccopy_vars(file1,file2,variables)
% Manu - edl@ucsd.edu
% 

if nargin < 3
   notoucVar={'none'};
end
   
ncold=netcdf(file1);
ncnew=netcdf(file2,'w');

% get the list of variables (myvar is a pointer it
% does not contain the actual names which you need to 
% get using ncnames).

% loop on number of variables.
for i=1: length(variables)
 %get their actual name
 varname=variables{i};
 disp(['Assigning variable ',char(varname)]);
 ncnew{char(varname)}(:)=ncold{char(varname)}(:);
end

close(ncold); close(ncnew);

